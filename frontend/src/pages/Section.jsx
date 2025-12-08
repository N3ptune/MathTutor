import { useContext, useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { supabase } from "../supabase";
import { AuthState } from "../authState";
import "./Section.css";

export default function Section() {
  const { sectionId } = useParams();
  const { supabaseUser } = useContext(AuthState);
  const [problems, setProblems] = useState([]);
  const navigate = useNavigate();

  // Takes from supabase all sections of the course that the page has been navigated to
  useEffect(() => {
    if (!supabaseUser) return;

    async function fetchProblems() {
      try {
        const { data: problemsData, error } = await supabase
          .from("problem")
          .select("*")
          .eq("sectionId", sectionId);

        if (error) throw error;

        setProblems(problemsData);
      } catch (err) {
        console.error("Failed to fetch problems:", err);
      }
    }

    fetchProblems();
  }, [sectionId, supabaseUser]);

  return (
    <div className="section-container">
      <h1 className="section-title">Section {sectionId}</h1>

      <div className="problems-row">
        {problems.length > 0 ? (
          problems.map((problem) => (
            <div key={problem.problemId} className="problem-card">
              <h3>{problem.title || `Problem ${problem.problemId}`}</h3>
              <button
                className="problem-btn"
                onClick={() => navigate(`/problem/${problem.problemId}`)}
              >
                Go to Problem
              </button>
            </div>
          ))
        ) : (
          <p>No problems available for this section yet.</p>
        )}
      </div>
    </div>
  );
}
