import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import { BrowserRouter, Routes, Route, Link, useLocation } from 'react-router-dom'
import ProblemInput from './pages/Problem_input.jsx'
import Results from './pages/Results.jsx'
import Home from './pages/Home.jsx'
import History from './pages/History.jsx'
import { AuthState } from './authState.js'

function AppContent() {
  const location = useLocation();
  const isHomePage = location.pathname === '/';

  return (
    <>
      {!isHomePage && (
        <nav style = {{display: "flex", gap: "1rem", padding: "1rem"}}>
          <Link to = "/">Home</Link>
          <Link to = "/input">Problem</Link>
          <Link to = "/results">Results</Link>
          <Link to = "/history">History</Link>
        </nav>
      )}

      <Routes>
        <Route path = "/" element = {<Home />} />
        <Route path = "/input" element = {<ProblemInput/>} />
        <Route path = "/results" element = {<Results />} />
        <Route path = "/history" element = {<History />} />
      </Routes>
    </>
  )
}

function App() {
  return (
    <BrowserRouter>
      <AppContent />
    </BrowserRouter>
  )
}

export default App
