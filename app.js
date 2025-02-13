const express = require("express");
const cors = require("cors");
const morgan = require("morgan");
const path = require("path");

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(cors());
app.use(morgan("dev"));
console.log("ENV: ", process.env.NODE_ENV);
//
// Serve static assets in Production
if (process.env.NODE_ENV === "production") {
  // Set static folder
  app.use(express.static("client/build"));

  app.get("*", (req, res) =>
    res.sendFile(path.resolve(__dirname, "client", "build", "index.html"))
  );
}

app.use("/api/", require("./routes/helloWorld.js"));
app.use("/api/razorpay", require("./routes/razorpay.js"));

module.exports = app;
