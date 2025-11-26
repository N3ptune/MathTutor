import "./Dashboard.css";

export default function Dashboard({ user = "Student" }) {
  return (
    <div className="dashboard-container">

      {/* Header Section */}
      <div className="dashboard-header">
        <h1 className="dashboard-welcome">Welcome, {user}</h1>
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

      {/* Classes Divider Section */}
      <div className="classes-section">
        <h2 className="section-title">Your Classes</h2>

        <div className="classes-row">
          <div className="class-card">
            <h3>Algebra I</h3>
            <button className="class-btn">Go to Class</button>
          </div>

          <div className="class-card">
            <h3>Geometry</h3>
            <button className="class-btn">Go to Class</button>
          </div>

          <div className="class-card">
            <h3>Calculus</h3>
            <button className="class-btn">Go to Class</button>
          </div>
        </div>
      </div>

    </div>
  );
}
