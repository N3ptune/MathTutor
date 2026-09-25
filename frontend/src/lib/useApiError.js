import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { friendlyError, isQuotaError } from "./api";

// Error state for an AI action. Running out of monthly AI checks gets an "See plans"
// button instead of "Try again", since retrying can't succeed.
export function useApiError() {
  const navigate = useNavigate();
  const [error, setError] = useState(null);

  return {
    message: error ? friendlyError(error) : "",
    action: error && isQuotaError(error) ? { label: "See plans", onClick: () => navigate("/account") } : undefined,
    isQuota: Boolean(error && isQuotaError(error)),
    setError,
    clear: () => setError(null),
  };
}
