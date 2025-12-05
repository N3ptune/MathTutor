import { useContext } from "react";
import { AuthState } from "../authState";
import { Navigate } from "react-router-dom";

export default function RequireAuth({ children }) {
  const { user } = useContext(AuthState);

  if (user === undefined) {
    return <p>Loading...</p>; // waiting for Firebase
  }

  if (!user) {
    return <Navigate to="/" />;
  }

  return children;
}
