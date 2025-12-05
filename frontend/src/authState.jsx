// authState.jsx
import { createContext, useState, useEffect } from "react";
import { auth } from "./firebase";
import { onAuthStateChanged } from "firebase/auth";

export const AuthState = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(undefined);       // Firebase auth user
  const [supabaseUser, setSupabaseUser] = useState(null); // Optional: Supabase data

  useEffect(() => {
    // Listen for Firebase auth changes
    const unsubscribe = onAuthStateChanged(auth, (firebaseUser) => {
      setUser(firebaseUser ?? null);

      // Do NOT fetch from Supabase here! That will be done after login/registration
      // This prevents 400/404/406 errors from automatic Supabase calls
      setSupabaseUser(null);
    });

    return () => unsubscribe();
  }, []);

  return (
    <AuthState.Provider value={{ user, supabaseUser, setSupabaseUser }}>
      {children}
    </AuthState.Provider>
  );
}
