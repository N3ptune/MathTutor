import { useContext } from 'react'
import { Routes, Route, useLocation } from 'react-router-dom'
import { AuthState } from './authState.jsx'
import ProblemInput from './pages/Problem_input.jsx'
import Home from './pages/Home.jsx'
import Dashboard from './pages/Dashboard.jsx'
import Navbar from "./components/Navbar.jsx"
import RequireAuth from "./components/RequireAuth.jsx"
import Course from './pages/Course.jsx'
import Section from './pages/Section.jsx'
import ProficiencyExam from './pages/ProficiencyExam.jsx'
import Proficiency from './pages/Proficiency.jsx'
import RegisterClasses from './pages/RegisterClasses.jsx'
import Account from './pages/Account.jsx'
import ResetPassword from './pages/ResetPassword.jsx'
import Terms from './pages/legal/Terms.jsx'
import Privacy from './pages/legal/Privacy.jsx'
import Refunds from './pages/legal/Refunds.jsx'
import Footer from './components/Footer.jsx'

function AppContent() {
  const location = useLocation();
  const { user } = useContext(AuthState);
  const isHomePage = location.pathname === '/';

  return (
    <div className="min-h-screen flex flex-col bg-background text-foreground">
      {/* Legal pages are public, so only show the app menu to signed-in users */}
      {!isHomePage && user && <Navbar />}

      <main className="flex-1 flex flex-col">

      <Routes>
        <Route path="/" element={<Home />} />

        {/* Protected pages */}
        <Route path="/problem/:problemId" element={
          <RequireAuth><ProblemInput /></RequireAuth>
        }/>
        <Route path="/dashboard" element={
          <RequireAuth><Dashboard /></RequireAuth>
        }/>
        <Route path="/proficiency" element={
          <RequireAuth><Proficiency /></RequireAuth>
        }/>
        <Route path="/course/:courseId" element={<RequireAuth><Course /></RequireAuth>} />
        <Route path="/section/:sectionId" element={<RequireAuth><Section /></RequireAuth>} />
        <Route path="/section/:sectionId/exam" element={<RequireAuth><ProficiencyExam /></RequireAuth>} />
        <Route path="/register" element={<RequireAuth><RegisterClasses /></RequireAuth>} />
        <Route path="/account" element={<RequireAuth><Account /></RequireAuth>} />

        {/* Public pages */}
        <Route path="/reset-password" element={<ResetPassword />} />
        <Route path="/terms" element={<Terms />} />
        <Route path="/privacy" element={<Privacy />} />
        <Route path="/refunds" element={<Refunds />} />
      </Routes>
      </main>

      <Footer />
    </div>
  )
}

export default function App() {
  return <AppContent />;
}
