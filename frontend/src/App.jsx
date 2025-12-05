import { BrowserRouter, Routes, Route, useLocation } from 'react-router-dom'
import ProblemInput from './pages/Problem_Input.jsx'
import Results from './pages/Results.jsx'
import Home from './pages/Home.jsx'
import History from './pages/History.jsx'
import Dashboard from './pages/Dashboard.jsx'
import Navbar from "./components/Navbar.jsx"
import { AuthProvider } from "./authState.jsx"
import RequireAuth from "./components/RequireAuth.jsx"

function AppContent() {
  const location = useLocation();
  const isHomePage = location.pathname === '/';

  return (
    <>
      {!isHomePage && <Navbar />}

      <Routes>
        <Route path="/" element={<Home />} />

        {/* Protected pages */}
        <Route path="/input" element={
          <RequireAuth><ProblemInput /></RequireAuth>
        }/>
        <Route path="/results" element={
          <RequireAuth><Results /></RequireAuth>
        }/>
        <Route path="/history" element={
          <RequireAuth><History /></RequireAuth>
        }/>
        <Route path="/dashboard" element={
          <RequireAuth><Dashboard /></RequireAuth>
        }/>
      </Routes>
    </>
  )
}

export default function App() {
  return (
        <AppContent />
  );
}
