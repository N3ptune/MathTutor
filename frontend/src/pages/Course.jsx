// Course.jsx
import { useEffect, useState, useContext } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { supabase } from "../supabase.js";
import { AuthState } from "../authState.jsx";
import "./Course.css";

export default function Course() {
  const { courseId } = useParams();
  const navigate = useNavigate();
  const { supabaseUser } = useContext(AuthState);

  const [sections, setSections] = useState([]);
  const [courseName, setCourseName] = useState("");

  useEffect(() => {
    if (!supabaseUser) return;

    async function fetchCourseAndSections() {
      try {
        // Fetch course info
        const { data: courseData, error: courseError } = await supabase
          .from("course")
          .select("name")
          .eq("courseId", courseId)
          .single();

        if (courseError) throw courseError;

        setCourseName(courseData.name);

        // Fetch sections for this course
        const { data: sectionData, error: sectionError } = await supabase
          .from("section")
          .select("*")
          .eq("courseId", courseId)
          .order("sectionId", { ascending: true }); // optional ordering

        if (sectionError) throw sectionError;

        setSections(sectionData);
      } catch (err) {
        console.error("Failed to fetch course or sections:", err);
      }
    }

    fetchCourseAndSections();
  }, [supabaseUser, courseId]);

  return (
    <div className="course-container">
      <h1 className="course-title">{courseName}</h1>
      <div className="sections-row">
        {sections.length > 0 ? (
          sections.map((section) => (
            <div key={section.sectionId} className="section-card">
              <h3>{section.name}</h3>
              <button
                className="section-btn"
                onClick={() => navigate(`/section/${section.sectionId}`)}
              >
                Go to Section
              </button>
            </div>
          ))
        ) : (
          <p>No sections available for this course.</p>
        )}
      </div>
    </div>
  );
}
