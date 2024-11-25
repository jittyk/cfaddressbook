import React from "react";

function QuickNavigation() {
  const navigationItems = [
    { href: "epizodes.html", imgSrc: "episodes-icon.png", text: "Episodes" },
    { href: "characters.html", imgSrc: "characters-icon.png", text: "Character Bios" },
    { href: "news.html", imgSrc: "news-icon.png", text: "News" },
  ];

  return (
    <div className="quick-navigation">
      <div className="container">
        <div className="row">
          {navigationItems.map((item, index) => (
            <div className="col-md-4 nav-item" key={index}>
              <a href={item.href}>
                <img src={item.imgSrc} alt={item.text} className="img-fluid" />
                <p>{item.text}</p>
              </a>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

export default QuickNavigation;
