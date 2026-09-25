import { useContext, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { AuthState } from "../authState";
import { requestPasswordReset, updatePassword } from "../supabase";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import ErrorMessage from "@/components/ErrorMessage";
import LoadingOverlay from "@/components/LoadingOverlay";
import { friendlyError } from "@/lib/api";

const MIN_PASSWORD_LENGTH = 8;

// Two steps on one page: ask for a reset email, then (arriving from the emailed link,
// which signs the user in) choose a new password.
export default function ResetPassword() {
  const navigate = useNavigate();
  const { user } = useContext(AuthState);

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");
  const [busy, setBusy] = useState("");
  const [error, setError] = useState("");
  const [sent, setSent] = useState(false);

  async function sendLink() {
    if (!email.trim()) {
      setError("Enter the email you signed up with.");
      return;
    }
    setError("");
    setBusy("Sending reset link...");
    try {
      await requestPasswordReset(email.trim());
      setSent(true);
    } catch (err) {
      console.error(err);
      setError(err?.name === "AuthApiError" ? err.message : friendlyError(err));
    } finally {
      setBusy("");
    }
  }

  async function savePassword() {
    if (password.length < MIN_PASSWORD_LENGTH) {
      setError(`Use at least ${MIN_PASSWORD_LENGTH} characters.`);
      return;
    }
    if (password !== confirm) {
      setError("Passwords do not match.");
      return;
    }
    setError("");
    setBusy("Saving new password...");
    try {
      await updatePassword(password);
      navigate("/dashboard", { replace: true });
    } catch (err) {
      console.error(err);
      setError(err?.name === "AuthApiError" ? err.message : friendlyError(err));
      setBusy("");
    }
  }

  return (
    <div className="max-w-md mx-auto px-4 py-10 w-full">
      <LoadingOverlay show={user === undefined} message="Loading..." />
      <LoadingOverlay show={Boolean(busy)} message={busy} />

      <Card>
        <CardHeader>
          <CardTitle>{user ? "Choose a new password" : "Reset your password"}</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          {user ? (
            <>
              <div className="space-y-2">
                <Label htmlFor="new-password">New password</Label>
                <Input
                  id="new-password"
                  type="password"
                  autoComplete="new-password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="confirm-password">Confirm new password</Label>
                <Input
                  id="confirm-password"
                  type="password"
                  autoComplete="new-password"
                  value={confirm}
                  onChange={(e) => setConfirm(e.target.value)}
                />
              </div>
              <ErrorMessage message={error} />
              <Button className="w-full" onClick={savePassword}>
                Save password
              </Button>
            </>
          ) : sent ? (
            <p className="text-sm">
              If an account exists for <strong className="break-all">{email}</strong>, we've emailed a link to reset
              your password. It may take a minute to arrive; check your spam folder too.
            </p>
          ) : (
            <>
              <p className="text-sm text-muted-foreground">
                Enter your email and we'll send you a link to choose a new password.
              </p>
              <div className="space-y-2">
                <Label htmlFor="reset-email">Email</Label>
                <Input
                  id="reset-email"
                  type="email"
                  autoComplete="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                />
              </div>
              <ErrorMessage message={error} />
              <Button className="w-full" onClick={sendLink}>
                Send reset link
              </Button>
            </>
          )}

          <p className="text-sm text-center">
            <Link to="/" className="underline text-muted-foreground">Back to sign in</Link>
          </p>
        </CardContent>
      </Card>
    </div>
  );
}
