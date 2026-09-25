import { TERMS_VERSION } from "./config";

// True until the user has accepted the current version of the Terms and Privacy Policy
export function needsConsent(appUser) {
  return !appUser?.termsAcceptedAt || appUser.termsVersion !== TERMS_VERSION;
}
