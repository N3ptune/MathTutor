import { useEffect, useState } from "react";
import { friendlyError } from "./api";

// Runs a page's initial data load and tracks it, so pages can show the loading overlay
// until it finishes and a retryable error if it fails. `load` does its own setState calls.
// Nothing runs until `ready` is true (e.g. until the signed-in app user is known).
export function usePageLoad(load, deps, ready = true) {
  const [state, setState] = useState({ loading: true, error: "", cause: null });
  const [attempt, setAttempt] = useState(0);

  useEffect(() => {
    if (!ready) return;
    let cancelled = false;

    Promise.resolve()
      .then(() => {
        if (!cancelled) setState({ loading: true, error: "", cause: null });
        return load();
      })
      .then(
        () => !cancelled && setState({ loading: false, error: "", cause: null }),
        (err) => {
          console.error("Page load failed:", err);
          if (!cancelled) setState({ loading: false, error: friendlyError(err), cause: err });
        },
      );

    return () => {
      cancelled = true;
    };
    // `load` is recreated every render; the caller's deps say when it actually changes
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [...deps, ready, attempt]);

  return { ...state, retry: () => setAttempt((n) => n + 1) };
}
