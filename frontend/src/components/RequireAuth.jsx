import { useContext } from "react";
import { AuthState } from "../authState";
import { Navigate } from "react-router-dom";

// Just a check to hide things unless user is logged in and authorized.
export default function RequireAuth({ children }) {
  const { user } = useContext(AuthState);

  if (user === undefined) {
    return <p>Loading...</p>;
  }

  if (!user) {
    return <Navigate to="/" />;
  }

  return children;
}
