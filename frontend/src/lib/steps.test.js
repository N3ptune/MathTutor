import { describe, expect, it } from "vitest";
import { canSubmitSteps, feedbackTone, nonBlankSteps } from "./steps";

describe("canSubmitSteps", () => {
  it("blocks when every step is blank and there is no file", () => {
    expect(canSubmitSteps([""], null)).toBe(false);
    expect(canSubmitSteps(["   ", "\t"], null)).toBe(false);
    expect(canSubmitSteps([], null)).toBe(false);
  });

  it("allows a single non-blank step", () => {
    expect(canSubmitSteps(["", "x = 2"], null)).toBe(true);
  });

  it("allows an attached file with no typed steps", () => {
    expect(canSubmitSteps([""], new File(["x"], "work.png"))).toBe(true);
  });
});

describe("nonBlankSteps", () => {
  it("trims and drops blank steps", () => {
    expect(nonBlankSteps([" x + 1 = 3 ", "", "  ", "x = 2"])).toEqual(["x + 1 = 3", "x = 2"]);
  });
});

describe("feedbackTone", () => {
  it("is green for correct, red for incorrect, neutral otherwise", () => {
    expect(feedbackTone(true)).toContain("green");
    expect(feedbackTone(false)).toContain("red");
    expect(feedbackTone(null)).not.toMatch(/green|red/);
  });
});
