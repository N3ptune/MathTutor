import { describe, expect, it, vi, beforeEach } from "vitest";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { MemoryRouter } from "react-router-dom";

const insert = vi.fn();
const update = vi.fn();

vi.mock("../supabase", () => ({
  supabase: {
    from: () => ({
      insert: (rows) => insert(rows),
      update: (values) => ({
        eq: () => ({ select: () => ({ single: () => update(values) }) }),
      }),
    }),
  },
  logout: vi.fn().mockResolvedValue(),
}));

import { AuthState } from "../authState";
import ReportGradeButton from "./ReportGradeButton";
import ConsentGate from "./ConsentGate";
import { needsConsent } from "@/lib/consent";
import { TERMS_VERSION } from "@/lib/config";
import { ApiError, isQuotaError } from "@/lib/api";

function withAuth(ui, value) {
  return render(
    <MemoryRouter>
      <AuthState.Provider value={value}>{ui}</AuthState.Provider>
    </MemoryRouter>,
  );
}

beforeEach(() => {
  insert.mockReset();
  update.mockReset();
});

describe("needsConsent", () => {
  it("requires acceptance of the current terms version", () => {
    expect(needsConsent({ termsAcceptedAt: null })).toBe(true);
    expect(needsConsent({ termsAcceptedAt: "2026-01-01", termsVersion: "old" })).toBe(true);
    expect(needsConsent({ termsAcceptedAt: "2026-01-01", termsVersion: TERMS_VERSION })).toBe(false);
  });
});

describe("isQuotaError", () => {
  it("is true only for 402 API errors", () => {
    expect(isQuotaError(new ApiError("out of checks", 402))).toBe(true);
    expect(isQuotaError(new ApiError("bad", 400))).toBe(false);
    expect(isQuotaError(new Error("x"))).toBe(false);
  });
});

describe("ConsentGate", () => {
  it("can't continue until both boxes are checked, then saves the terms version", async () => {
    const setSupabaseUser = vi.fn();
    update.mockResolvedValue({ data: { userId: 1, termsVersion: TERMS_VERSION }, error: null });
    withAuth(<ConsentGate />, { supabaseUser: { userId: 1 }, setSupabaseUser });

    const continueButton = screen.getByRole("button", { name: "Continue" });
    expect(continueButton).toBeDisabled();

    await userEvent.click(screen.getByLabelText(/13 years old or older/));
    expect(continueButton).toBeDisabled();

    await userEvent.click(screen.getByLabelText(/I agree to the/));
    await userEvent.click(continueButton);

    expect(update).toHaveBeenCalledWith(expect.objectContaining({ termsVersion: TERMS_VERSION }));
    expect(setSupabaseUser).toHaveBeenCalledWith({ userId: 1, termsVersion: TERMS_VERSION });
  });
});

describe("ReportGradeButton", () => {
  const auth = { supabaseUser: { userId: 9 } };

  it("renders nothing without an attempt to report", () => {
    const { container } = withAuth(<ReportGradeButton attemptId={null} />, auth);
    expect(container).toBeEmptyDOMElement();
  });

  it("requires a reason, then files the report", async () => {
    insert.mockResolvedValue({ error: null });
    withAuth(<ReportGradeButton attemptId={42} />, auth);

    await userEvent.click(screen.getByRole("button", { name: /This grade looks wrong/ }));
    await userEvent.click(screen.getByRole("button", { name: "Send report" }));
    expect(screen.getByRole("alert")).toHaveTextContent("Tell us what looks wrong.");
    expect(insert).not.toHaveBeenCalled();

    await userEvent.type(screen.getByLabelText("What looks wrong?"), "Step 2 is right");
    await userEvent.click(screen.getByRole("button", { name: "Send report" }));

    expect(insert).toHaveBeenCalledWith([{ userId: 9, attemptId: 42, reason: "Step 2 is right" }]);
    expect(await screen.findByText(/we'll review this grade/)).toBeInTheDocument();
  });

  it("treats a duplicate report as already sent", async () => {
    insert.mockResolvedValue({ error: { code: "23505" } });
    withAuth(<ReportGradeButton attemptId={42} />, auth);

    await userEvent.click(screen.getByRole("button", { name: /This grade looks wrong/ }));
    await userEvent.type(screen.getByLabelText("What looks wrong?"), "again");
    await userEvent.click(screen.getByRole("button", { name: "Send report" }));

    expect(await screen.findByText(/we'll review this grade/)).toBeInTheDocument();
  });
});
