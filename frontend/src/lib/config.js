// Product settings shown in the UI. Plan limits must match PLANS in
// backend/app/services/usage_service.py, which is what actually enforces them.
export const PRODUCT_NAME = "MathTutor";
// Set VITE_SUPPORT_EMAIL at build time; contact links are hidden until it is
export const SUPPORT_EMAIL = import.meta.env.VITE_SUPPORT_EMAIL || "";

export const PLANS = {
  free: { name: "Free", price: 0, monthlyActions: 15 },
  pro: { name: "Pro", price: 9.99, monthlyActions: 500 },
};

// Bump when the Terms or Privacy Policy change materially; everyone is asked to accept again.
export const TERMS_VERSION = "2026-09-25";
export const MINIMUM_AGE = 13;

// Legal details shown in the Terms and Privacy Policy. Fill these in (VITE_LEGAL_ENTITY,
// VITE_GOVERNING_LAW) before charging anyone, and have a lawyer review those pages.
export const LEGAL_ENTITY = import.meta.env.VITE_LEGAL_ENTITY || "the operator of MathTutor";
export const GOVERNING_LAW = import.meta.env.VITE_GOVERNING_LAW || "the United States";
export const LEGAL_LAST_UPDATED = "September 25, 2026";
