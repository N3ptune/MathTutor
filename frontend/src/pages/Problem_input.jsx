import React, { useState, useContext } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { supabase } from "../supabase";
import { AuthState } from "../authState.jsx";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import MathText from "@/components/MathText";
import { Card, CardContent } from "@/components/ui/card";
import LoadingOverlay from "@/components/LoadingOverlay";
import ErrorMessage from "@/components/ErrorMessage";
import StepFeedback, { ResultBanner } from "@/components/StepFeedback";
import AttemptHistory from "@/components/AttemptHistory";
import { apiFetch, friendlyError } from "@/lib/api";
import { usePageLoad } from "@/lib/usePageLoad";
import { canSubmitSteps, nonBlankSteps } from "@/lib/steps";
import { ArrowLeft, X } from "lucide-react";

async function fetchAttempts(userId, problemId) {
  const { data, error } = await supabase
    .from("user_problem_attempt")
    .select("attemptId, createdAt, isCorrect, aiFeedback, steps, stepFeedback, stepCorrect")
    .eq("userId", userId)
    .eq("problemId", problemId)
    .order("createdAt", { ascending: false });

  if (error) throw error;
  return data || [];
}

export default function ProblemInput() {
  const { problemId } = useParams();
  const navigate = useNavigate();
  const { supabaseUser } = useContext(AuthState);

  const [problemText, setProblemText] = useState("");
  const [steps, setSteps] = useState([""]);
  const [feedback, setFeedback] = useState([]);
  const [stepCorrect, setStepCorrect] = useState([]);
  const [allCorrect, setAllCorrect] = useState(null);
  const [isEvaluating, setIsEvaluating] = useState(false);
  const [submitError, setSubmitError] = useState("");
  const [imageFile, setImageFile] = useState(null);
  const [fileInputKey, setFileInputKey] = useState(0);
  const [attempts, setAttempts] = useState([]);
  const [historyError, setHistoryError] = useState("");

  const { loading, error: loadError, retry } = usePageLoad(async () => {
    const { data, error } = await supabase
      .from("problem")
      .select("problem")
      .eq("problemId", problemId)
      .single();

    if (error) throw error;
    setProblemText(data.problem);

    try {
      setAttempts(await fetchAttempts(supabaseUser.userId, problemId));
    } catch (err) {
      // History is secondary; the student can still solve the problem without it
      console.error("Failed to load attempt history:", err);
      setHistoryError("Couldn't load your previous attempts.");
    }
  }, [problemId, supabaseUser], Boolean(supabaseUser));

  const canSubmit = canSubmitSteps(steps, imageFile);

  const convertInput = (text) => {
    return text.replace(/sqrt\(/gi, "√(");
  };

  const clearResult = () => {
    setFeedback([]);
    setStepCorrect([]);
    setAllCorrect(null);
  };

  const updateStep = (index, value) => {
    const newSteps = [...steps];
    newSteps[index] = convertInput(value);
    setSteps(newSteps);
  };

  const addStep = () => setSteps([...steps, ""]);

  const deleteStep = (index) => {
    setSteps(steps.filter((_, i) => i !== index));
    setFeedback(feedback.filter((_, i) => i !== index));
    setStepCorrect(stepCorrect.filter((_, i) => i !== index));
  };

  const handleImageUpload = (event) => {
    const file = event.target.files[0];
    if (!file) return;

    setSteps([""]);
    clearResult();
    setImageFile(file);
  };

  const removeFile = () => {
    setImageFile(null);
    // Remounting the input is the only reliable way to clear a file input
    setFileInputKey((k) => k + 1);
  };

  const handleSubmit = async () => {
    if (!canSubmit || isEvaluating) return;

    setIsEvaluating(true);
    setSubmitError("");

    const submittedSteps = nonBlankSteps(steps);

    try {
      const formData = new FormData();
      formData.append("problemId", problemId);
      formData.append("steps", JSON.stringify(submittedSteps));
      if (imageFile) {
        formData.append("image", imageFile);
      }

      const data = await apiFetch("/api/evaluate/", { body: formData });

      // Show the steps that were actually graded, so feedback lines up with them
      setSteps(data.extracted_steps || (submittedSteps.length ? submittedSteps : [""]));
      setFeedback(data.feedback || []);
      setStepCorrect(data.step_correct || []);
      setAllCorrect(Boolean(data.all_correct));

      try {
        setAttempts(await fetchAttempts(supabaseUser.userId, problemId));
        setHistoryError("");
      } catch (err) {
        // The grade is already on screen; a stale history list isn't worth an error
        console.error("Failed to refresh attempt history:", err);
      }
    } catch (err) {
      console.error("Evaluation error:", err);
      setSubmitError(friendlyError(err));
    } finally {
      setIsEvaluating(false);
    }
  };

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 py-6 sm:py-10 flex flex-col items-center">
      <LoadingOverlay show={loading} message="Loading problem..." />
      <LoadingOverlay show={isEvaluating} message="Evaluating your work..." />

      <div className="w-full mb-4">
        <Button variant="ghost" size="sm" onClick={() => navigate(-1)}>
          <ArrowLeft className="size-4" />
          Back
        </Button>
      </div>
      <h1 className="text-2xl font-bold mb-6">Solve the Problem</h1>

      {loadError ? (
        <ErrorMessage message={loadError} onRetry={retry} />
      ) : (
        <>
          {/* Problem Display */}
          <Card className="w-full mb-8">
            <CardContent>
              <MathText as="p" className="text-lg break-words">{problemText}</MathText>
            </CardContent>
          </Card>

          {/* Steps */}
          <div className="w-full space-y-4 mb-8">
            <h2 className="text-xl font-semibold">Steps</h2>

            {steps.map((step, index) => (
              <div key={index} className="flex flex-col md:flex-row md:items-start gap-2 md:gap-4">
                {/* Step input */}
                <div className="flex-1 min-w-0 space-y-2">
                  <div className="flex items-center justify-between">
                    <Label htmlFor={`step-${index}`}>Step {index + 1}</Label>
                    <Button
                      variant="ghost"
                      size="icon"
                      className="size-8 text-destructive hover:text-destructive/80"
                      onClick={() => deleteStep(index)}
                      aria-label={`Delete step ${index + 1}`}
                    >
                      <X className="size-4" />
                    </Button>
                  </div>
                  <Input
                    id={`step-${index}`}
                    type="text"
                    value={step}
                    onChange={(e) => updateStep(index, e.target.value)}
                    placeholder="Enter step..."
                  />
                  {step && <MathText as="div" className="text-sm text-muted-foreground px-1 overflow-x-auto">{step}</MathText>}
                </div>

                {/* Feedback */}
                {feedback[index] && (
                  <StepFeedback
                    text={feedback[index]}
                    correct={stepCorrect[index] ?? null}
                    className="w-full md:w-2/5 md:mt-10"
                  />
                )}
              </div>
            ))}

            <Button variant="outline" className="w-full sm:w-auto" onClick={addStep}>
              + Add Step
            </Button>
          </div>

          {/* Image Upload */}
          <div className="w-full mb-6">
            <Label htmlFor="image-upload" className="mb-2 block">Upload Image or PDF (optional)</Label>
            <div className="flex items-center gap-2">
              <Input
                key={fileInputKey}
                id="image-upload"
                type="file"
                accept="image/*, .pdf"
                onChange={handleImageUpload}
              />
              {imageFile && (
                <Button variant="ghost" size="sm" onClick={removeFile}>
                  Remove
                </Button>
              )}
            </div>
          </div>

          {/* Result + Submit */}
          <div className="w-full flex flex-col items-center gap-3 mb-10">
            {allCorrect !== null && <ResultBanner allCorrect={allCorrect} />}
            <ErrorMessage message={submitError} onRetry={canSubmit ? handleSubmit : undefined} />
            <Button
              size="lg"
              className="w-full sm:w-auto bg-green-600 hover:bg-green-700 text-white"
              onClick={handleSubmit}
              disabled={!canSubmit || isEvaluating}
            >
              Submit Steps
            </Button>
            {!canSubmit && (
              <p className="text-sm text-muted-foreground text-center">
                Enter at least one step or attach a file to submit.
              </p>
            )}
          </div>

          {historyError ? (
            <ErrorMessage message={historyError} />
          ) : (
            <AttemptHistory attempts={attempts} />
          )}
        </>
      )}
    </div>
  );
}
