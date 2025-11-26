import { useState } from "react";
import { Link } from "react-router-dom";
import "./Navbar.css";

export default function Navbar({ setLoggedIn }) {
  const [open, setOpen] = useState(false);

  return (
    <>
      {/* Top Bar */}
      <div className="navbar">
        <button className="hamburger" onClick={() => setOpen(!open)}>
          ☰
        </button>
        <h1 className="navbar-title">Welcome, Student</h1>
      </div>

      {/* Sidebar */}
      <div className={`sidebar ${open ? "open" : ""}`}>
        <Link to="/dashboard" onClick={() => setOpen(false)}>Dashboard</Link>
        <Link to="/input" onClick={() => setOpen(false)}>Problem Input</Link>
        <Link to="/results" onClick={() => setOpen(false)}>Results</Link>
        <Link to="/history" onClick={() => setOpen(false)}>History</Link>

        <button
          className="logout-btn"
          onClick={() => {
            setLoggedIn(false);
            setOpen(false);
          }}
        >
          Logout
        </button>
      </div>

      {/* Click-outside overlay */}
      {open && <div className="sidebar-overlay" onClick={() => setOpen(false)} />}
    </>
  );
}
