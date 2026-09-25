import { useContext, useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "../supabase.js";
import { AuthState } from "../authState.jsx";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";
import LoadingOverlay from "@/components/LoadingOverlay";
import ErrorMessage from "@/components/ErrorMessage";
import { friendlyError } from "@/lib/api";
import { usePageLoad } from "@/lib/usePageLoad";

export default function RegisterClasses() {
  const { supabaseUser } = useContext(AuthState);
  const navigate = useNavigate();

  const [courses, setCourses] = useState([]);
  const [enrolledIds, setEnrolledIds] = useState(new Set());
  const [registeringId, setRegisteringId] = useState(null);
  const [unregisteringId, setUnregisteringId] = useState(null);

  const [actionError, setActionError] = useState("");

  const { loading, error: loadError, retry } = usePageLoad(async () => {
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
  }, [supabaseUser], Boolean(supabaseUser));

  async function handleRegister(courseId) {
    setRegisteringId(courseId);
    setActionError("");
    try {
      const { error } = await supabase
        .from("user_course")
        .insert([{ userId: supabaseUser.userId, courseId }]);

      if (error) throw error;
      setEnrolledIds((prev) => new Set(prev).add(courseId));
    } catch (err) {
      console.error("Failed to register for class:", err);
      setActionError(`Registration failed. ${friendlyError(err)}`);
    } finally {
      setRegisteringId(null);
    }
  }

  async function handleUnregister(courseId) {
    setUnregisteringId(courseId);
    setActionError("");
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
      setActionError(`Unregistering failed. ${friendlyError(err)}`);
    } finally {
      setUnregisteringId(null);
    }
  }

  return (
    <div className="max-w-6xl mx-auto px-4 sm:px-6 py-6 sm:py-10">
      <LoadingOverlay show={loading} message="Loading classes..." />
      <LoadingOverlay show={registeringId !== null} message="Registering..." />
      <LoadingOverlay show={unregisteringId !== null} message="Unregistering..." />

      <Button variant="ghost" size="sm" className="mb-4" onClick={() => navigate("/dashboard")}>
        <ArrowLeft className="size-4" />
        Back to Dashboard
      </Button>
      <h1 className="text-2xl sm:text-3xl font-bold mb-8">Register for Classes</h1>

      {loadError && <ErrorMessage message={loadError} onRetry={retry} className="mb-6" />}
      <ErrorMessage message={actionError} className="mb-6" />

      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        {loading || loadError ? null : courses.length > 0 ? (
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
                      Unregister
                    </Button>
                  ) : (
                    <Button
                      className="w-full"
                      disabled={isRegistering}
                      onClick={() => handleRegister(course.courseId)}
                    >
                      Register
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
