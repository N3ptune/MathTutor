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
  const navigate = useNavigate();

  useEffect(() => {
    if (!supabaseUser) return;

    async function fetchProblems() {
      try {
        const { data: problemsData, error } = await supabase
          .from("problem")
          .select("*")
          .eq("sectionId", sectionId);

        if (error) throw error;

        setProblems(problemsData);
      } catch (err) {
        console.error("Failed to fetch problems:", err);
      }
    }

    fetchProblems();
  }, [sectionId, supabaseUser]);

  return (
    <div className="max-w-6xl mx-auto px-6 py-10">
      <Button variant="ghost" size="sm" className="mb-4" onClick={() => navigate(-1)}>
        <ArrowLeft className="size-4" />
        Back
      </Button>
      <h1 className="text-3xl font-bold mb-8">Section {sectionId}</h1>

      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        {problems.length > 0 ? (
          problems.map((problem) => (
            <Card key={problem.problemId}>
              <CardHeader>
                <CardTitle>{problem.title || `Problem ${problem.problemId}`}</CardTitle>
              </CardHeader>
              <CardContent>
                <Button
                  className="w-full"
                  onClick={() => navigate(`/problem/${problem.problemId}`)}
                >
                  Go to Problem
                </Button>
              </CardContent>
            </Card>
          ))
        ) : (
          <p className="col-span-full text-center text-muted-foreground">No problems available for this section yet.</p>
        )}
      </div>
    </div>
  );
}
