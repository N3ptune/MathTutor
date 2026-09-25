import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

vi.mock("../supabase", () => ({
  supabase: {
    auth: { getSession: vi.fn().mockResolvedValue({ data: { session: { access_token: "tok" } } }) },
  },
}));

import {
  apiFetch,
  ApiError,
  friendlyError,
  GENERIC_MESSAGE,
  OFFLINE_MESSAGE,
  SESSION_EXPIRED_MESSAGE,
  TIMEOUT_MESSAGE,
  UNREACHABLE_MESSAGE,
} from "./api";

function jsonResponse(status, body) {
  return { ok: status >= 200 && status < 300, status, json: () => Promise.resolve(body) };
}

describe("friendlyError", () => {
  it.each([
    "Failed to fetch",
    "NetworkError when attempting to fetch resource.",
    "Load failed",
    "TypeError: Failed to fetch",
  ])("maps the browser network failure %j to the unreachable message", (message) => {
    expect(friendlyError(new TypeError(message))).toBe(UNREACHABLE_MESSAGE);
  });

  it("reports offline before anything else", () => {
    const onLine = vi.spyOn(navigator, "onLine", "get").mockReturnValue(false);
    expect(friendlyError(new Error("anything"))).toBe(OFFLINE_MESSAGE);
    onLine.mockRestore();
  });

  it("maps aborted requests to the timeout message", () => {
    expect(friendlyError(new DOMException("aborted", "AbortError"))).toBe(TIMEOUT_MESSAGE);
  });

  it("shows the server's message for API errors", () => {
    expect(friendlyError(new ApiError("Enter at least one step or attach a file.", 400))).toBe(
      "Enter at least one step or attach a file.",
    );
  });

  it("maps 401 to session expired", () => {
    expect(friendlyError(new ApiError("Invalid or expired access token", 401))).toBe(SESSION_EXPIRED_MESSAGE);
  });

  it("hides unexpected internal errors", () => {
    expect(friendlyError(new Error("Cannot read properties of undefined"))).toBe(GENERIC_MESSAGE);
  });
});

describe("apiFetch", () => {
  beforeEach(() => {
    globalThis.fetch = vi.fn();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("sends the access token and returns parsed JSON", async () => {
    fetch.mockResolvedValue(jsonResponse(200, { ok: 1 }));

    await expect(apiFetch("/api/x", { json: { a: 1 } })).resolves.toEqual({ ok: 1 });

    const [url, init] = fetch.mock.calls[0];
    expect(url).toMatch(/\/api\/x$/);
    expect(init.headers.Authorization).toBe("Bearer tok");
    expect(init.headers["Content-Type"]).toBe("application/json");
    expect(init.body).toBe('{"a":1}');
  });

  it("throws an ApiError with the server's detail on failure", async () => {
    fetch.mockResolvedValue(jsonResponse(429, { detail: "Too many requests, please slow down" }));

    const err = await apiFetch("/api/x").catch((e) => e);

    expect(err).toBeInstanceOf(ApiError);
    expect(err.status).toBe(429);
    expect(err.message).toBe("Too many requests, please slow down");
  });

  it("copes with a non-JSON error body", async () => {
    fetch.mockResolvedValue({ ok: false, status: 502, json: () => Promise.reject(new SyntaxError("<html>")) });

    const err = await apiFetch("/api/x").catch((e) => e);

    expect(err).toBeInstanceOf(ApiError);
    expect(err.message).toBe(GENERIC_MESSAGE);
  });

  it("lets network failures through so friendlyError can explain them", async () => {
    fetch.mockRejectedValue(new TypeError("Failed to fetch"));

    const err = await apiFetch("/api/x").catch((e) => e);

    expect(friendlyError(err)).toBe(UNREACHABLE_MESSAGE);
  });

  it("aborts requests that take too long", async () => {
    vi.useFakeTimers();
    fetch.mockImplementation((url, { signal }) =>
      new Promise((resolve, reject) => {
        signal.addEventListener("abort", () => reject(new DOMException("aborted", "AbortError")));
      }),
    );

    const pending = apiFetch("/api/x", { timeoutMs: 1000 }).catch((e) => e);
    await vi.advanceTimersByTimeAsync(1000);

    expect(friendlyError(await pending)).toBe(TIMEOUT_MESSAGE);
  });
});
