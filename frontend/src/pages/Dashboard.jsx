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
    if (!supabaseUser) return;

    // Function fetchCourses takes in no arguments
    // From table user_course it selects the courseId where userId is equal to the fetched userId
    // Then, if no classes exist for this user, it displays no classes enrolled yet. Otherwise, it generates containers for each class that
    // has a button to navigate to a dynamically populated page with the chosen class information.
    async function fetchCourses() {
      try {
        const { data: enrollmentData, error: enrollError } = await supabase
          .from("user_course")
          .select("courseId")
          .eq("userId", supabaseUser.userId);

        if (enrollError) throw enrollError;

        if (enrollmentData.length === 0) {
          setCourses([]);
          return;
        }

        const courseIds = enrollmentData.map((e) => e.courseId);

        const { data: courseData, error: courseError } = await supabase
          .from("course")
          .select("*")
          .in("courseId", courseIds);

        if (courseError) throw courseError;

        setCourses(courseData);
      } catch (err) {
        console.error("Failed to fetch courses:", err);
      }
    }

    fetchCourses();
  }, [supabaseUser]);

  // Returns three different sections:
  // A header section that welcomes the user email from supabase
  // A progress section that takes in information from supabase to generate statistics
  // A class section that has containers for each class enrolled.
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
              <div key={course.courseId} className="class-card">
                <h3>{course.name}</h3>
                <button
                  className="class-btn"
                  onClick={() => navigate(`/course/${course.courseId}`)}
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
