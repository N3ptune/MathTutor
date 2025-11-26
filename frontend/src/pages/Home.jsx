import { useState } from "react";
import { motion } from "framer-motion";
import { AuthState } from "../authState.js";
import { useNavigate } from "react-router-dom";
import "./Home.css";

export default function Home({ setLoggedIn }) {
  const navigate = useNavigate();
  const [authState, setAuthState] = useState(AuthState.Unknown);
  const [showLogin, setShowLogin] = useState(false);
  const [showRegister, setShowRegister] = useState(false);

  // Login form state
  const [loginUsername, setLoginUsername] = useState("");
  const [loginPassword, setLoginPassword] = useState("");

  // Register form state
  const [regUsername, setRegUsername] = useState("");
  const [regEmail, setRegEmail] = useState("");
  const [regPassword, setRegPassword] = useState("");
  const [regConfirmPassword, setRegConfirmPassword] = useState("");

  // Handle login
  const handleLogin = () => {
  console.log("Logging in:", loginUsername, loginPassword);
  setAuthState(AuthState.Authenticated);
  setLoggedIn(true);
  setShowLogin(false);
  navigate("/dashboard");   // NEW LINE
  };


  // Handle register
  const handleRegister = () => {
    if (regPassword !== regConfirmPassword) {
      alert("Passwords do not match!");
      return;
    }
    console.log("Registering:", regUsername, regEmail, regPassword);
    setAuthState(AuthState.Authenticated);
    setLoggedIn(true);
    setShowRegister(false);
    navigate("/dashboard");
  };

  return (
    <div className="home-container">
      {/* Main Title */}
      <motion.h1
        className="home-title"
        initial={{ opacity: 0, y: -40 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 1 }}
      >
        Welcome to MathTutor
      </motion.h1>

      {/* Subtitle */}
      <motion.h2
        className="home-subtitle"
        initial={{ opacity: 0, y: -40 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 1, delay: 0.2 }}
      >
        Let's get you solving
      </motion.h2>

      {/* Buttons */}
      {authState !== AuthState.Authenticated && (
        <div className="home-buttons">
          <button className="home-button" onClick={() => setShowLogin(true)}>
            Login
          </button>
          <button className="home-button" onClick={() => setShowRegister(true)}>
            Register
          </button>
        </div>
      )}

      {/* Login Modal */}
      {showLogin && (
        <div className="home-modal-overlay">
          <div className="home-modal">
            <button
              className="modal-close-button"
              onClick={() => setShowLogin(false)}
            >
              ×
            </button>
            <h3>Login</h3>
            <input
              type="text"
              placeholder="Username"
              value={loginUsername}
              onChange={(e) => setLoginUsername(e.target.value)}
              className="modal-input"
            />
            <input
              type="password"
              placeholder="Password"
              value={loginPassword}
              onChange={(e) => setLoginPassword(e.target.value)}
              className="modal-input"
            />
            <button className="home-button" onClick={handleLogin}>
              Login
            </button>
          </div>
        </div>
      )}

      {/* Register Modal */}
      {showRegister && (
        <div className="home-modal-overlay">
          <div className="home-modal">
            <button
              className="modal-close-button"
              onClick={() => setShowRegister(false)}
            >
              ×
            </button>
            <h3>Register</h3>
            <input
              type="text"
              placeholder="Username"
              value={regUsername}
              onChange={(e) => setRegUsername(e.target.value)}
              className="modal-input"
            />
            <input
              type="email"
              placeholder="Email"
              value={regEmail}
              onChange={(e) => setRegEmail(e.target.value)}
              className="modal-input"
            />
            <input
              type="password"
              placeholder="Password"
              value={regPassword}
              onChange={(e) => setRegPassword(e.target.value)}
              className="modal-input"
            />
            <input
              type="password"
              placeholder="Confirm Password"
              value={regConfirmPassword}
              onChange={(e) => setRegConfirmPassword(e.target.value)}
              className="modal-input"
            />
            <button className="home-button" onClick={handleRegister}>
              Register
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
