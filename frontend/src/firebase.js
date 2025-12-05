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

// Firebase config
const firebaseConfig = {
  apiKey: "AIzaSyAMjHhEku57UwIBxBM4qcoDTJPvTzEk5Ec",
  authDomain: "mathtutor-4b872.firebaseapp.com",
  projectId: "mathtutor-4b872",
  storageBucket: "mathtutor-4b872.firebasestorage.app",
  messagingSenderId: "1037179980562",
  appId: "1:1037179980562:web:e7c16a12b5ff91146cc1cb",
  measurementId: "G-44XLRGT2WP"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const googleProvider = new GoogleAuthProvider();

// Firebase functions
export async function loginWithGoogle() {
  return signInWithPopup(auth, googleProvider);
}

export async function registerEmailPassword(email, password) {
  return createUserWithEmailAndPassword(auth, email, password);
}

export async function loginEmailPassword(email, password) {
  return signInWithEmailAndPassword(auth, email, password);
}

export async function logout() {
  return signOut(auth);
}

setPersistence(auth, browserSessionPersistence)
  .then(() => {
    console.log("Session persistence set to browserSessionPersistence");
  })
  .catch((err) => {
    console.error("Error setting persistence:", err);
  });