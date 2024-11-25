import React from "react";

function IntroductionSection() {
  return (
    <div className="introduction-section">
      <h2>Welcome to Brave Beacon</h2>
      <p>
        Discover the magical world of Brave Beacon! Adventure, friendship, and life lessons come alive
        in every episode. Let’s embark on an unforgettable journey!
      </p>
      <div>
        <a href="#characters" className="btn btn-primary">
          Meet the Characters
        </a>
        <a href="epizodes.html" className="btn btn-success">
          Start Watching
        </a>
      </div>
    </div>
  );
}

export default IntroductionSection;
