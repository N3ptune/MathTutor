import { useContext, useEffect, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { ArrowLeft, Check } from "lucide-react";
import { AuthState } from "../authState";
import { logout, supabase, updatePassword } from "../supabase";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import ErrorMessage from "@/components/ErrorMessage";
import LoadingOverlay from "@/components/LoadingOverlay";
import { apiFetch, friendlyError } from "@/lib/api";
import { usePageLoad } from "@/lib/usePageLoad";
import { PLANS, SUPPORT_EMAIL } from "@/lib/config";

const MIN_PASSWORD_LENGTH = 8;

function formatDate(iso) {
  return iso ? new Date(iso).toLocaleDateString(undefined, { month: "long", day: "numeric", year: "numeric" }) : "";
}

function UsageBar({ used, limit }) {
  const percent = Math.min(100, Math.round((used / Math.max(limit, 1)) * 100));
  const color = percent >= 100 ? "bg-red-500" : percent >= 80 ? "bg-amber-500" : "bg-primary";
  return (
    <div
      className="h-2 w-full rounded-full bg-muted overflow-hidden"
      role="progressbar"
      aria-valuenow={used}
      aria-valuemin={0}
      aria-valuemax={limit}
      aria-label="AI checks used this month"
    >
      <div className={`h-full ${color}`} style={{ width: `${percent}%` }} />
    </div>
  );
}

const PRO_FEATURES = [
  `${PLANS.pro.monthlyActions} AI checks a month`,
  "Photo and PDF grading",
  "Unlimited personal practice problems (within your checks)",
  "Proficiency exams for every section",
];

export default function Account() {
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const { user, supabaseUser, setSupabaseUser } = useContext(AuthState);
  const [firstName, setFirstName] = useState(supabaseUser?.firstName || "");
  const [lastName, setLastName] = useState(supabaseUser?.lastName || "");
  const [nameMessage, setNameMessage] = useState({ type: "", text: "" });

  const [status, setStatus] = useState(null);
  const [busyMessage, setBusyMessage] = useState("");
  const [billingError, setBillingError] = useState("");
  const [notice, setNotice] = useState("");

  const [newPassword, setNewPassword] = useState("");
  const [passwordMessage, setPasswordMessage] = useState({ type: "", text: "" });

  const [exportError, setExportError] = useState("");
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [deleteConfirm, setDeleteConfirm] = useState("");
  const [deleteError, setDeleteError] = useState("");

  const checkoutResult = searchParams.get("checkout");

  const { loading, error: loadError, retry } = usePageLoad(async () => {
    setStatus(await apiFetch("/api/billing/status", { method: "GET" }));
  }, [supabaseUser], Boolean(supabaseUser));

  // Stripe sends people back before its webhook may have landed, so poll briefly for Pro
  useEffect(() => {
    if (checkoutResult !== "success") return;
    let cancelled = false;

    (async () => {
      for (let i = 0; i < 6 && !cancelled; i++) {
        try {
          const latest = await apiFetch("/api/billing/status", { method: "GET" });
          if (cancelled) return;
          setStatus(latest);
          if (latest.plan === "pro") {
            setNotice("You're on Pro. Thanks for subscribing!");
            break;
          }
        } catch (err) {
          console.error("Failed to refresh billing status:", err);
        }
        await new Promise((resolve) => setTimeout(resolve, 2000));
      }
      if (!cancelled) setSearchParams({}, { replace: true });
    })();

    return () => {
      cancelled = true;
    };
  }, [checkoutResult, setSearchParams]);

  async function goToBilling(path, message) {
    setBillingError("");
    setBusyMessage(message);
    try {
      const { url } = await apiFetch(path);
      window.location.assign(url);
      // Leave the overlay up while the browser navigates to Stripe
    } catch (err) {
      console.error("Billing redirect failed:", err);
      setBillingError(friendlyError(err));
      setBusyMessage("");
    }
  }

  async function saveName() {
    if (!firstName.trim()) {
      setNameMessage({ type: "error", text: "Enter your first name." });
      return;
    }
    setBusyMessage("Saving...");
    try {
      const { data, error } = await supabase
        .from("users")
        .update({ firstName: firstName.trim(), lastName: lastName.trim() })
        .eq("userId", supabaseUser.userId)
        .select()
        .single();
      if (error) throw error;
      setSupabaseUser(data);
      setNameMessage({ type: "success", text: "Name updated." });
    } catch (err) {
      console.error("Name update failed:", err);
      setNameMessage({ type: "error", text: friendlyError(err) });
    } finally {
      setBusyMessage("");
    }
  }

  async function changePassword() {
    if (newPassword.length < MIN_PASSWORD_LENGTH) {
      setPasswordMessage({ type: "error", text: `Use at least ${MIN_PASSWORD_LENGTH} characters.` });
      return;
    }
    setBusyMessage("Updating password...");
    try {
      await updatePassword(newPassword);
      setNewPassword("");
      setPasswordMessage({ type: "success", text: "Password updated." });
    } catch (err) {
      console.error("Password update failed:", err);
      setPasswordMessage({ type: "error", text: err?.message || friendlyError(err) });
    } finally {
      setBusyMessage("");
    }
  }

  async function downloadData() {
    setExportError("");
    setBusyMessage("Preparing your data...");
    try {
      const data = await apiFetch("/api/account/export", { method: "GET" });
      const blob = new Blob([JSON.stringify(data, null, 2)], { type: "application/json" });
      const link = document.createElement("a");
      link.href = URL.createObjectURL(blob);
      link.download = "mathtutor-data.json";
      link.click();
      URL.revokeObjectURL(link.href);
    } catch (err) {
      console.error("Export failed:", err);
      setExportError(friendlyError(err));
    } finally {
      setBusyMessage("");
    }
  }

  async function deleteAccount() {
    setDeleteError("");
    setBusyMessage("Deleting your account...");
    try {
      await apiFetch("/api/account", { method: "DELETE" });
      await logout().catch(() => {});
      navigate("/", { replace: true });
    } catch (err) {
      console.error("Account deletion failed:", err);
      setDeleteError(friendlyError(err));
      setBusyMessage("");
    }
  }

  const isPro = status?.plan === "pro";

  return (
    <div className="max-w-3xl mx-auto px-4 sm:px-6 py-6 sm:py-10 space-y-6">
      <LoadingOverlay show={loading} message="Loading your account..." />
      <LoadingOverlay show={Boolean(busyMessage)} message={busyMessage} />
      <LoadingOverlay
        show={checkoutResult === "success" && !notice && !loading}
        message="Confirming your subscription..."
      />

      <Button variant="ghost" size="sm" onClick={() => navigate("/dashboard")}>
        <ArrowLeft className="size-4" />
        Back to Dashboard
      </Button>
      <h1 className="text-2xl sm:text-3xl font-bold">Account</h1>

      {notice && (
        <div role="status" className="rounded-lg border border-green-300 bg-green-50 p-3 text-sm text-green-900 dark:border-green-800 dark:bg-green-950/30 dark:text-green-100">
          {notice}
        </div>
      )}
      {checkoutResult === "cancelled" && (
        <p className="text-sm text-muted-foreground">Checkout was cancelled. You haven't been charged.</p>
      )}
      <ErrorMessage message={loadError} onRetry={retry} />

      {status && (
        <Card>
          <CardHeader className="flex flex-row items-center justify-between gap-4">
            <CardTitle>Your plan: {status.planLabel}</CardTitle>
            {isPro && (
              <Button variant="outline" size="sm" onClick={() => goToBilling("/api/billing/portal", "Opening billing...")}>
                Manage billing
              </Button>
            )}
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <div className="flex justify-between text-sm">
                <span>AI checks this month</span>
                <span className="font-medium">
                  {status.actionsUsed} of {status.actionsLimit}
                </span>
              </div>
              <UsageBar used={status.actionsUsed} limit={status.actionsLimit} />
              <p className="text-xs text-muted-foreground">Resets {formatDate(status.resetsAt)}.</p>
            </div>

            {isPro && status.subscriptionStatus === "past_due" && (
              <ErrorMessage
                message="Your last payment didn't go through. Update your card to keep Pro."
                action={{ label: "Update card", onClick: () => goToBilling("/api/billing/portal", "Opening billing...") }}
              />
            )}
            {isPro && status.currentPeriodEnd && (
              <p className="text-sm text-muted-foreground">
                {status.cancelAtPeriodEnd
                  ? `Pro ends on ${formatDate(status.currentPeriodEnd)}. You won't be charged again.`
                  : `Renews on ${formatDate(status.currentPeriodEnd)} for $${PLANS.pro.price.toFixed(2)}.`}
              </p>
            )}

            {!isPro && (
              <div className="rounded-lg border p-4 space-y-3">
                <p className="font-semibold">
                  Pro: ${PLANS.pro.price.toFixed(2)}/month
                </p>
                <ul className="space-y-1 text-sm">
                  {PRO_FEATURES.map((feature) => (
                    <li key={feature} className="flex gap-2">
                      <Check className="size-4 shrink-0 text-primary mt-0.5" />
                      {feature}
                    </li>
                  ))}
                </ul>
                <Button
                  className="w-full sm:w-auto"
                  disabled={!status.billingEnabled}
                  onClick={() => goToBilling("/api/billing/checkout", "Opening checkout...")}
                >
                  Upgrade to Pro
                </Button>
                {!status.billingEnabled && (
                  <p className="text-xs text-muted-foreground">Upgrades aren't open yet. Check back soon.</p>
                )}
                {status.hasBillingAccount && (
                  <Button variant="link" className="px-0" onClick={() => goToBilling("/api/billing/portal", "Opening billing...")}>
                    View past invoices
                  </Button>
                )}
              </div>
            )}
            <ErrorMessage message={billingError} />
          </CardContent>
        </Card>
      )}

      <Card>
        <CardHeader>
          <CardTitle>Profile</CardTitle>
        </CardHeader>
        <CardContent className="space-y-6">
          <p className="text-sm break-all">
            <span className="text-muted-foreground">Email: </span>
            {user?.email}
          </p>

          <div className="space-y-2">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              <div className="space-y-2">
                <Label htmlFor="first-name">First name</Label>
                <Input
                  id="first-name"
                  autoComplete="given-name"
                  value={firstName}
                  onChange={(e) => {
                    setFirstName(e.target.value);
                    setNameMessage({ type: "", text: "" });
                  }}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="last-name">Last name</Label>
                <Input
                  id="last-name"
                  autoComplete="family-name"
                  value={lastName}
                  onChange={(e) => {
                    setLastName(e.target.value);
                    setNameMessage({ type: "", text: "" });
                  }}
                />
              </div>
            </div>
            <Button
              variant="outline"
              onClick={saveName}
              disabled={firstName === (supabaseUser?.firstName || "") && lastName === (supabaseUser?.lastName || "")}
            >
              Save name
            </Button>
            {nameMessage.type === "error" && <ErrorMessage message={nameMessage.text} />}
            {nameMessage.type === "success" && (
              <p className="text-sm text-green-700 dark:text-green-400">{nameMessage.text}</p>
            )}
          </div>

          <div className="space-y-2">
            <Label htmlFor="new-password">Change password</Label>
            <div className="flex flex-col sm:flex-row gap-2">
              <Input
                id="new-password"
                type="password"
                autoComplete="new-password"
                placeholder="New password"
                value={newPassword}
                onChange={(e) => {
                  setNewPassword(e.target.value);
                  setPasswordMessage({ type: "", text: "" });
                }}
              />
              <Button variant="outline" onClick={changePassword} disabled={!newPassword}>
                Update
              </Button>
            </div>
            {passwordMessage.type === "error" && <ErrorMessage message={passwordMessage.text} />}
            {passwordMessage.type === "success" && (
              <p className="text-sm text-green-700 dark:text-green-400">{passwordMessage.text}</p>
            )}
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Your data</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
            <p className="text-sm text-muted-foreground">
              Download everything we store about you: your work, feedback, progress, and usage.
            </p>
            <Button variant="outline" onClick={downloadData}>
              Download my data
            </Button>
          </div>
          <ErrorMessage message={exportError} />

          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-t pt-4">
            <p className="text-sm text-muted-foreground">
              Permanently delete your account and all your data. Any Pro subscription is cancelled immediately.
            </p>
            <Button variant="destructive" onClick={() => setDeleteOpen(true)}>
              Delete account
            </Button>
          </div>
        </CardContent>
      </Card>

      {SUPPORT_EMAIL && (
        <p className="text-sm text-muted-foreground">
          Need help? Email <a className="underline" href={`mailto:${SUPPORT_EMAIL}`}>{SUPPORT_EMAIL}</a>.
        </p>
      )}

      <Dialog open={deleteOpen} onOpenChange={setDeleteOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Delete your account?</DialogTitle>
            <DialogDescription>
              This permanently deletes your work, history, and progress, and cancels Pro right away without a refund
              for the current month. This can't be undone.
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-2">
            <Label htmlFor="delete-confirm">Type DELETE to confirm</Label>
            <Input id="delete-confirm" value={deleteConfirm} onChange={(e) => setDeleteConfirm(e.target.value)} />
          </div>
          <ErrorMessage message={deleteError} />
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeleteOpen(false)}>
              Cancel
            </Button>
            <Button variant="destructive" disabled={deleteConfirm !== "DELETE"} onClick={deleteAccount}>
              Delete account
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
