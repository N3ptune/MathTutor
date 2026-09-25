import { Button } from "@/components/ui/button";

// Inline error box with an optional retry (or another action), used in place of alert() popups.
export default function ErrorMessage({ message, onRetry, action, className = "" }) {
  if (!message) return null;

  return (
    <div
      role="alert"
      className={`w-full flex flex-col sm:flex-row sm:items-center gap-3 rounded-lg border border-red-300 bg-red-50 p-3 text-sm text-red-800 dark:border-red-800 dark:bg-red-950/30 dark:text-red-200 ${className}`}
    >
      <p className="flex-1">{message}</p>
      {action && (
        <Button size="sm" onClick={action.onClick}>
          {action.label}
        </Button>
      )}
      {onRetry && !action && (
        <Button variant="outline" size="sm" onClick={onRetry}>
          Try again
        </Button>
      )}
    </div>
  );
}
