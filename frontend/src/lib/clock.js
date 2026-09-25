// Supabase logins are short-lived tokens checked against the device clock. If the clock is
// off by more than a few minutes, a brand-new login looks expired, the client quietly drops
// it, and the student is bounced back to the home page with no explanation.
export const MAX_CLOCK_SKEW_SECONDS = 300;

function issuedAt(accessToken) {
  try {
    const payload = accessToken.split(".")[1].replace(/-/g, "+").replace(/_/g, "/");
    return JSON.parse(atob(payload)).iat ?? null;
  } catch {
    return null;
  }
}

// Seconds the device clock is ahead (positive) or behind (negative) the auth server, judged
// from a token the server just issued. Null if it can't tell.
export function clockSkewSeconds(accessToken, nowMs = Date.now()) {
  const iat = issuedAt(accessToken);
  return iat === null ? null : Math.round(nowMs / 1000 - iat);
}

export function isClockSkewed(accessToken, nowMs = Date.now()) {
  const skew = clockSkewSeconds(accessToken, nowMs);
  return skew !== null && Math.abs(skew) > MAX_CLOCK_SKEW_SECONDS;
}
