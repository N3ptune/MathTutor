import { CheckCircle2, XCircle } from "lucide-react";
import MathText from "@/components/MathText";
import { feedbackTone } from "@/lib/steps";

// One step's AI feedback, colored by whether that step was correct.
export default function StepFeedback({ text, correct, className = "" }) {
  if (!text) return null;

  const label = correct === true ? "Correct step" : correct === false ? "Incorrect step" : null;

  return (
    <div className={`flex gap-2 border-l-4 p-3 rounded-lg text-sm ${feedbackTone(correct)} ${className}`}>
      {correct === true && <CheckCircle2 className="size-4 shrink-0 mt-0.5" aria-label={label} />}
      {correct === false && <XCircle className="size-4 shrink-0 mt-0.5" aria-label={label} />}
      <MathText>{text}</MathText>
    </div>
  );
}

// The overall verdict for a whole submission.
export function ResultBanner({ allCorrect }) {
  return (
    <div
      role="status"
      className={`w-full flex items-center gap-2 border-l-4 p-3 rounded-lg font-medium ${feedbackTone(allCorrect)}`}
    >
      {allCorrect ? <CheckCircle2 className="size-5 shrink-0" /> : <XCircle className="size-5 shrink-0" />}
      {allCorrect ? "Correct! Nice work." : "Not quite. Check the steps marked in red and try again."}
    </div>
  );
}
