import { useContext, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { supabase } from "../supabase";
import { AuthState } from "../authState";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";
import ProficiencyRing from "@/components/ProficiencyRing";
import MathText from "@/components/MathText";
import LoadingOverlay from "@/components/LoadingOverlay";
import ErrorMessage from "@/components/ErrorMessage";
import { apiFetch, friendlyError } from "@/lib/api";
import { usePageLoad } from "@/lib/usePageLoad";

export default function Section() {
  const { sectionId } = useParams();
  const { supabaseUser } = useContext(AuthState);
  const [problems, setProblems] = useState([]);
  const [courseId, setCourseId] = useState(null); // store courseId
  const [sectionName, setSectionName] = useState("");
  const [generatingPersonal, setGeneratingPersonal] = useState(false);
  const [generateError, setGenerateError] = useState("");
  const [proficiency, setProficiency] = useState(null);
  const navigate = useNavigate();

  const courseProblems = problems.filter((p) => p.source !== "user");
  const personalProblems = problems.filter((p) => p.source === "user");

  const { loading, error: loadError, retry } = usePageLoad(async () => {
    // Fetch problems along with section info to get courseId
    const { data: problemsData, error } = await supabase
      .from("problem")
      .select("*, section(courseId)")
      .eq("sectionId", sectionId);

    if (error) throw error;

    setProblems(problemsData);

    // Look the course up from the section itself so empty sections can still generate
    const { data: sectionData, error: sectionError } = await supabase
      .from("section")
      .select("name, courseId")
      .eq("sectionId", sectionId)
      .single();

    if (sectionError) throw sectionError;

    setCourseId(sectionData.courseId);
    setSectionName(sectionData.name);

    const { data: profData, error: profError } = await supabase
      .from("proficiency")
      .select("rating, examPassed")
      .eq("userId", supabaseUser.userId)
      .eq("sectionId", sectionId)
      .maybeSingle();

    if (profError) throw profError;

    setProficiency(profData);
  }, [sectionId, supabaseUser], Boolean(supabaseUser));

  const generatePersonalProblem = async () => {
    if (!courseId) {
      console.error("Cannot generate problem without courseId");
      return;
    }

    setGeneratingPersonal(true);
    setGenerateError("");
    try {
      const data = await apiFetch("/api/problem_generation/generate/", {
        body: new URLSearchParams({
          section_id: sectionId,
          course_id: courseId,
          personal: "true",
        }),
      });

      if (data?.status !== "success") throw new Error("Problem generation did not succeed");
      setProblems((prev) => [...prev, data.problem]);
    } catch (err) {
      console.error("Failed to generate problem:", err);
      setGenerateError(friendlyError(err));
    } finally {
      setGeneratingPersonal(false);
    }
  };

  return (
    <div className="max-w-6xl mx-auto px-4 sm:px-6 py-6 sm:py-10">
      <LoadingOverlay show={loading} message="Loading section..." />
      <LoadingOverlay show={generatingPersonal} message="Generating a practice problem..." />

      <Button variant="ghost" size="sm" className="mb-4" onClick={() => navigate(-1)}>
        <ArrowLeft className="size-4" />
        Back
      </Button>

      {loadError && <ErrorMessage message={loadError} onRetry={retry} className="mb-6" />}

      <div className="flex flex-col sm:flex-row sm:items-center justify-between mb-8 gap-4 sm:gap-6">
        <h1 className="text-2xl sm:text-3xl font-bold">{sectionName || `Section ${sectionId}`}</h1>
        <div className="flex items-center gap-4">
          <ProficiencyRing rating={proficiency?.rating || 0} examPassed={proficiency?.examPassed || false} />
          <Button variant="outline" onClick={() => navigate(`/section/${sectionId}/exam`)}>
            Take Proficiency Exam
          </Button>
        </div>
      </div>

      {/* Course problems: the shared catalog, visible to everyone in the class */}
      <section className="mb-10">
        <h2 className="text-xl font-semibold mb-4">Course Problems</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 mb-4">
          {courseProblems.map((problem) => (
            <Card key={problem.problemId || problem.id}>
              <CardHeader>
                <CardTitle className="line-clamp-2 leading-snug text-base">
                  <MathText>{problem.problem}</MathText>
                </CardTitle>
              </CardHeader>
              <CardContent>
                <Button
                  className="w-full"
                  onClick={() => navigate(`/problem/${problem.problemId || problem.id}`)}
                >
                  Go to Problem
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>
      </section>

      {/* Generated problems: only the ones this student has generated for their own practice */}
      <section>
        <h2 className="text-xl font-semibold mb-4">Your Generated Problems</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 mb-4">
          {personalProblems.map((problem) => (
            <Card key={problem.problemId || problem.id}>
              <CardHeader>
                <CardTitle className="line-clamp-2 leading-snug text-base">
                  <MathText>{problem.problem}</MathText>
                </CardTitle>
              </CardHeader>
              <CardContent>
                <Button
                  className="w-full"
                  onClick={() => navigate(`/problem/${problem.problemId || problem.id}`)}
                >
                  Go to Problem
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>

        <ErrorMessage message={generateError} onRetry={generatePersonalProblem} className="mb-4" />

        {courseId && (
          <Button
            variant="outline"
            className="w-full sm:w-auto"
            onClick={generatePersonalProblem}
            disabled={generatingPersonal}
          >
            + Generate Personal Problem
          </Button>
        )}
      </section>
    </div>
  );
}
