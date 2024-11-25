import React from "react";

function HeroBanner() {
  return (
    <div className="hero-banner">
      <div id="carouselExample" className="carousel slide" data-bs-ride="carousel">
        <div className="carousel-inner">
          <div className="carousel-item active">
            <img src="trailer1.jpg" className="d-block w-75 mx-auto" alt="Trailer 1" />
          </div>
          <div className="carousel-item">
            <img src="trailer2.jpg" className="d-block w-75 mx-auto" alt="Trailer 2" />
          </div>
          <div className="carousel-item">
            <img src="artwork1.jpg" className="d-block w-75 mx-auto" alt="Artwork 1" />
          </div>
        </div>
        <button
          className="carousel-control-prev"
          type="button"
          data-bs-target="#carouselExample"
          data-bs-slide="prev"
        >
          <span className="carousel-control-prev-icon" aria-hidden="true"></span>
          <span className="visually-hidden">Previous</span>
        </button>
        <button
          className="carousel-control-next"
          type="button"
          data-bs-target="#carouselExample"
          data-bs-slide="next"
        >
          <span className="carousel-control-next-icon" aria-hidden="true"></span>
          <span className="visually-hidden">Next</span>
        </button>
      </div>
      <a href="latest-episode.html" className="btn btn-watch">
        Watch Now
      </a>
    </div>
  );
}

export default HeroBanner;
