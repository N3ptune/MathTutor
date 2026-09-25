import { describe, expect, it } from "vitest";
import { clockSkewSeconds, isClockSkewed } from "./clock";

function tokenIssuedAt(iat) {
  const payload = btoa(JSON.stringify({ iat, exp: iat + 3600 })).replace(/=+$/, "");
  return `header.${payload}.signature`;
}

describe("clock skew", () => {
  const iat = 1790368044;

  it("is fine when the device agrees with the server", () => {
    expect(isClockSkewed(tokenIssuedAt(iat), (iat + 2) * 1000)).toBe(false);
  });

  it("catches a clock an hour ahead (the real bug report)", () => {
    // Values from the console: issued 1790368044, device time 1790371661
    expect(clockSkewSeconds(tokenIssuedAt(iat), 1790371661 * 1000)).toBe(3617);
    expect(isClockSkewed(tokenIssuedAt(iat), 1790371661 * 1000)).toBe(true);
  });

  it("catches a clock that is behind", () => {
    expect(isClockSkewed(tokenIssuedAt(iat), (iat - 900) * 1000)).toBe(true);
  });

  it("ignores tokens it can't read", () => {
    expect(clockSkewSeconds("not-a-jwt")).toBeNull();
    expect(isClockSkewed("not-a-jwt")).toBe(false);
  });
});
