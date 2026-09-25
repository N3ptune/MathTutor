import { useContext } from "react";
import { AuthState } from "../authState";
import { Navigate } from "react-router-dom";
import LoadingOverlay from "./LoadingOverlay";
import ErrorMessage from "./ErrorMessage";

// Just a check to hide things unless user is logged in and authorized.
// Waits for both the auth session and the app's user row before showing the page.
export default function RequireAuth({ children }) {
  const { user, supabaseUser, appUserFailed, retryAppUser } = useContext(AuthState);

  if (user === undefined) {
    return <LoadingOverlay show message="Signing you in..." />;
  }

  if (!user) {
    return <Navigate to="/" />;
  }

  if (appUserFailed) {
    return (
      <div className="max-w-xl mx-auto px-4 py-10">
        <ErrorMessage message="Couldn't load your account. Check your internet connection and try again." onRetry={retryAppUser} />
      </div>
    );
  }

  if (!supabaseUser) {
    return <LoadingOverlay show message="Loading your account..." />;
  }

  return children;
}
