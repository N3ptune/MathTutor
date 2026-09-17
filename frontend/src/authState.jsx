// authState.jsx
import { createContext, useState, useEffect } from "react";
import { supabase } from "./supabase";

export const AuthState = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(undefined); // Supabase auth user
  const [supabaseUser, setSupabaseUser] = useState(null); // App user from your users table

  useEffect(() => {
    // Get initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null);
    });

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null);
      setSupabaseUser(null);
    });

    return () => subscription.unsubscribe();
  }, []);

  return (
    <AuthState.Provider value={{ user, supabaseUser, setSupabaseUser }}>
      {children}
    </AuthState.Provider>
  );
}
