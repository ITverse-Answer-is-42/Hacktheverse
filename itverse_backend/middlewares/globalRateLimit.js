const rateLimit = require('express-rate-limit');
const appError = require('../utils/appError');

const globalRateLimit = rateLimit({
    max: 100,
    windowMs: 60 * 1000,
    message: 'Too many requests from this IP, please try again in an hour'
});



module.exports = globalRateLimit;