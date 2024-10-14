const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const userModel = require("../models/user");
const db = require("../db/knex");

function generateToken(user) {
  return jwt.sign({ user }, process.env.JWT_SECRET, { expiresIn: "1h" });
}

function authenticateToken(req, res, next) {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  if (token == null) {
    return res.sendStatus(401);
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      return res.sendStatus(403);
    }
    req.user = user;
    next();
  });
}

async function login(req, res) {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: "Email and password are required" });
  }

  try {
    const user = await userModel.loginUser(email);

    if (!user) {
      return res.status(401).json({ error: "Invalid credentials" });
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      return res.status(401).json({ error: "Invalid credentials" });
    }

    const token = generateToken(user);

    res.json({ userId: user.id, token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal server error" });
  }
}

async function signup(req, res) {
  const { last_name, first_name, email, phone, address, zip_code, city, password } = req.body;

  if (!last_name || !first_name || !email || !phone || !address || !zip_code || !city || !password) {
    return res.status(400).json({ error: "All fields are required" });
  }

  try {
    const existingUser = await userModel.loginUser(email);
    if (existingUser) {
      return res.status(400).json({ error: "User already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    await userModel.signUpUser({
      last_name,
      first_name,
      email,
      phone,
      address,
      zip_code,
      city,
      password: hashedPassword,
    });

    res.status(201).json({ success: "User created successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal server error" });
  }
}

module.exports = {
  authenticateToken,
  login,
  signup,
};
