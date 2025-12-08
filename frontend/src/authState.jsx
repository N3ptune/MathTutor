// authState.jsx
import { createContext, useState, useEffect } from "react";
import { auth } from "./firebase";
import { onAuthStateChanged } from "firebase/auth";

export const AuthState = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(undefined);
  const [supabaseUser, setSupabaseUser] = useState(null);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (firebaseUser) => {
      setUser(firebaseUser ?? null);
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
