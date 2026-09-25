import { useContext, useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "../supabase.js";
import { AuthState } from "../authState.jsx";
import { Card, CardHeader, CardTitle, CardAction, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { X } from "lucide-react";
import ProficiencyRing from "@/components/ProficiencyRing";
import LoadingOverlay from "@/components/LoadingOverlay";
import ErrorMessage from "@/components/ErrorMessage";
import { apiFetch, friendlyError } from "@/lib/api";
import { usePageLoad } from "@/lib/usePageLoad";

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

  const [actionError, setActionError] = useState("");
  const [billing, setBilling] = useState(null);

  const { loading, error: loadError, retry } = usePageLoad(async () => {
    const { data: enrollmentData, error: enrollError } = await supabase
      .from("user_course")
      .select("courseId")
      .eq("userId", supabaseUser.userId);

    if (enrollError) throw enrollError;

    const courseIds = (enrollmentData || []).map((e) => e.courseId);

    await Promise.all([
      loadCourses(courseIds),
      courseIds.length > 0 ? loadCourseProficiencies(courseIds) : setCourseProficiencies([]),
      loadRecentSections(),
      loadBilling(),
    ]);
  }, [supabaseUser], Boolean(supabaseUser));

  async function loadCourses(courseIds) {
    if (courseIds.length === 0) {
      setCourses([]);
      return;
    }

    const { data: courseData, error: courseError } = await supabase
      .from("course")
      .select("*")
      .in("courseId", courseIds);

    if (courseError) throw courseError;

    setCourses(courseData);
  }

  // One ring per enrolled class: the average across all of that class's sections
  // (sections you haven't touched yet count as 0, so this reads as "% of the class mastered").
  async function loadCourseProficiencies(courseIds) {
    const { data: courseData, error: courseError } = await supabase
      .from("course")
      .select("courseId, name")
      .in("courseId", courseIds);

    if (courseError) throw courseError;

    const { data: sectionData, error: sectionError } = await supabase
      .from("section")
      .select("sectionId, courseId")
      .in("courseId", courseIds);

    if (sectionError) throw sectionError;

    const sectionIds = (sectionData || []).map((s) => s.sectionId);

    let profRows = [];
    if (sectionIds.length > 0) {
      const { data: profData, error: profError } = await supabase
        .from("proficiency")
        .select("sectionId, rating")
        .eq("userId", supabaseUser.userId)
        .in("sectionId", sectionIds);

      if (profError) throw profError;
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
  }

  // Usage is a nice-to-have here; the dashboard still works if the backend is unreachable
  async function loadBilling() {
    try {
      setBilling(await apiFetch("/api/billing/status", { method: "GET" }));
    } catch (err) {
      console.error("Failed to load plan usage:", err);
      setBilling(null);
    }
  }

  // The 3 sections this student most recently attempted a problem in, newest first.
  async function loadRecentSections() {
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
      setCourses((prev) => prev.filter((c) => c.courseId !== courseId));
      setCourseProficiencies((prev) => prev.filter((cp) => cp.courseId !== courseId));
    } catch (err) {
      console.error("Failed to unregister from class:", err);
      setActionError(`Unregistering failed. ${friendlyError(err)}`);
    } finally {
      setUnregisteringId(null);
    }
  }

  return (
    <div className="w-full max-w-6xl mx-auto px-4 sm:px-6 py-6 sm:py-10 flex flex-col gap-10 sm:gap-12">
      <LoadingOverlay show={loading} message="Loading your dashboard..." />
      <LoadingOverlay show={unregisteringId !== null} message="Unregistering..." />

      {/* Header Section */}
      <div className="text-center">
        <h1 className="text-3xl sm:text-4xl font-bold text-primary break-words">
          Welcome, {supabaseUser?.firstName || "Student"}
        </h1>
      </div>

      {loadError && <ErrorMessage message={loadError} onRetry={retry} />}

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
            <CardHeader className="flex flex-row items-center justify-between gap-4">
              <CardTitle>AI Checks</CardTitle>
              <Button variant="ghost" size="sm" onClick={() => navigate("/account")}>
                {billing?.plan === "pro" ? "Manage" : "Upgrade"}
              </Button>
            </CardHeader>
            <CardContent className="flex flex-col justify-center gap-2 min-h-32 py-4">
              {billing ? (
                <>
                  <p className="text-3xl font-bold">
                    {Math.max(billing.actionsLimit - billing.actionsUsed, 0)}
                    <span className="text-base font-normal text-muted-foreground"> left this month</span>
                  </p>
                  <p className="text-sm text-muted-foreground">
                    {billing.planLabel} plan: {billing.actionsUsed} of {billing.actionsLimit} used
                  </p>
                </>
              ) : (
                <p className="text-muted-foreground text-center">Usage unavailable right now.</p>
              )}
            </CardContent>
          </Card>
        </div>
      </section>

      <Separator />

      {/* Classes Section */}
      <section>
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-6">
          <h2 className="text-2xl font-semibold">Your Classes</h2>
          <Button variant="outline" className="w-full sm:w-auto" onClick={() => navigate("/register")}>
            Register for a Class
          </Button>
        </div>

        <ErrorMessage message={actionError} className="mb-4" />

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
