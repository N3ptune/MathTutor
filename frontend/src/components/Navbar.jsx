import { useState } from "react";
import { Link } from "react-router-dom";
import "./Navbar.css";
import { auth } from "../firebase";
import { signOut } from "firebase/auth";

export default function Navbar() {
  const [open, setOpen] = useState(false);

  // Signs the user out
  function handleLogout() {
    signOut(auth).catch((err) => console.error("Logout failed:", err));
    setOpen(false);
  }

  return (
    <>
      {/* Top Bar */}
      <div className="navbar">
        <button className="hamburger" onClick={() => setOpen(!open)}>
          ☰
        </button>
        <h1 className="navbar-title">Math Tutor</h1>
      </div>

      {/* Sidebar */}
      <div className={`sidebar ${open ? "open" : ""}`}>
        <div className="sidebar-links">
          <Link to="/dashboard" onClick={() => setOpen(false)}>Dashboard</Link>
        </div>

        <button className="logout-btn" onClick={handleLogout}>
          Logout
        </button>
      </div>

      {/* Click-outside overlay */}
      {open && <div className="sidebar-overlay" onClick={() => setOpen(false)} />}
    </>
  );
}