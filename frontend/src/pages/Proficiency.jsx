import { useContext, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "../supabase.js";
import { AuthState } from "../authState.jsx";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";
import ProficiencyRing from "@/components/ProficiencyRing";

export default function Proficiency() {
  const { supabaseUser } = useContext(AuthState);
  const [courses, setCourses] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    if (!supabaseUser) return;

    async function fetchBreakdown() {
      try {
        const { data: enrollmentData, error: enrollError } = await supabase
          .from("user_course")
          .select("courseId")
          .eq("userId", supabaseUser.userId);

        if (enrollError) throw enrollError;

        const courseIds = (enrollmentData || []).map((e) => e.courseId);
        if (courseIds.length === 0) {
          setCourses([]);
          return;
        }

        const { data: courseData, error: courseError } = await supabase
          .from("course")
          .select("courseId, name")
          .in("courseId", courseIds);

        if (courseError) throw courseError;

        const { data: sectionData, error: sectionError } = await supabase
          .from("section")
          .select("sectionId, name, courseId")
          .in("courseId", courseIds);

        if (sectionError) throw sectionError;

        const sectionIds = (sectionData || []).map((s) => s.sectionId);

        let profRows = [];
        if (sectionIds.length > 0) {
          const { data: profData, error: profError } = await supabase
            .from("proficiency")
            .select("sectionId, rating, examPassed")
            .eq("userId", supabaseUser.userId)
            .in("sectionId", sectionIds);

          if (profError) throw profError;
          profRows = profData || [];
        }

        const profBySection = Object.fromEntries(profRows.map((p) => [p.sectionId, p]));

        const coursesWithSections = (courseData || []).map((course) => {
          const sections = (sectionData || [])
            .filter((s) => s.courseId === course.courseId)
            .map((s) => ({
              sectionId: s.sectionId,
              name: s.name,
              rating: profBySection[s.sectionId]?.rating || 0,
              examPassed: profBySection[s.sectionId]?.examPassed || false,
            }));

          const averageRating = sections.length
            ? sections.reduce((sum, s) => sum + s.rating, 0) / sections.length
            : 0;

          return { ...course, sections, averageRating };
        });

        setCourses(coursesWithSections);
      } catch (err) {
        console.error("Failed to fetch proficiency breakdown:", err);
      }
    }

    fetchBreakdown();
  }, [supabaseUser]);

  return (
    <div className="max-w-6xl mx-auto px-6 py-10">
      <Button variant="ghost" size="sm" className="mb-4" onClick={() => navigate("/dashboard")}>
        <ArrowLeft className="size-4" />
        Back to Dashboard
      </Button>
      <h1 className="text-3xl font-bold mb-8">Proficiency</h1>

      {courses.length === 0 && (
        <p className="text-muted-foreground text-center">Enroll in a class to start tracking proficiency.</p>
      )}

      <div className="flex flex-col gap-12">
        {courses.map((course) => (
          <section key={course.courseId}>
            <div className="flex items-center gap-6 mb-6">
              <ProficiencyRing rating={course.averageRating} size={80} strokeWidth={8} />
              <div>
                <h2 className="text-2xl font-semibold">{course.name}</h2>
                <p className="text-muted-foreground text-sm">
                  {course.sections.length} section{course.sections.length !== 1 ? "s" : ""}
                </p>
              </div>
            </div>

            {course.sections.length > 0 ? (
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                {course.sections.map((section) => (
                  <Card key={section.sectionId}>
                    <CardHeader className="flex flex-row items-center justify-between gap-4">
                      <CardTitle className="text-base">{section.name}</CardTitle>
                      <ProficiencyRing rating={section.rating} examPassed={section.examPassed} size={48} strokeWidth={5} />
                    </CardHeader>
                    <CardContent className="flex flex-col gap-2">
                      <Button
                        className="w-full"
                        variant="outline"
                        onClick={() => navigate(`/section/${section.sectionId}`)}
                      >
                        Go to Section
                      </Button>
                      {!section.examPassed && (
                        <Button
                          className="w-full"
                          onClick={() => navigate(`/section/${section.sectionId}/exam`)}
                        >
                          Take Proficiency Exam
                        </Button>
                      )}
                    </CardContent>
                  </Card>
                ))}
              </div>
            ) : (
              <p className="text-muted-foreground">No sections in this class yet.</p>
            )}
          </section>
        ))}
      </div>
    </div>
  );
}
