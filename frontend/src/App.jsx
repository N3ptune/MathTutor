import { Routes, Route, useLocation } from 'react-router-dom'
import ProblemInput from './pages/Problem_input.jsx'
import Home from './pages/Home.jsx'
import Dashboard from './pages/Dashboard.jsx'
import Navbar from "./components/Navbar.jsx"
import RequireAuth from "./components/RequireAuth.jsx"
import Course from './pages/Course.jsx'
import Section from './pages/Section.jsx'

function AppContent() {
  const location = useLocation();
  const isHomePage = location.pathname === '/';

  return (
    <div className="min-h-screen bg-background text-foreground">
      {!isHomePage && <Navbar />}

      <Routes>
        <Route path="/" element={<Home />} />

        {/* Protected pages */}
        <Route path="/problem/:problemId" element={
          <RequireAuth><ProblemInput /></RequireAuth>
        }/>
        <Route path="/dashboard" element={
          <RequireAuth><Dashboard /></RequireAuth>
        }/>
        <Route path="/course/:courseId" element={<RequireAuth><Course /></RequireAuth>} />
        <Route path="/section/:sectionId" element={<RequireAuth><Section /></RequireAuth>} />
      </Routes>
    </div>
  )
}

export default function App() {
  return <AppContent />;
}
