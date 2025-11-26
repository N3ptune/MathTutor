import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import { BrowserRouter, Routes, Route, Link, useLocation } from 'react-router-dom'
import ProblemInput from './pages/Problem_input.jsx'
import Results from './pages/Results.jsx'
import Home from './pages/Home.jsx'
import History from './pages/History.jsx'
import Dashboard from './pages/Dashboard.jsx'
import { AuthState } from './authState.js'
import Navbar from "./components/Navbar.jsx";


function AppContent() {
  const location = useLocation();
  const isHomePage = location.pathname === '/';

  return (
    <>
      {/* Show the hamburger navbar on all pages EXCEPT home */}
      {!isHomePage && <Navbar />}

      <Routes>
        <Route path = "/" element = {<Home />} />
        <Route path = "/input" element = {<ProblemInput/>} />
        <Route path = "/results" element = {<Results />} />
        <Route path = "/history" element = {<History />} />
        <Route path = "/dashboard" element = {<Dashboard />} />
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
