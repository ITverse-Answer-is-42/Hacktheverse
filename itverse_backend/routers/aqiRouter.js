const express = require("express");
const aqiController = require("../controllers/aqiController");
const router = express.Router();
const rateLimit = require("express-rate-limit");

// const loginRateLimiter = rateLimit({
//   windowMs: 15 * 60 * 1000, // 15 min in milliseconds
//   max: 5,
//   message: `Login error, you have reached maximum retries. Please try again after 30 minutes`,
//   statusCode: 429,
//   headers: true,
// });

router
  .route("/")
  .get(aqiController.getAqi);


module.exports = router;