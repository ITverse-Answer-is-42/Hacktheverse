const express = require("express");
const aqiController = require("../controllers/aqiController");
const router = express.Router();
const rateLimit = require("express-rate-limit");

const aqiRateLimiter = rateLimit({
  windowMs: 60 * 1000, 
  max: 15,
  message: `Too many requests from this IP, please try again`,
  statusCode: 429,
  headers: true,
});

router
  .route("/")
  .get(aqiRateLimiter,aqiController.getAqi);

router
  .route("/markers")
  .get(aqiController.getMarkers);


module.exports = router;