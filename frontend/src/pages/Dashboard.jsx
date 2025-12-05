// Dashboard.jsx
import { useContext, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "../supabase.js";
import { AuthState } from "../authState.jsx";
import "./Dashboard.css";

export default function Dashboard() {
  const { supabaseUser } = useContext(AuthState);
  const [courses, setCourses] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    if (!supabaseUser) return; // Wait until user info is loaded

    async function fetchCourses() {
      try {
        // Assuming you have a join table 'user_courses' linking user_id -> course_id
        const { data: enrollmentData, error: enrollError } = await supabase
          .from("user_course")          // your join table
          .select("course_id")           // select the course IDs
          .eq("user_id", supabaseUser.id);

        if (enrollError) throw enrollError;

        if (enrollmentData.length === 0) {
          setCourses([]); // No courses enrolled
          return;
        }

        // Fetch course info based on IDs
        const courseIds = enrollmentData.map((e) => e.course_id);

        const { data: courseData, error: courseError } = await supabase
          .from("course")              // your courses table
          .select("*")
          .in("id", courseIds);

        if (courseError) throw courseError;

        setCourses(courseData);
      } catch (err) {
        console.error("Failed to fetch courses:", err);
      }
    }

    fetchCourses();
  }, [supabaseUser]);

  return (
    <div className="dashboard-container">

      {/* Header Section */}
      <div className="dashboard-header">
        <h1 className="dashboard-welcome">
          Welcome, {supabaseUser?.email || "Student"}
        </h1>
      </div>

      {/* Progress Section */}
      <div className="progress-section">
        <h2 className="section-title">Your Progress</h2>
        <div className="stats-row">
          <div className="stat-card">Proficiency Chart</div>
          <div className="stat-card">Recent Activity</div>
          <div className="stat-card">Time Spent</div>
        </div>
      </div>

      {/* Classes Section */}
      <div className="classes-section">
        <h2 className="section-title">Your Classes</h2>

        <div className="classes-row">
          {courses.length > 0 ? (
            courses.map((course) => (
              <div key={course.id} className="class-card">
                <h3>{course.name}</h3>
                <button
                  className="class-btn"
                  onClick={() => navigate(`/course/${course.id}`)}
                >
                  Go to Class
                </button>
              </div>
            ))
          ) : (
            <p>No classes enrolled yet.</p>
          )}
        </div>
      </div>
    </div>
  );
}
