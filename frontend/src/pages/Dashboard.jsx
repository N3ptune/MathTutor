import { useContext, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "../supabase.js";
import { AuthState } from "../authState.jsx";
import { Card, CardHeader, CardTitle, CardAction, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { X } from "lucide-react";
import ProficiencyRing from "@/components/ProficiencyRing";

// How many recent attempts to scan for distinct sections. Attempts can repeat a
// section, so this needs to be generously larger than the 3 sections we display.
const RECENT_ATTEMPT_SCAN_LIMIT = 20;
const RECENT_SECTIONS_SHOWN = 3;

export default function Dashboard() {
  const { supabaseUser } = useContext(AuthState);
  const [courses, setCourses] = useState([]);
  const [courseProficiencies, setCourseProficiencies] = useState([]);
  const [recentSections, setRecentSections] = useState([]);
  const [unregisteringId, setUnregisteringId] = useState(null);
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

    // One ring per enrolled class: the average across all of that class's sections
    // (sections you haven't touched yet count as 0, so this reads as "% of the class mastered").
    async function fetchCourseProficiencies() {
      try {
        const { data: enrollmentData } = await supabase
          .from("user_course")
          .select("courseId")
          .eq("userId", supabaseUser.userId);

        const courseIds = (enrollmentData || []).map((e) => e.courseId);
        if (courseIds.length === 0) {
          setCourseProficiencies([]);
          return;
        }

        const { data: courseData } = await supabase
          .from("course")
          .select("courseId, name")
          .in("courseId", courseIds);

        const { data: sectionData } = await supabase
          .from("section")
          .select("sectionId, courseId")
          .in("courseId", courseIds);

        const sectionIds = (sectionData || []).map((s) => s.sectionId);

        let profRows = [];
        if (sectionIds.length > 0) {
          const { data: profData } = await supabase
            .from("proficiency")
            .select("sectionId, rating")
            .eq("userId", supabaseUser.userId)
            .in("sectionId", sectionIds);
          profRows = profData || [];
        }

        const ratingBySection = Object.fromEntries(profRows.map((p) => [p.sectionId, p.rating]));

        const results = (courseData || []).map((course) => {
          const sections = (sectionData || []).filter((s) => s.courseId === course.courseId);
          const rating = sections.length
            ? sections.reduce((sum, s) => sum + (ratingBySection[s.sectionId] || 0), 0) / sections.length
            : 0;
          return { courseId: course.courseId, name: course.name, rating };
        });

        setCourseProficiencies(results);
      } catch (err) {
        console.error("Failed to fetch course proficiencies:", err);
      }
    }

    // The 3 sections this student most recently attempted a problem in, newest first.
    async function fetchRecentSections() {
      try {
        const { data: attemptData, error } = await supabase
          .from("user_problem_attempt")
          .select("createdAt, problem(sectionId, section(sectionId, name, course(name)))")
          .eq("userId", supabaseUser.userId)
          .order("createdAt", { ascending: false })
          .limit(RECENT_ATTEMPT_SCAN_LIMIT);

        if (error) throw error;

        const seen = new Set();
        const results = [];
        for (const attempt of attemptData || []) {
          const section = attempt.problem?.section;
          if (!section || seen.has(section.sectionId)) continue;
          seen.add(section.sectionId);
          results.push({
            sectionId: section.sectionId,
            name: section.name,
            courseName: section.course?.name || "",
          });
          if (results.length === RECENT_SECTIONS_SHOWN) break;
        }

        setRecentSections(results);
      } catch (err) {
        console.error("Failed to fetch recent activity:", err);
      }
    }

    fetchCourses();
    fetchCourseProficiencies();
    fetchRecentSections();
  }, [supabaseUser]);

  async function handleUnregister(courseId) {
    setUnregisteringId(courseId);
    try {
      const { error } = await supabase
        .from("user_course")
        .delete()
        .eq("userId", supabaseUser.userId)
        .eq("courseId", courseId);

      if (error) throw error;
      setCourses((prev) => prev.filter((c) => c.courseId !== courseId));
      setCourseProficiencies((prev) => prev.filter((cp) => cp.courseId !== courseId));
    } catch (err) {
      console.error("Failed to unregister from class:", err);
      alert("Unregistering failed: " + err.message);
    } finally {
      setUnregisteringId(null);
    }
  }

  return (
    <div className="w-full max-w-6xl mx-auto px-6 py-10 flex flex-col gap-12">

      {/* Header Section */}
      <div className="text-center">
        <h1 className="text-4xl font-bold text-primary">
          Welcome, {supabaseUser?.firstName || "Student"}
        </h1>
      </div>

      {/* Progress Section */}
      <section>
        <h2 className="text-2xl font-semibold text-center mb-6">Your Progress</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between gap-4">
              <CardTitle>Proficiency Chart</CardTitle>
              {courseProficiencies.length > 0 && (
                <Button variant="ghost" size="sm" onClick={() => navigate("/proficiency")}>
                  View Details
                </Button>
              )}
            </CardHeader>
            <CardContent className="flex items-center justify-center min-h-32 py-4">
              {courseProficiencies.length === 0 ? (
                <p className="text-muted-foreground text-center">Enroll in a class to start tracking proficiency.</p>
              ) : (
                <div className="flex flex-wrap justify-center gap-6">
                  {courseProficiencies.map((cp) => (
                    <button
                      key={cp.courseId}
                      onClick={() => navigate("/proficiency")}
                      className="cursor-pointer"
                    >
                      <ProficiencyRing rating={cp.rating} size={64} strokeWidth={6} label={cp.name} />
                    </button>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>
          <Card>
            <CardHeader>
              <CardTitle>Recent Activity</CardTitle>
            </CardHeader>
            <CardContent className="flex flex-col justify-center gap-2 min-h-32 py-4">
              {recentSections.length === 0 ? (
                <p className="text-muted-foreground text-center">No recent activity yet.</p>
              ) : (
                recentSections.map((section) => (
                  <button
                    key={section.sectionId}
                    onClick={() => navigate(`/section/${section.sectionId}`)}
                    className="flex flex-col items-start text-left w-full rounded-md border px-3 py-2 hover:bg-accent transition-colors cursor-pointer"
                  >
                    <span className="font-medium">{section.name}</span>
                    {section.courseName && (
                      <span className="text-xs text-muted-foreground">{section.courseName}</span>
                    )}
                  </button>
                ))
              )}
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
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-2xl font-semibold">Your Classes</h2>
          <Button variant="outline" onClick={() => navigate("/register")}>
            Register for a Class
          </Button>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
          {courses.length > 0 ? (
            courses.map((course) => (
              <Card key={course.courseId}>
                <CardHeader>
                  <CardTitle>{course.name}</CardTitle>
                  <CardAction>
                    <Button
                      variant="ghost"
                      size="icon"
                      className="size-7 text-muted-foreground hover:text-destructive"
                      disabled={unregisteringId === course.courseId}
                      onClick={() => handleUnregister(course.courseId)}
                      aria-label={`Unregister from ${course.name}`}
                    >
                      <X className="size-4" />
                    </Button>
                  </CardAction>
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
