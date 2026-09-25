import { useState } from "react";
import { ChevronDown } from "lucide-react";
import MathText from "@/components/MathText";
import StepFeedback from "@/components/StepFeedback";
import ReportGradeButton from "@/components/ReportGradeButton";

function formatDate(iso) {
  return new Date(iso).toLocaleString(undefined, { dateStyle: "medium", timeStyle: "short" });
}

function AttemptRow({ attempt, number }) {
  const [open, setOpen] = useState(false);
  const steps = attempt.steps || [];
  const feedback = attempt.stepFeedback || [];
  const correctness = attempt.stepCorrect || [];

  return (
    <li className="rounded-lg border">
      <button
        type="button"
        onClick={() => setOpen((o) => !o)}
        aria-expanded={open}
        className="w-full flex items-center gap-3 p-3 text-left cursor-pointer hover:bg-accent rounded-lg"
      >
        <span
          className={`shrink-0 rounded-full px-2 py-0.5 text-xs font-semibold ${
            attempt.isCorrect
              ? "bg-green-100 text-green-800 dark:bg-green-950 dark:text-green-200"
              : "bg-red-100 text-red-800 dark:bg-red-950 dark:text-red-200"
          }`}
        >
          {attempt.isCorrect ? "Correct" : "Incorrect"}
        </span>
        <span className="flex-1 min-w-0 text-sm">
          Attempt {number}
          <span className="block text-xs text-muted-foreground">{formatDate(attempt.createdAt)}</span>
        </span>
        <ChevronDown className={`size-4 shrink-0 transition-transform ${open ? "rotate-180" : ""}`} />
      </button>

      {open && (
        <div className="space-y-3 px-3 pb-3">
          {steps.length > 0 ? (
            steps.map((step, i) => (
              <div key={i} className="space-y-1">
                <p className="text-xs font-medium text-muted-foreground">Step {i + 1}</p>
                <MathText as="div" className="text-sm">{step}</MathText>
                <StepFeedback text={feedback[i]} correct={correctness[i] ?? null} />
              </div>
            ))
          ) : (
            // Attempts from before step history was saved only have the combined feedback
            <StepFeedback text={attempt.aiFeedback || "No feedback was saved for this attempt."} correct={null} />
          )}
          <ReportGradeButton attemptId={attempt.attemptId} />
        </div>
      )}
    </li>
  );
}

// A student's past attempts on one problem, newest first, each expandable to its steps.
export default function AttemptHistory({ attempts }) {
  return (
    <section className="w-full">
      <h2 className="text-xl font-semibold mb-4">Your Previous Attempts</h2>
      {attempts.length === 0 ? (
        <p className="text-muted-foreground text-sm">No attempts yet. Your graded submissions will show up here.</p>
      ) : (
        <ol className="space-y-2">
          {attempts.map((attempt, i) => (
            <AttemptRow key={attempt.attemptId} attempt={attempt} number={attempts.length - i} />
          ))}
        </ol>
      )}
    </section>
  );
}
