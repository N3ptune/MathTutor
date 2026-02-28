import React, { useState, useEffect, useContext } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { supabase } from "../supabase";
import { AuthState } from "../authState.jsx";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent } from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from "@/components/ui/dialog";
import { ArrowLeft } from "lucide-react";

export default function ProblemInput() {
  const { problemId } = useParams();
  const navigate = useNavigate();
  const { supabaseUser } = useContext(AuthState);

  const [problemText, setProblemText] = useState("");
  const [steps, setSteps] = useState([""]);
  const [feedback, setFeedback] = useState([]);
  const [isEvaluating, setIsEvaluating] = useState(false);
  const [imageFile, setImageFile] = useState(null);

  useEffect(() => {
    if (!supabaseUser) return;

    async function fetchProblem() {
      try {
        const { data, error } = await supabase
          .from("problem")
          .select("*")
          .eq("problemId", problemId)
          .single();

        if (error) throw error;

        setProblemText(data.problem);
      } catch (err) {
        console.error("Failed to fetch problem:", err);
      }
    }

    fetchProblem();
  }, [problemId, supabaseUser]);

  const convertInput = (text) => {
    return text.replace(/sqrt\(/gi, "\u221A(");
  };

  const updateStep = (index, value) => {
    const newSteps = [...steps];
    newSteps[index] = convertInput(value);
    setSteps(newSteps);
  };

  const addStep = () => setSteps([...steps, ""]);

  const deleteStep = (index) => {
    const updatedSteps = steps.filter((_, i) => i !== index);
    const updatedFeedback = feedback.filter((_, i) => i !== index);
    setSteps(updatedSteps);
    setFeedback(updatedFeedback);
  };

  const handleImageUpload = (event) => {
    const file = event.target.files[0];
    if (!file) return;

    setSteps([""]);
    setFeedback([]);
    setImageFile(file);
  };

  const handleSubmit = async () => {
    setIsEvaluating(true);

    try {
      console.log("Submitting steps:", steps);
      console.log("Submitting problemId:", problemId);
      console.log("Submitting imageFile:", imageFile);

      const formData = new FormData();
      formData.append("problemId", problemId);
      formData.append("steps", JSON.stringify(steps));

      if (imageFile) {
        formData.append("image", imageFile);
      }

      const apiUrl = import.meta.env.VITE_API_URL || "http://localhost:8000";
      const response = await fetch(`${apiUrl}/api/evaluate/`, {
        method: "POST",
        body: formData,
      });

      console.log("Response status:", response.status);

      let data;
      try {
        data = await response.json();
        console.log("Response JSON:", data);
      } catch (jsonErr) {
        console.error("Failed to parse JSON:", jsonErr);
        data = {};
      }

      if (data.extracted_steps) {
        setSteps(data.extracted_steps);
      }

      setFeedback(data.feedback || []);
    } catch (err) {
      console.error("Evaluation error:", err);
    }

    setIsEvaluating(false);
  };

  return (
    <div className="max-w-4xl mx-auto px-6 py-10 flex flex-col items-center">
      <div className="w-full mb-4">
        <Button variant="ghost" size="sm" onClick={() => navigate(-1)}>
          <ArrowLeft className="size-4" />
          Back
        </Button>
      </div>
      <h1 className="text-2xl font-bold mb-6">Solve the Problem</h1>

      {/* Problem Display */}
      <Card className="w-full mb-8">
        <CardContent>
          <p className="text-lg">{problemText || "Loading problem..."}</p>
        </CardContent>
      </Card>

      {/* Steps */}
      <div className="w-full space-y-4 mb-8">
        <h2 className="text-xl font-semibold">Steps</h2>

        {steps.map((step, index) => (
          <div key={index} className="flex items-start gap-4">
            {/* Step input */}
            <div className="flex-1 space-y-2">
              <div className="flex items-center justify-between">
                <Label>Step {index + 1}</Label>
                <button
                  onClick={() => deleteStep(index)}
                  className="text-destructive hover:text-destructive/80 text-lg font-bold leading-none cursor-pointer"
                >
                  &times;
                </button>
              </div>
              <Input
                type="text"
                value={step}
                onChange={(e) => updateStep(index, e.target.value)}
                placeholder="Enter step..."
              />
            </div>

            {/* Feedback */}
            {feedback[index] && (
              <div className="w-2/5 bg-green-50 border-l-4 border-green-500 p-3 rounded-lg text-sm dark:bg-green-950/30 dark:border-green-600">
                {feedback[index]}
              </div>
            )}
          </div>
        ))}

        <Button variant="outline" onClick={addStep}>
          + Add Step
        </Button>
      </div>

      {/* Image Upload */}
      <div className="w-full mb-6">
        <Label htmlFor="image-upload" className="mb-2 block">Upload Image (optional)</Label>
        <Input
          id="image-upload"
          type="file"
          accept="image/*, .pdf"
          onChange={handleImageUpload}
        />
      </div>

      {/* Submit */}
      <Button size="lg" className="bg-green-600 hover:bg-green-700 text-white" onClick={handleSubmit}>
        Submit Steps
      </Button>

      {/* Evaluation Dialog */}
      <Dialog open={isEvaluating} onOpenChange={() => {}}>
        <DialogContent showCloseButton={false} className="sm:max-w-xs">
          <DialogHeader>
            <DialogTitle className="sr-only">Evaluating</DialogTitle>
            <DialogDescription className="sr-only">Your steps are being evaluated</DialogDescription>
          </DialogHeader>
          <div className="flex flex-col items-center gap-4 py-4">
            <div className="h-10 w-10 animate-spin rounded-full border-4 border-muted border-t-primary" />
            <p className="text-muted-foreground">Evaluating...</p>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
