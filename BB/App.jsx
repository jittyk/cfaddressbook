import React from "react";
import HeroBanner from "./components/HeroBanner";
import IntroductionSection from "./components/IntroductionSection";
import QuickNavigation from "./components/QuickNavigation";
import "./index.css";

function App() {
  return (
    <div>
      <HeroBanner />
      <IntroductionSection />
      <QuickNavigation />
    </div>
  );
}

export default App;
