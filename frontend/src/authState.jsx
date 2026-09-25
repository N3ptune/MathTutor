// authState.jsx
import { createContext, useState, useEffect } from "react";
import { supabase } from "./supabase";
import { isClockSkewed } from "./lib/clock";

export const AuthState = createContext(null);

// Pulls first/last name out of whatever the auth provider gave us. Email/password
// signups store first_name/last_name directly (see registerEmailPassword); Google
// gives given_name/family_name; anything else falls back to splitting full_name/name.
function namesFromMetadata(authUser) {
  const meta = authUser.user_metadata || {};
  const fullName = meta.full_name || meta.name || "";
  const [fallbackFirst, ...fallbackRest] = fullName.split(" ");

  return {
    firstName: meta.first_name || meta.given_name || fallbackFirst || "",
    lastName: meta.last_name || meta.family_name || fallbackRest.join(" ") || "",
  };
}

// Looks up this person's row in our "users" table, creating one if this is
// their first sign-in (e.g. via Google, where there's no separate register step).
async function syncAppUser(authUser) {
  if (!authUser) return null;

  const { data: existing } = await supabase
    .from("users")
    .select("*")
    .eq("auth_uid", authUser.id)
    .single();

  const { firstName, lastName } = namesFromMetadata(authUser);

  if (existing) {
    // Backfill legacy rows that never got a name (pre-Firebase rows, or an
    // early email/password signup from before registration collected one).
    if (!existing.firstName && !existing.lastName && (firstName || lastName)) {
      const { data: updated, error } = await supabase
        .from("users")
        .update({ firstName, lastName })
        .eq("userId", existing.userId)
        .select()
        .single();
      if (!error) return updated;
    }
    return existing;
  }

  // Match existing rows by email, not auth_uid: pre-Supabase-Auth rows (from
  // the earlier Firebase setup) already have this person's email but a stale
  // auth_uid, so this links the row forward instead of creating a duplicate.
  const { data: created, error } = await supabase
    .from("users")
    .upsert(
      [{
        email: authUser.email,
        auth_uid: authUser.id,
        firstName,
        lastName,
      }],
      { onConflict: "email" }
    )
    .select()
    .single();

  if (error) {
    console.error("Failed to sync app user:", error);
    return null;
  }

  return created;
}

export function AuthProvider({ children }) {
  const [user, setUser] = useState(undefined); // Supabase auth user
  const [supabaseUser, setSupabaseUser] = useState(null); // App user from your users table
  // True when signed in but the app user row couldn't be loaded (e.g. offline)
  const [appUserFailed, setAppUserFailed] = useState(false);
  const [syncAttempt, setSyncAttempt] = useState(0);
  // Sticky for the page's lifetime: once detected, the resulting sign-out shouldn't hide it
  const [clockSkewed, setClockSkewed] = useState(false);

  useEffect(() => {
    async function handleSession(session) {
      const authUser = session?.user ?? null;
      setUser(authUser);
      setAppUserFailed(false);
      if (!authUser) {
        setSupabaseUser(null);
        return;
      }
      let appUser = null;
      try {
        appUser = await syncAppUser(authUser);
      } catch (err) {
        console.error("Failed to sync app user:", err);
      }
      setSupabaseUser(appUser);
      setAppUserFailed(!appUser);
    }

    // Get initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      handleSession(session);
    });

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange((event, session) => {
      // Only freshly issued tokens say anything about the clock; restored ones can be old
      if ((event === "SIGNED_IN" || event === "TOKEN_REFRESHED") && session?.access_token) {
        if (isClockSkewed(session.access_token)) setClockSkewed(true);
      }
      handleSession(session);
    });

    return () => subscription.unsubscribe();
  }, [syncAttempt]);

  const retryAppUser = () => setSyncAttempt((n) => n + 1);

  return (
    <AuthState.Provider value={{ user, supabaseUser, setSupabaseUser, appUserFailed, retryAppUser, clockSkewed }}>
      {children}
    </AuthState.Provider>
  );
}
