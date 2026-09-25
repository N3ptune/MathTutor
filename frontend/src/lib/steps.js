// A submission needs at least one non-blank step, or an uploaded file to grade instead.
export function canSubmitSteps(steps, file) {
  return Boolean(file) || steps.some((step) => step.trim() !== "");
}

// Blank steps are dropped before sending so they don't get their own (empty) feedback.
export function nonBlankSteps(steps) {
  return steps.map((step) => step.trim()).filter((step) => step !== "");
}

// Tailwind classes for a feedback box: green when the step was right, red when wrong,
// neutral when the grader didn't say.
export function feedbackTone(correct) {
  if (correct === true) {
    return "bg-green-50 border-green-500 text-green-900 dark:bg-green-950/30 dark:border-green-600 dark:text-green-100";
  }
  if (correct === false) {
    return "bg-red-50 border-red-500 text-red-900 dark:bg-red-950/30 dark:border-red-600 dark:text-red-100";
  }
  return "bg-muted border-muted-foreground/40";
}
