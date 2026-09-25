// Full-screen throbber shown while something is loading or saving. It sits above the page
// and swallows clicks, so the student can see work is happening and can't act mid-request.
export default function LoadingOverlay({ show, message = "Loading..." }) {
  if (!show) return null;

  return (
    <div
      role="status"
      aria-live="polite"
      aria-busy="true"
      className="fixed inset-0 z-[100] flex items-center justify-center bg-background/70 backdrop-blur-sm px-4"
    >
      <div className="flex flex-col items-center gap-4 rounded-xl border bg-card px-8 py-6 shadow-lg">
        <div className="h-10 w-10 animate-spin rounded-full border-4 border-muted border-t-primary" />
        <p className="text-muted-foreground text-center">{message}</p>
      </div>
    </div>
  );
}
