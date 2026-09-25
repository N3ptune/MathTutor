import { useContext, useState } from "react";
import { Flag } from "lucide-react";
import { supabase } from "../supabase";
import { AuthState } from "../authState";
import { Button } from "@/components/ui/button";
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
import { friendlyError } from "@/lib/api";

const MAX_REASON_LENGTH = 2000;

// Lets a student flag an AI grade as wrong. Reports are reviewed by hand and feed the
// grading-accuracy test set (backend/evals).
export default function ReportGradeButton({ attemptId, size = "sm" }) {
  const supabaseUser = useContext(AuthState)?.supabaseUser;
  const [open, setOpen] = useState(false);
  const [reason, setReason] = useState("");
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const [sent, setSent] = useState(false);

  if (!attemptId || !supabaseUser) return null;

  if (sent) {
    return <p className="text-sm text-muted-foreground">Thanks, we'll review this grade.</p>;
  }

  async function submit() {
    if (!reason.trim()) {
      setError("Tell us what looks wrong.");
      return;
    }

    setSaving(true);
    setError("");
    try {
      const { error: insertError } = await supabase
        .from("grade_report")
        .insert([{ userId: supabaseUser.userId, attemptId, reason: reason.trim() }]);

      // Reporting the same attempt twice is fine: it's already in the queue
      if (insertError && insertError.code !== "23505") throw insertError;

      setSent(true);
      setOpen(false);
    } catch (err) {
      console.error("Failed to report grade:", err);
      setError(friendlyError(err));
    } finally {
      setSaving(false);
    }
  }

  return (
    <>
      <Button variant="ghost" size={size} className="text-muted-foreground" onClick={() => setOpen(true)}>
        <Flag className="size-4" />
        This grade looks wrong
      </Button>

      <Dialog open={open} onOpenChange={setOpen}>
        <DialogContent className="sm:max-w-md">
          <LoadingOverlay show={saving} message="Sending report..." />
          <DialogHeader>
            <DialogTitle>Report a wrong grade</DialogTitle>
            <DialogDescription>
              AI grading can make mistakes. Tell us which step was graded wrong and why, and we'll review it.
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-2">
            <Label htmlFor="report-reason">What looks wrong?</Label>
            <textarea
              id="report-reason"
              rows={4}
              maxLength={MAX_REASON_LENGTH}
              value={reason}
              onChange={(e) => setReason(e.target.value)}
              placeholder="e.g. Step 2 is correct: 3x = 6 does give x = 2."
              className="w-full rounded-md border bg-transparent px-3 py-2 text-base md:text-sm shadow-xs outline-none focus-visible:ring-[3px] focus-visible:ring-ring/50 focus-visible:border-ring"
            />
          </div>

          <ErrorMessage message={error} />

          <DialogFooter>
            <Button variant="outline" onClick={() => setOpen(false)}>
              Cancel
            </Button>
            <Button onClick={submit} disabled={saving}>
              Send report
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
