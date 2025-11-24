import React from "react";
import "./App.css";

function App() {
  const deployedAt = new Date().toLocaleString();

  return (
    <div className="App">
      <header className="App-header">
        <h1>DevOps Final Project</h1>
        <p>React + Docker + Jenkins + AWS EC2</p>

        <div className="card">
          <h2>Deployment Info</h2>
          <ul>
            <li><strong>Image:</strong> balaarasan12/dev-final:latest</li>
            <li><strong>Environment:</strong> Dev (EC2 Docker)</li>
            <li><strong>Last Deployed:</strong> {deployedAt}</li>
          </ul>
        </div>

        <div className="card">
          <h2>Pipeline Stages</h2>
          <ol>
            <li>Code push to <code>dev</code> branch</li>
            <li>Jenkins builds Docker image</li>
            <li>Push to Docker Hub</li>
            <li>Auto-deploy to EC2</li>
          </ol>
        </div>

        <div className="card">
          <h2>Author</h2>
          <p><strong>Name:</strong> Bala Arasan</p>
          <p><strong>Role:</strong> DevOps Engineer (Student Project)</p>
        </div>

        <p style={{ marginTop: "2rem", fontSize: "0.9rem" }}>
          Served by Nginx inside a Docker container on AWS EC2.
        </p>
      </header>
    </div>
  );
}

export default App;
