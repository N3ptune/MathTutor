import React, { useState } from "react";
import "./ProblemInput.css";

export default function ProblemInput() {
  const [steps, setSteps] = useState([""]);
  const [feedback, setFeedback] = useState([]); // stores AI feedback per step
  const [isEvaluating, setIsEvaluating] = useState(false);

  // Convert input shortcuts to symbols
  const convertInput = (text) => {
    return text.replace(/sqrt\(/gi, "√(");
  };

  const updateStep = (index, value) => {
    const newSteps = [...steps];
    newSteps[index] = convertInput(value);
    setSteps(newSteps);
  };

  const addStep = () => setSteps([...steps, ""]);

  const deleteStep = (index) => {
    const updatedSteps = steps.filter((_, i) => i !== index);
    const updatedFeedback = feedback.filter((_, i) => i !== index);
    setSteps(updatedSteps);
    setFeedback(updatedFeedback);
  };

  const handleSubmit = async () => {
    setIsEvaluating(true);

    // ⏳ Simulate backend evaluation delay
    setTimeout(() => {
      const fakeFeedback = steps.map((s, i) =>
        s.trim()
          ? `Step ${i + 1} looks good, but consider simplifying.`
          : `Step ${i + 1} is empty.`
      );

      setFeedback(fakeFeedback);
      setIsEvaluating(false);
    }, 2000);

    // Later you'll replace this with a real call:
    /*
    const response = await fetch("/evaluate", {
      method: "POST",
      body: JSON.stringify({ steps }),
    });
    const data = await response.json();
    setFeedback(data.feedback);
    setIsEvaluating(false);
    */
  };

  return (
    <div className="problem-input-container">
      <div className="problem-header">Solve the Problem</div>

      {/* Problem Display */}
      <div className="problem-display">
        <img
          src="/example-problem.png"
          alt="Math Problem"
          className="problem-img"
        />
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
