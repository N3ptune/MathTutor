import { useContext, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "../supabase.js";
import { AuthState } from "../authState.jsx";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";

export default function Dashboard() {
  const { supabaseUser } = useContext(AuthState);
  const [courses, setCourses] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    if (!supabaseUser) return;

    async function fetchCourses() {
      try {
        const { data: enrollmentData, error: enrollError } = await supabase
          .from("user_course")
          .select("courseId")
          .eq("userId", supabaseUser.userId);

        if (enrollError) throw enrollError;

        if (enrollmentData.length === 0) {
          setCourses([]);
          return;
        }

        const courseIds = enrollmentData.map((e) => e.courseId);

        const { data: courseData, error: courseError } = await supabase
          .from("course")
          .select("*")
          .in("courseId", courseIds);

        if (courseError) throw courseError;

        setCourses(courseData);
      } catch (err) {
        console.error("Failed to fetch courses:", err);
      }
    }

    fetchCourses();
  }, [supabaseUser]);

  return (
    <div className="w-full max-w-6xl mx-auto px-6 py-10 flex flex-col gap-12">

      {/* Header Section */}
      <div className="text-center">
        <h1 className="text-4xl font-bold text-primary">
          Welcome, {supabaseUser?.email || "Student"}
        </h1>
      </div>

      {/* Progress Section */}
      <section>
        <h2 className="text-2xl font-semibold text-center mb-6">Your Progress</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <Card>
            <CardHeader>
              <CardTitle>Proficiency Chart</CardTitle>
            </CardHeader>
            <CardContent className="flex items-center justify-center h-32 text-muted-foreground">
              Coming soon
            </CardContent>
          </Card>
          <Card>
            <CardHeader>
              <CardTitle>Recent Activity</CardTitle>
            </CardHeader>
            <CardContent className="flex items-center justify-center h-32 text-muted-foreground">
              Coming soon
            </CardContent>
          </Card>
          <Card>
            <CardHeader>
              <CardTitle>Time Spent</CardTitle>
            </CardHeader>
            <CardContent className="flex items-center justify-center h-32 text-muted-foreground">
              Coming soon
            </CardContent>
          </Card>
        </div>
      </section>

      <Separator />

      {/* Classes Section */}
      <section>
        <h2 className="text-2xl font-semibold text-center mb-6">Your Classes</h2>

        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
          {courses.length > 0 ? (
            courses.map((course) => (
              <Card key={course.courseId}>
                <CardHeader>
                  <CardTitle>{course.name}</CardTitle>
                </CardHeader>
                <CardContent>
                  <Button
                    className="w-full"
                    onClick={() => navigate(`/course/${course.courseId}`)}
                  >
                    Go to Class
                  </Button>
                </CardContent>
              </Card>
            ))
          ) : (
            <p className="col-span-full text-center text-muted-foreground">No classes enrolled yet.</p>
          )}
        </div>
      </section>
    </div>
  );
}
