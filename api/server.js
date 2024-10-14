const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
require("dotenv").config();

const authRoutes = require("./routes/authRoutes");
const assetRoutes = require("./routes/assetRoutes");
const userRoutes = require("./routes/userRoutes");
const postRoutes = require("./routes/postRoutes");

const app = express();
app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use("/api/auth", authRoutes);
app.use("/api/upload", assetRoutes);
app.use("/api/users", userRoutes);
app.use("/api/posts", postRoutes);

app.listen(3000, () => {
  console.log(`Server is running`);
});
