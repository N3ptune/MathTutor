import { useEffect, useState, useContext } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { supabase } from "../supabase";
import { AuthState } from "../authState.jsx";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import MathText from "@/components/MathText";
import { Card, CardContent } from "@/components/ui/card";
import ProficiencyRing from "@/components/ProficiencyRing";
import { ArrowLeft } from "lucide-react";

export default function ProficiencyExam() {
  const { sectionId } = useParams();
  const navigate = useNavigate();
  const { supabaseUser } = useContext(AuthState);

  const [examAttemptId, setExamAttemptId] = useState(null);
  const [questions, setQuestions] = useState([]);
  const [answers, setAnswers] = useState({});
  const [starting, setStarting] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [result, setResult] = useState(null);
  const [error, setError] = useState("");

  useEffect(() => {
    if (!supabaseUser) return;

    async function startExam() {
      setStarting(true);
      setError("");
      try {
        const apiUrl = import.meta.env.VITE_API_URL || "http://localhost:8000";
        const { data: { session } } = await supabase.auth.getSession();
        const res = await fetch(`${apiUrl}/api/proficiency/exam/start`, {
          method: "POST",
          headers: {
            Authorization: `Bearer ${session?.access_token}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ sectionId: Number(sectionId) }),
        });

        const data = await res.json();
        if (!res.ok) throw new Error(data.detail || "Failed to start exam");

        setExamAttemptId(data.examAttemptId);
        setQuestions(data.questions);
      } catch (err) {
        console.error("Failed to start exam:", err);
        setError("Couldn't start the exam. Please try again.");
      } finally {
        setStarting(false);
      }
    }

    startExam();
  }, [sectionId, supabaseUser]);

  const updateAnswer = (examQuestionId, value) => {
    setAnswers((prev) => ({ ...prev, [examQuestionId]: value }));
  };

  const handleSubmit = async () => {
    setSubmitting(true);
    setError("");
    try {
      const apiUrl = import.meta.env.VITE_API_URL || "http://localhost:8000";
      const { data: { session } } = await supabase.auth.getSession();
      const res = await fetch(`${apiUrl}/api/proficiency/exam/submit`, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${session?.access_token}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          examAttemptId,
          answers: questions.map((q) => ({
            examQuestionId: q.examQuestionId,
            answer: answers[q.examQuestionId] || "",
          })),
        }),
      });

      const data = await res.json();
      if (!res.ok) throw new Error(data.detail || "Failed to submit exam");

      setResult(data);
    } catch (err) {
      console.error("Failed to submit exam:", err);
      setError("Couldn't submit the exam. Please try again.");
    } finally {
      setSubmitting(false);
    }
  };

  const feedbackByQuestion = Object.fromEntries((result?.feedback || []).map((f) => [f.examQuestionId, f]));

  return (
    <div className="max-w-4xl mx-auto px-6 py-10 flex flex-col items-center">
      <div className="w-full mb-4">
        <Button variant="ghost" size="sm" onClick={() => navigate(-1)}>
          <ArrowLeft className="size-4" />
          Back
        </Button>
      </div>
      <h1 className="text-2xl font-bold mb-6">Proficiency Exam</h1>

      {starting && <p className="text-muted-foreground">Preparing your exam...</p>}
      {error && <p className="text-destructive mb-4">{error}</p>}

      {!starting && result && (
        <Card className="w-full mb-8">
          <CardContent className="flex flex-col items-center gap-4 py-6">
            <ProficiencyRing rating={result.score * 100} examPassed={result.passed} size={120} />
            <p className="text-lg font-semibold">
              {result.passed ? "You passed the exam!" : "Not quite there yet."}
            </p>
            {!result.passed && (
              <p className="text-muted-foreground text-center">
                Keep practicing this section and try the exam again when you're ready.
              </p>
            )}
          </CardContent>
        </Card>
      )}

      {!starting && questions.length > 0 && (
        <div className="w-full space-y-6 mb-8">
          {questions.map((q) => (
            <Card key={q.examQuestionId}>
              <CardContent className="space-y-3">
                <MathText as="p" className="text-lg">{q.question}</MathText>

                {result ? (
                  <>
                    <p className="text-sm italic text-muted-foreground">{answers[q.examQuestionId]}</p>
                    <div
                      className={`p-3 rounded-lg text-sm border-l-4 ${
                        feedbackByQuestion[q.examQuestionId]?.isCorrect
                          ? "bg-green-50 border-green-500 dark:bg-green-950/30 dark:border-green-600"
                          : "bg-red-50 border-red-500 dark:bg-red-950/30 dark:border-red-600"
                      }`}
                    >
                      <MathText>{feedbackByQuestion[q.examQuestionId]?.feedback}</MathText>
                    </div>
                  </>
                ) : (
                  <div className="space-y-2">
                    <Label>Your answer</Label>
                    <Input
                      type="text"
                      value={answers[q.examQuestionId] || ""}
                      onChange={(e) => updateAnswer(q.examQuestionId, e.target.value)}
                      placeholder="Enter your answer..."
                    />
                  </div>
                )}
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      {!starting && !result && questions.length > 0 && (
        <Button size="lg" onClick={handleSubmit} disabled={submitting}>
          {submitting ? "Grading..." : "Submit Exam"}
        </Button>
      )}

      {result && (
        <Button size="lg" variant="outline" onClick={() => navigate(`/section/${sectionId}`)}>
          Back to Section
        </Button>
      )}
    </div>
  );
}
