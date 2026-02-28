// firebase.js
import { initializeApp } from "firebase/app";
import {
  getAuth,
  GoogleAuthProvider,
  signInWithPopup,
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
  signOut,
  setPersistence,
  browserSessionPersistence
} from "firebase/auth";

const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
  authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId: import.meta.env.VITE_FIREBASE_APP_ID
};

const hasFirebaseConfig = [
  firebaseConfig.apiKey,
  firebaseConfig.authDomain,
  firebaseConfig.projectId,
  firebaseConfig.storageBucket,
  firebaseConfig.messagingSenderId,
  firebaseConfig.appId,
].every(Boolean);

// #region agent log 66f9c4
console.error('[DEBUG 66f9c4] Firebase config check:', {
  apiKey: typeof firebaseConfig.apiKey + '/' + (firebaseConfig.apiKey?.length ?? 0),
  authDomain: typeof firebaseConfig.authDomain + '/' + (firebaseConfig.authDomain?.length ?? 0),
  projectId: typeof firebaseConfig.projectId + '/' + (firebaseConfig.projectId?.length ?? 0),
  storageBucket: typeof firebaseConfig.storageBucket + '/' + (firebaseConfig.storageBucket?.length ?? 0),
  messagingSenderId: typeof firebaseConfig.messagingSenderId + '/' + (firebaseConfig.messagingSenderId?.length ?? 0),
  appId: typeof firebaseConfig.appId + '/' + (firebaseConfig.appId?.length ?? 0),
  hasFirebaseConfig,
});
// #endregion

// Initialize Firebase
let app = null;
let authInstance = null;

if (hasFirebaseConfig) {
  try {
    app = initializeApp(firebaseConfig);
  } catch (error) {
    // #region agent log 66f9c4
    console.error('[DEBUG 66f9c4] Firebase initializeApp error:', error.message);
    // #endregion
    console.error("Failed to initialize Firebase app:", error);
  }

  try {
    authInstance = app ? getAuth(app) : null;
  } catch (error) {
    // #region agent log 66f9c4
    console.error('[DEBUG 66f9c4] Firebase getAuth error:', error.message);
    // #endregion
    console.error("Failed to initialize Firebase auth:", error);
  }
}

// #region agent log 66f9c4
console.error('[DEBUG 66f9c4] Firebase init result:', { appInitialized: !!app, authReady: !!authInstance });
// #endregion

export const auth = authInstance;
export const googleProvider = new GoogleAuthProvider();
export const isFirebaseAuthConfigured = Boolean(authInstance);

// Firebase functions
function assertFirebaseAuthConfigured() {
  if (!auth) {
    throw new Error("Firebase auth is not configured. Set VITE_FIREBASE_* values in frontend/.env.");
  }
}

export async function loginWithGoogle() {
  assertFirebaseAuthConfigured();
  return signInWithPopup(auth, googleProvider);
}

export async function registerEmailPassword(email, password) {
  assertFirebaseAuthConfigured();
  return createUserWithEmailAndPassword(auth, email, password);
}

export async function loginEmailPassword(email, password) {
  assertFirebaseAuthConfigured();
  return signInWithEmailAndPassword(auth, email, password);
}

export async function logout() {
  assertFirebaseAuthConfigured();
  return signOut(auth);
}

if (auth) {
  setPersistence(auth, browserSessionPersistence)
    .then(() => {
      console.log("Session persistence set to browserSessionPersistence");
    })
    .catch((err) => {
      console.error("Error setting persistence:", err);
    });
}