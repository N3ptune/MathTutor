import { useContext, useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { supabase } from "../supabase";
import { AuthState } from "../authState";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";
import ProficiencyRing from "@/components/ProficiencyRing";

export default function Section() {
  const { sectionId } = useParams();
  const { supabaseUser } = useContext(AuthState);
  const [problems, setProblems] = useState([]);
  const [courseId, setCourseId] = useState(null); // store courseId
  const [generating, setGenerating] = useState(false);
  const [generatingPersonal, setGeneratingPersonal] = useState(false);
  const [proficiency, setProficiency] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    if (!supabaseUser) return;

    async function fetchProblems() {
      try {
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
          .select("courseId")
          .eq("sectionId", sectionId)
          .single();

        if (sectionError) throw sectionError;

        setCourseId(sectionData.courseId);

        const { data: profData, error: profError } = await supabase
          .from("proficiency")
          .select("rating, examPassed")
          .eq("userId", supabaseUser.userId)
          .eq("sectionId", sectionId)
          .maybeSingle();

        if (profError) throw profError;

        setProficiency(profData);
      } catch (err) {
        console.error("Failed to fetch problems:", err);
      }
    }

    fetchProblems();
  }, [sectionId, supabaseUser]);

  const generateProblem = async (personal) => {
    if (!courseId) {
      console.error("Cannot generate problem without courseId");
      return;
    }

    personal ? setGeneratingPersonal(true) : setGenerating(true);
    try {
      const apiUrl = import.meta.env.VITE_API_URL || "http://localhost:8000";
      const { data: { session } } = await supabase.auth.getSession();
      const res = await fetch(`${apiUrl}/api/problem_generation/generate/`, {
      method: "POST",
      headers: { Authorization: `Bearer ${session?.access_token}` },
      body: new URLSearchParams({
        section_id: sectionId,
        course_id: courseId,
        personal: personal ? "true" : "false",
      }),
    });

      const data = await res.json();

      if (res.ok && data.status === "success") {
        setProblems((prev) => [...prev, data.problem]);
      } else {
        console.error("Failed to generate problem:", data);
      }
    } catch (err) {
      console.error(err);
    } finally {
      personal ? setGeneratingPersonal(false) : setGenerating(false);
    }
  };

  return (
    <div className="max-w-6xl mx-auto px-6 py-10">
      <Button variant="ghost" size="sm" className="mb-4" onClick={() => navigate(-1)}>
        <ArrowLeft className="size-4" />
        Back
      </Button>

      <div className="flex items-center justify-between mb-8 gap-6">
        <h1 className="text-3xl font-bold">Section {sectionId}</h1>
        <div className="flex items-center gap-4">
          <ProficiencyRing rating={proficiency?.rating || 0} examPassed={proficiency?.examPassed || false} />
          <Button variant="outline" onClick={() => navigate(`/section/${sectionId}/exam`)}>
            Take Proficiency Exam
          </Button>
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        {problems.map((problem) => (
          <Card key={problem.problemId || problem.id}>
            <CardHeader>
              <CardTitle>{problem.title || `Problem ${problem.problemId || problem.id}`}</CardTitle>
              {problem.source === "user" && (
                <span className="text-xs text-muted-foreground">Your practice problem</span>
              )}
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

        {/* Generate Problem Cards */}
        {courseId && (
          <>
            <Card key="generate-problem">
              <CardHeader>
                <CardTitle>Generate Problem</CardTitle>
              </CardHeader>
              <CardContent>
                <Button
                  className="w-full"
                  onClick={() => generateProblem(false)}
                  disabled={generating}
                >
                  {generating ? "Generating..." : "Generate Problem"}
                </Button>
              </CardContent>
            </Card>

            <Card key="generate-personal-problem">
              <CardHeader>
                <CardTitle>Practice on Your Own</CardTitle>
              </CardHeader>
              <CardContent>
                <Button
                  className="w-full"
                  variant="outline"
                  onClick={() => generateProblem(true)}
                  disabled={generatingPersonal}
                >
                  {generatingPersonal ? "Generating..." : "Generate Personal Problem"}
                </Button>
              </CardContent>
            </Card>
          </>
        )}
      </div>
    </div>
  );
}
