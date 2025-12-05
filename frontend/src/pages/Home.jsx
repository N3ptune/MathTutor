import { useContext, useEffect, useState } from "react";
import { motion } from "framer-motion";
import { AuthState } from "../authState.jsx";
import { 
  loginWithGoogle, 
  registerEmailPassword, 
  loginEmailPassword 
} from "../firebase";
import { useNavigate } from "react-router-dom";
import { supabase } from "../supabase.js";
import "./Home.css";

export default function Home() {
  const navigate = useNavigate();
  const { user, setSupabaseUser } = useContext(AuthState);

  const [showLogin, setShowLogin] = useState(false);
  const [showRegister, setShowRegister] = useState(false);

  const [loginEmail, setLoginEmail] = useState("");
  const [loginPassword, setLoginPassword] = useState("");

  const [regEmail, setRegEmail] = useState("");
  const [regPassword, setRegPassword] = useState("");
  const [regConfirm, setRegConfirm] = useState("");

  // Redirect to dashboard if both Firebase user and Supabase user exist
  useEffect(() => {
    if (user) navigate("/dashboard");
  }, [user, navigate]);

  // ---------------- LOGIN ----------------
  async function handleLoginEmail() {
    try {
      // 1️⃣ Login with Firebase
      const userCred = await loginEmailPassword(loginEmail, loginPassword);

      // 2️⃣ Fetch Supabase user row
      const { data, error } = await supabase
        .from("users") // make sure table name is plural
        .select("*")
        .eq("firebase_uid", userCred.user.uid)
        .single();

      if (error) throw error;

      setSupabaseUser(data);
      setShowLogin(false);
      navigate("/dashboard");
    } catch (err) {
      console.error(err);
      alert("Login failed: " + err.message);
    }
  }

  // ---------------- REGISTER ----------------
  async function handleRegisterEmail() {
    if (regPassword !== regConfirm) {
      alert("Passwords do not match!");
      return;
    }

    try {
      // 1️⃣ Register in Firebase
      const userCred = await registerEmailPassword(regEmail, regPassword);

      // 2️⃣ Insert new Supabase row
      const { data, error } = await supabase
        .from("users")
        .insert([
          {
            email: regEmail,
            firebase_uid: userCred.user.uid,
            // You can add default fields for courses, sections, etc.
          }
        ])
        .select()
        .single();

      if (error) throw error;

      setSupabaseUser(data);
      setShowRegister(false);
      navigate("/dashboard");
    } catch (err) {
      console.error(err);
      alert("Registration failed: " + err.message);
    }
  }

  // ---------------- GOOGLE LOGIN ----------------
  async function handleGoogleLogin() {
    try {
      const userCred = await loginWithGoogle();

      // Check if user already exists in Supabase
      const { data, error } = await supabase
        .from("users")
        .select("*")
        .eq("firebase_uid", userCred.user.uid)
        .single();

      let supabaseData = data;

      if (!supabaseData) {
        // Insert new user if not exist
        const { data: newUser, error: insertError } = await supabase
          .from("users")
          .insert([
            { email: userCred.user.email, firebase_uid: userCred.user.uid }
          ])
          .select()
          .single();

        if (insertError) throw insertError;
        supabaseData = newUser;
      }

      setSupabaseUser(supabaseData);
      setShowLogin(false);
      setShowRegister(false);
      navigate("/dashboard");
    } catch (err) {
      console.error(err);
      alert("Google login failed: " + err.message);
    }
  }

  // ---------------- RENDER ----------------
  return (
    <div className="home-container">
      <motion.h1
        className="home-title"
        initial={{ opacity: 0, y: -40 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 1 }}
      >
        Welcome to MathTutor
      </motion.h1>

      <motion.h2
        className="home-subtitle"
        initial={{ opacity: 0, y: -40 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 1, delay: 0.2 }}
      >
        Let's get you solving
      </motion.h2>

      {!user && (
        <div className="home-buttons">
          <button className="home-button" onClick={() => setShowLogin(true)}>
            Sign In
          </button>
          <button className="home-button" onClick={() => setShowRegister(true)}>
            Register
          </button>
        </div>
      )}

      {/* LOGIN MODAL */}
      {showLogin && (
        <div className="home-modal-overlay">
          <div className="home-modal">
            <button className="modal-close-button" onClick={() => setShowLogin(false)}>×</button>
            <h3>Sign In</h3>
            <input
              className="modal-input"
              type="email"
              placeholder="Email"
              value={loginEmail}
              onChange={(e) => setLoginEmail(e.target.value)}
            />
            <input
              className="modal-input"
              type="password"
              placeholder="Password"
              value={loginPassword}
              onChange={(e) => setLoginPassword(e.target.value)}
            />
            <button className="home-button" onClick={handleLoginEmail}>Sign In</button>
            <p style={{ marginTop: "1rem" }}>or</p>
            <button className="home-button" onClick={handleGoogleLogin}>Sign in with Google</button>
          </div>
        </div>
      )}

      {/* REGISTER MODAL */}
      {showRegister && (
        <div className="home-modal-overlay">
          <div className="home-modal">
            <button className="modal-close-button" onClick={() => setShowRegister(false)}>×</button>
            <h3>Create Account</h3>
            <input
              className="modal-input"
              type="email"
              placeholder="Email"
              value={regEmail}
              onChange={(e) => setRegEmail(e.target.value)}
            />
            <input
              className="modal-input"
              type="password"
              placeholder="Password"
              value={regPassword}
              onChange={(e) => setRegPassword(e.target.value)}
            />
            <input
              className="modal-input"
              type="password"
              placeholder="Confirm Password"
              value={regConfirm}
              onChange={(e) => setRegConfirm(e.target.value)}
            />
            <button className="home-button" onClick={handleRegisterEmail}>Register</button>
            <p style={{ marginTop: "1rem" }}>or</p>
            <button className="home-button" onClick={handleGoogleLogin}>Sign up with Google</button>
          </div>
        </div>
      )}
    </div>
  );
}
