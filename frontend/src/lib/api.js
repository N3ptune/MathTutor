import { supabase } from "../supabase";

const API_URL = import.meta.env.VITE_API_URL || "http://localhost:8000";

// AI grading can take a while, but a request that hangs forever looks like a frozen page
const DEFAULT_TIMEOUT_MS = 120000;

export const OFFLINE_MESSAGE = "You appear to be offline. Check your internet connection and try again.";
export const UNREACHABLE_MESSAGE = "Can't reach the server. Check your internet connection and try again.";
export const TIMEOUT_MESSAGE = "The server took too long to respond. Please try again.";
export const SESSION_EXPIRED_MESSAGE = "Your session has expired. Please sign in again.";
export const GENERIC_MESSAGE = "Something went wrong. Please try again.";

export class ApiError extends Error {
  constructor(message, status) {
    super(message);
    this.name = "ApiError";
    this.status = status;
  }
}

// Browsers word a dropped connection differently: Chrome "Failed to fetch",
// Firefox "NetworkError when attempting to fetch resource.", Safari "Load failed".
// Supabase passes the same messages through on its own errors.
function isNetworkFailure(err) {
  const message = String(err?.message || "");
  return /failed to fetch|networkerror|load failed|network request failed/i.test(message);
}

// The backend answers 402 when the student has used this month's AI actions
export function isQuotaError(err) {
  return err instanceof ApiError && err.status === 402;
}

// Turns any thrown error into a sentence that is safe and useful to show a student.
export function friendlyError(err) {
  if (typeof navigator !== "undefined" && navigator.onLine === false) return OFFLINE_MESSAGE;
  if (err?.name === "AbortError" || err?.name === "TimeoutError") return TIMEOUT_MESSAGE;
  if (isNetworkFailure(err)) return UNREACHABLE_MESSAGE;
  if (err instanceof ApiError) {
    if (err.status === 401) return SESSION_EXPIRED_MESSAGE;
    return err.message || GENERIC_MESSAGE;
  }
  return GENERIC_MESSAGE;
}

// Calls the MathTutor backend as the signed-in user. Resolves with the parsed JSON body,
// or throws (ApiError for server-side failures, the fetch error for network failures).
export async function apiFetch(path, { method = "POST", body, json, timeoutMs = DEFAULT_TIMEOUT_MS } = {}) {
  const { data: { session } } = await supabase.auth.getSession();

  const headers = { Authorization: `Bearer ${session?.access_token}` };
  if (json !== undefined) {
    headers["Content-Type"] = "application/json";
    body = JSON.stringify(json);
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);

  let response;
  try {
    response = await fetch(`${API_URL}${path}`, { method, headers, body, signal: controller.signal });
  } finally {
    clearTimeout(timer);
  }

  let data = null;
  try {
    data = await response.json();
  } catch {
    // Proxies and crashed servers can answer with HTML or nothing at all
  }

  if (!response.ok) {
    throw new ApiError(data?.detail || GENERIC_MESSAGE, response.status);
  }

  return data;
}
