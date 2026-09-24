import { useContext, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "../supabase.js";
import { AuthState } from "../authState.jsx";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";

export default function RegisterClasses() {
  const { supabaseUser } = useContext(AuthState);
  const navigate = useNavigate();

  const [courses, setCourses] = useState([]);
  const [enrolledIds, setEnrolledIds] = useState(new Set());
  const [registeringId, setRegisteringId] = useState(null);
  const [unregisteringId, setUnregisteringId] = useState(null);

  useEffect(() => {
    if (!supabaseUser) return;

    async function fetchCoursesAndEnrollments() {
      try {
        const { data: courseData, error: courseError } = await supabase
          .from("course")
          .select("*")
          .order("courseId", { ascending: true });

        if (courseError) throw courseError;
        setCourses(courseData);

        const { data: enrollmentData, error: enrollError } = await supabase
          .from("user_course")
          .select("courseId")
          .eq("userId", supabaseUser.userId);

        if (enrollError) throw enrollError;
        setEnrolledIds(new Set(enrollmentData.map((e) => e.courseId)));
      } catch (err) {
        console.error("Failed to fetch courses:", err);
      }
    }

    fetchCoursesAndEnrollments();
  }, [supabaseUser]);

  async function handleRegister(courseId) {
    setRegisteringId(courseId);
    try {
      const { error } = await supabase
        .from("user_course")
        .insert([{ userId: supabaseUser.userId, courseId }]);

      if (error) throw error;
      setEnrolledIds((prev) => new Set(prev).add(courseId));
    } catch (err) {
      console.error("Failed to register for class:", err);
      alert("Registration failed: " + err.message);
    } finally {
      setRegisteringId(null);
    }
  }

  async function handleUnregister(courseId) {
    setUnregisteringId(courseId);
    try {
      const { error } = await supabase
        .from("user_course")
        .delete()
        .eq("userId", supabaseUser.userId)
        .eq("courseId", courseId);

      if (error) throw error;
      setEnrolledIds((prev) => {
        const next = new Set(prev);
        next.delete(courseId);
        return next;
      });
    } catch (err) {
      console.error("Failed to unregister from class:", err);
      alert("Unregistering failed: " + err.message);
    } finally {
      setUnregisteringId(null);
    }
  }

  return (
    <div className="max-w-6xl mx-auto px-6 py-10">
      <Button variant="ghost" size="sm" className="mb-4" onClick={() => navigate("/dashboard")}>
        <ArrowLeft className="size-4" />
        Back to Dashboard
      </Button>
      <h1 className="text-3xl font-bold mb-8">Register for Classes</h1>

      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        {courses.length > 0 ? (
          courses.map((course) => {
            const isEnrolled = enrolledIds.has(course.courseId);
            const isRegistering = registeringId === course.courseId;
            const isUnregistering = unregisteringId === course.courseId;

            return (
              <Card key={course.courseId}>
                <CardHeader>
                  <CardTitle>{course.name}</CardTitle>
                </CardHeader>
                <CardContent>
                  {isEnrolled ? (
                    <Button
                      className="w-full"
                      variant="destructive"
                      disabled={isUnregistering}
                      onClick={() => handleUnregister(course.courseId)}
                    >
                      {isUnregistering ? "Unregistering..." : "Unregister"}
                    </Button>
                  ) : (
                    <Button
                      className="w-full"
                      disabled={isRegistering}
                      onClick={() => handleRegister(course.courseId)}
                    >
                      {isRegistering ? "Registering..." : "Register"}
                    </Button>
                  )}
                </CardContent>
              </Card>
            );
          })
        ) : (
          <p className="col-span-full text-center text-muted-foreground">No classes available yet.</p>
        )}
      </div>
    </div>
  );
}
