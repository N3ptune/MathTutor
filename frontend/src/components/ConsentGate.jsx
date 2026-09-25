import { useContext, useState } from "react";
import { Link } from "react-router-dom";
import { supabase, logout } from "../supabase";
import { AuthState } from "../authState";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import ErrorMessage from "@/components/ErrorMessage";
import LoadingOverlay from "@/components/LoadingOverlay";
import { friendlyError } from "@/lib/api";
import { MINIMUM_AGE, TERMS_VERSION } from "@/lib/config";

// Shown once after sign-in (and again whenever the Terms change) before the app is usable.
// Covers every sign-in method, including Google, which skips the registration form.
export default function ConsentGate() {
  const { supabaseUser, setSupabaseUser } = useContext(AuthState);
  const [ageConfirmed, setAgeConfirmed] = useState(false);
  const [termsAccepted, setTermsAccepted] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  const isUpdate = Boolean(supabaseUser?.termsAcceptedAt);

  async function accept() {
    setSaving(true);
    setError("");
    try {
      const { data, error: updateError } = await supabase
        .from("users")
        .update({ termsAcceptedAt: new Date().toISOString(), termsVersion: TERMS_VERSION })
        .eq("userId", supabaseUser.userId)
        .select()
        .single();

      if (updateError) throw updateError;
      setSupabaseUser(data);
    } catch (err) {
      console.error("Failed to record consent:", err);
      setError(friendlyError(err));
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="max-w-lg mx-auto px-4 py-10">
      <LoadingOverlay show={saving} message="Saving..." />
      <Card>
        <CardHeader>
          <CardTitle>{isUpdate ? "Our terms have changed" : "Before you start"}</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <p className="text-sm text-muted-foreground">
            {isUpdate
              ? "Please review and accept the updated Terms of Service and Privacy Policy to keep using MathTutor."
              : "MathTutor uses AI to check your work. Please confirm the following to continue."}
          </p>

          <label className="flex items-start gap-3 text-sm">
            <input
              type="checkbox"
              className="mt-1 size-4"
              checked={ageConfirmed}
              onChange={(e) => setAgeConfirmed(e.target.checked)}
            />
            <span>I am {MINIMUM_AGE} years old or older.</span>
          </label>

          <label className="flex items-start gap-3 text-sm">
            <input
              type="checkbox"
              className="mt-1 size-4"
              checked={termsAccepted}
              onChange={(e) => setTermsAccepted(e.target.checked)}
            />
            <span>
              I agree to the{" "}
              <Link to="/terms" target="_blank" className="underline">Terms of Service</Link> and{" "}
              <Link to="/privacy" target="_blank" className="underline">Privacy Policy</Link>, including that my
              work is sent to OpenAI to be graded.
            </span>
          </label>

          <ErrorMessage message={error} />

          <div className="flex flex-col-reverse sm:flex-row gap-2 sm:justify-end">
            <Button variant="ghost" onClick={() => logout().catch(console.error)}>
              Sign out
            </Button>
            <Button onClick={accept} disabled={!ageConfirmed || !termsAccepted || saving}>
              Continue
            </Button>
          </div>

          <p className="text-xs text-muted-foreground">
            If you are under {MINIMUM_AGE}, you can't use MathTutor.
          </p>
        </CardContent>
      </Card>
    </div>
  );
}
