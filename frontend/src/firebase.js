import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
  apiKey: "AIzaSyAMjHhEku57UwIBxBM4qcoDTJPvTzEk5Ec",
  authDomain: "mathtutor-4b872.firebaseapp.com",
  projectId: "mathtutor-4b872",
  storageBucket: "mathtutor-4b872.firebasestorage.app",
  messagingSenderId: "1037179980562",
  appId: "1:1037179980562:web:e7c16a12b5ff91146cc1cb",
  measurementId: "G-44XLRGT2WP"
};

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);