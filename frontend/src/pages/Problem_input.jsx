import React, { useState, useEffect, useContext } from "react";
import { useParams } from "react-router-dom";
import { supabase } from "../supabase";
import { AuthState } from "../authState.jsx";
import "./ProblemInput.css";

export default function ProblemInput() {
  const { problemId } = useParams();
  const { supabaseUser } = useContext(AuthState);

  const [problemText, setProblemText] = useState("");
  const [steps, setSteps] = useState([""]);
  const [feedback, setFeedback] = useState([]);
  const [isEvaluating, setIsEvaluating] = useState(false);

  // Takes no arguments
  // Fetches the arguments from supabase, and then stores the problem text
  useEffect(() => {
    if (!supabaseUser) return;

    async function fetchProblem() {
      try {
        const { data, error } = await supabase
          .from("problem")
          .select("*")
          .eq("problemId", problemId)
          .single();

        if (error) throw error;

        setProblemText(data.problem);
      } catch (err) {
        console.error("Failed to fetch problem:", err);
      }
    }

    fetchProblem();
  }, [problemId, supabaseUser]);

  // Takes in the text that should be replaced
  // Will convert text to the proper symbols, so that the problem does not look messy.
  // Implementation of limits and integral will be very interesting
  const convertInput = (text) => {
    return text.replace(/sqrt\(/gi, "√(");
  };

  // Takes in the index, which is the number step it is, and value, which is whatever is being typed into the box
  const updateStep = (index, value) => {
    const newSteps = [...steps];
    newSteps[index] = convertInput(value);
    setSteps(newSteps);
  };

  // Adds a step below existing steps
  const addStep = () => setSteps([...steps, ""]);

  // Takes in the index of the step that is being deleted
  // Deletes a step, changes indexes and relevant correlatedinformation if necessary
  const deleteStep = (index) => {
    const updatedSteps = steps.filter((_, i) => i !== index);
    const updatedFeedback = feedback.filter((_, i) => i !== index);
    setSteps(updatedSteps);
    setFeedback(updatedFeedback);
  };

  // Takes no argumnets
  // Takes the steps, and will pass them to a processor that will format them to be submitted to backend
  // Will then set the feedback to be shown, which will also be processed in the backend
  const handleSubmit = async () => {
  setIsEvaluating(true);

  try {
    //Log what you're sending
    console.log("Submitting steps:", steps);
    console.log("Submitting problemId:", problemId);

    // Make sure problemId is a number
    const bodyData = { problemId: Number(problemId), steps };
    console.log("POST body:", bodyData);

    // Send request
    const response = await fetch("http://localhost:8000/api/evaluate/", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(bodyData),
    });

    // Log response status
    console.log("Response status:", response.status);

    // Parse JSON safely
    let data;
    try {
      data = await response.json();
      console.log("Response JSON:", data);
    } catch (jsonErr) {
      console.error("Failed to parse JSON:", jsonErr);
      data = {};
    }

    // Update feedback
    setFeedback(data.feedback || steps.map(() => "No feedback received"));

  } catch (err) {
    console.error("Evaluation error:", err);
  }

  setIsEvaluating(false);
};


  return (
    <div className="problem-input-container">
      <div className="problem-header">Solve the Problem</div>

      {/* Problem Display */}
      <div className="problem-display">
        <p className="problem-text">{problemText || "Loading problem..."}</p>
      </div>

      <div className="content-row">

        {/* LEFT — STEPS */}
        <div className="steps-column">
          <h2>Steps</h2>

          {steps.map((step, index) => (
            <div key={index} className="step-feedback-row">

              <div className="step-box">
                <span
                  className="delete-step"
                  onClick={() => deleteStep(index)}
                >
                  ×
                </span>

                <label><strong>Step {index + 1}</strong></label>

                <input
                  type="text"
                  value={step}
                  onChange={(e) => updateStep(index, e.target.value)}
                  placeholder="Enter step..."
                />
              </div>

              {/* FEEDBACK BOX */}
              {feedback[index] && (
                <div className="feedback-box">
                  {feedback[index]}
                </div>
              )}

            </div>
          ))}

          <button className="add-step-btn" onClick={addStep}>
            + Add Step
          </button>
        </div>
      </div>

      {/* SUBMIT BUTTON */}
      <div className="submit-container">
        <button className="submit-btn" onClick={handleSubmit}>
          Submit Steps
        </button>
      </div>

      {/* EVALUATION POPUP */}
      {isEvaluating && (
        <div className="eval-overlay">
          <div className="eval-popup">
            <div className="spinner"></div>
            <p>Evaluating...</p>
          </div>
        </div>
      )}
    </div>
  );
}
