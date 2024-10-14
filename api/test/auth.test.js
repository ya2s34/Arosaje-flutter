const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const userModel = require("../models/user");
const { login, signup } = require("../controllers/auth");

jest.mock("jsonwebtoken");
jest.mock("bcrypt");
jest.mock("../models/user");

describe("User Controller", () => {
  describe("login", () => {
    test("should log in a user with valid credentials", async () => {
      // Mocked request and response objects
      const req = {
        body: { email: "test@example.com", password: "password" },
      };
      const res = { json: jest.fn() };

      // Mocking loginUser function of userModel to return a mock user
      const mockUser = { id: 1, email: "test@example.com", password: "hashedPassword" };
      userModel.loginUser = jest.fn().mockResolvedValueOnce(mockUser);

      // Mocking bcrypt.compare to return true
      bcrypt.compare.mockResolvedValueOnce(true);

      // Mocking jwt.sign to return a mock token
      jwt.sign.mockReturnValueOnce("mockToken");

      // Calling the login function
      await login(req, res);

      // Assertions
      expect(userModel.loginUser).toHaveBeenCalledWith("test@example.com");
      expect(bcrypt.compare).toHaveBeenCalledWith("password", "hashedPassword");
      expect(jwt.sign).toHaveBeenCalledWith(mockUser, process.env.JWT_SECRET, { expiresIn: "1h" });
      expect(res.json).toHaveBeenCalledWith({ userId: 1, token: "mockToken" });
    });

    test("should handle invalid credentials", async () => {
      // Mocked request and response objects
      const req = {
        body: { email: "test@example.com", password: "password" },
      };
      const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };

      // Mocking loginUser function of userModel to return null (user not found)
      userModel.loginUser = jest.fn().mockResolvedValueOnce(null);

      // Calling the login function
      await login(req, res);

      // Assertions
      expect(userModel.loginUser).toHaveBeenCalledWith("test@example.com");
      expect(res.status).toHaveBeenCalledWith(401);
      expect(res.json).toHaveBeenCalledWith({ error: "Invalid credentials" });
    });

    // Add more test cases for edge cases
  });

  describe("signup", () => {
    test("should sign up a new user", async () => {
      // Mocked request and response objects
      const req = {
        body: {
          last_name: "Doe",
          first_name: "John",
          email: "johndoe@example.com",
          phone: "123456789",
          address: "123 Main St",
          zip_code: "12345",
          city: "New York",
          password: "password",
        },
      };
      const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };

      // Mocking loginUser function of userModel to return null (user not found)
      userModel.loginUser = jest.fn().mockResolvedValueOnce(null);

      // Mocking bcrypt.hash to return a hashed password
      bcrypt.hash.mockResolvedValueOnce("hashedPassword");

      // Calling the signup function
      await signup(req, res);

      // Assertions
      expect(userModel.loginUser).toHaveBeenCalledWith("johndoe@example.com");
      expect(bcrypt.hash).toHaveBeenCalledWith("password", 10);
      expect(userModel.signUpUser).toHaveBeenCalledWith({
        last_name: "Doe",
        first_name: "John",
        email: "johndoe@example.com",
        phone: "123456789",
        address: "123 Main St",
        zip_code: "12345",
        city: "New York",
        password: "hashedPassword",
      });
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith({ success: "User created successfully" });
    });

    test("should handle existing user during signup", async () => {
      // Mocked request and response objects
      const req = {
        body: {
          last_name: "Doe",
          first_name: "John",
          email: "johndoe@example.com",
          phone: "123456789",
          address: "123 Main St",
          zip_code: "12345",
          city: "New York",
          password: "password",
        },
      };
      const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };

      // Mocking loginUser function of userModel to return an existing user
      userModel.loginUser = jest.fn().mockResolvedValueOnce({ email: "johndoe@example.com" });

      // Calling the signup function
      await signup(req, res);

      // Assertions
      expect(userModel.loginUser).toHaveBeenCalledWith("johndoe@example.com");
      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({ error: "User already exists" });
    });
  });
});
