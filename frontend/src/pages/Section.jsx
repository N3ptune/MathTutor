import { useContext, useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { supabase } from "../supabase";
import { AuthState } from "../authState";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";

export default function Section() {
  const { sectionId } = useParams();
  const { supabaseUser } = useContext(AuthState);
  const [problems, setProblems] = useState([]);
  const [courseId, setCourseId] = useState(null); // store courseId
  const [generating, setGenerating] = useState(false);
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

        if (problemsData?.length) {
          setCourseId(problemsData[0].section.courseId);
        }
      } catch (err) {
        console.error("Failed to fetch problems:", err);
      }
    }

    fetchProblems();
  }, [sectionId, supabaseUser]);

  const handleGenerateProblem = async () => {
    if (!courseId) {
      console.error("Cannot generate problem without courseId");
      return;
    }

    setGenerating(true);
    try {
      const BACKEND_URL = import.meta.env.VITE_BACKEND_URL
      const res = await fetch(`${BACKEND_URL}/api/problem_generation/generate/`, {
      method: "POST",
      body: new URLSearchParams({
        section_id: sectionId,
        course_id: courseId,
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
      setGenerating(false);
    }
  };

  return (
    <div className="max-w-6xl mx-auto px-6 py-10">
      <Button variant="ghost" size="sm" className="mb-4" onClick={() => navigate(-1)}>
        <ArrowLeft className="size-4" />
        Back
      </Button>
      <h1 className="text-3xl font-bold mb-8">Section {sectionId}</h1>

      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        {problems.map((problem) => (
          <Card key={problem.problemId || problem.id}>
            <CardHeader>
              <CardTitle>{problem.title || `Problem ${problem.problemId || problem.id}`}</CardTitle>
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

        {/* Generate Problem Card */}
        {courseId && (
          <Card key="generate-problem">
            <CardHeader>
              <CardTitle>Generate Problem</CardTitle>
            </CardHeader>
            <CardContent>
              <Button
                className="w-full"
                onClick={handleGenerateProblem}
                disabled={generating}
              >
                {generating ? "Generating..." : "Generate Problem"}
              </Button>
            </CardContent>
          </Card>
        )}
      </div>
    </div>
  );
}
