// @ts-nocheck
const dotenv = require("dotenv");
const colors = require("colors");
const mongoose = require("mongoose");

process.on("uncaughtException", (err) => {
  console.log("UNCAUGHT EXCEPTION! Shutting down...");
  console.log(err.name, err.message);
  process.exit(1);
});


dotenv.config({ path: ".env" });

const port = process.env.PORT || 4000;

const app = require("./app.js");

const URL =  "http://localhost:"+port;
const DB = process.env.DB_LOCAL || process.env.DB_ATLAS;

mongoose
  .connect(DB)
  .then((cons) => {
    //console.log(cons.connections);
    console.log("MONGODB connected successfully".brightCyan);
  })
  .catch((err) => {
    console.log("Database connection unsuccessful!".red,err);
  });

const server = app.listen(port, () => {
  console.log(
    `App running on ${URL} in ${process.env.NODE_ENV} mode....`.brightMagenta
  );
});

process.on("unhandledRejection", (err) => {
  console.log("UNHANDLED REJECTION! Shutting down...");
  console.log(err.name, err.message);
  server.close(() => {
    process.exit(1);
  });
});