const userModel = require("../models/user");
const {
  createUser,
  getAllUsers,
  getUserById,
  updateUser,
  deleteUser,
  updateBotanistStatus,
  getAllUsernames,
} = require("../controllers/user");

jest.mock("../models/user");

describe("User Controller", () => {
  describe("createUser", () => {
    test("should create a new user", async () => {
      // Mocked request and response objects
      const req = { body: {} };
      const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };

      // Mocking createUser function of userModel
      userModel.createUser = jest.fn();

      // Calling the createUser function
      await createUser(req, res);

      // Assertions
      expect(userModel.createUser).toHaveBeenCalledWith(req.body);
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith({ message: "User created successfully" });
    });

    test("should handle error during user creation", async () => {
      // Mocked request and response objects
      const req = { body: {} };
      const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };

      // Mocking createUser function of userModel to throw an error
      const errorMessage = "Mock error message";
      userModel.createUser = jest.fn().mockRejectedValueOnce(new Error(errorMessage));

      // Spy on console.error
      const consoleErrorSpy = jest.spyOn(console, "error").mockImplementation(() => {});

      // Calling the createUser function
      await createUser(req, res);

      // Assertions
      expect(userModel.createUser).toHaveBeenCalledWith(req.body);
      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({ error: "Internal server error" });
      expect(consoleErrorSpy).toHaveBeenCalled(); // Check if console.error was called

      // Restoring console.error to its original implementation
      consoleErrorSpy.mockRestore();
    });
  });

  describe("getAllUsers", () => {
    test("should return all users", async () => {
      // Mocked request and response objects
      const req = {};
      const res = { json: jest.fn() };

      // Mocking getAllUsers function of userModel to return some mock users
      const mockUsers = [
        { id: 1, name: "User 1" },
        { id: 2, name: "User 2" },
      ];
      userModel.getAllUsers = jest.fn().mockResolvedValueOnce(mockUsers);

      // Calling the getAllUsers function
      await getAllUsers(req, res);

      // Assertions
      expect(userModel.getAllUsers).toHaveBeenCalled();
      expect(res.json).toHaveBeenCalledWith(mockUsers);
    });

    test("should handle error when fetching users", async () => {
      // Mocked request and response objects
      const req = {};
      const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };

      // Mocking getAllUsers function of userModel to throw an error
      const errorMessage = "Mock error message";
      userModel.getAllUsers = jest.fn().mockRejectedValueOnce(new Error(errorMessage));

      // Spy on console.error
      const consoleErrorSpy = jest.spyOn(console, "error").mockImplementation(() => {});

      // Calling the getAllUsers function
      await getAllUsers(req, res);

      // Assertions
      expect(userModel.getAllUsers).toHaveBeenCalled();
      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({ error: "Internal server error" });
      expect(consoleErrorSpy).toHaveBeenCalled(); // Check if console.error was called

      // Restoring console.error to its original implementation
      consoleErrorSpy.mockRestore();
    });
  });

  describe("getUserById", () => {
    test("should return user with specified ID", async () => {
      // Mocked request and response objects
      const req = { params: { id: 1 } };
      const res = { json: jest.fn(), status: jest.fn().mockReturnThis() };

      // Mocking getUserById function of userModel to return a mock user
      const mockUser = { id: 1, name: "User 1" };
      userModel.getUserById = jest.fn().mockResolvedValueOnce(mockUser);

      // Calling the getUserById function
      await getUserById(req, res);

      // Assertions
      expect(userModel.getUserById).toHaveBeenCalledWith(req.params.id);
      expect(res.json).toHaveBeenCalledWith(mockUser);
    });

    test("should handle error when user is not found", async () => {
      // Mocked request and response objects
      const req = { params: { id: 1 } };
      const res = { json: jest.fn(), status: jest.fn().mockReturnThis() };

      // Mocking getUserById function of userModel to return null (user not found)
      userModel.getUserById = jest.fn().mockResolvedValueOnce(null);

      // Calling the getUserById function
      await getUserById(req, res);

      // Assertions
      expect(userModel.getUserById).toHaveBeenCalledWith(req.params.id);
      expect(res.status).toHaveBeenCalledWith(404);
      expect(res.json).toHaveBeenCalledWith({ error: "User not found" });
    });

    test("should handle error when fetching user by ID", async () => {
      // Mocked request and response objects
      const req = { params: { id: 1 } };
      const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };

      // Mocking getUserById function of userModel to throw an error
      const errorMessage = "Mock error message";
      userModel.getUserById = jest.fn().mockRejectedValueOnce(new Error(errorMessage));

      // Spy on console.error
      const consoleErrorSpy = jest.spyOn(console, "error").mockImplementation(() => {});

      // Calling the getUserById function
      await getUserById(req, res);

      // Assertions
      expect(userModel.getUserById).toHaveBeenCalledWith(req.params.id);
      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({ error: "Internal server error" });
      expect(consoleErrorSpy).toHaveBeenCalled(); // Check if console.error was called

      // Restoring console.error to its original implementation
      consoleErrorSpy.mockRestore();
    });
  });

  describe("updateUser", () => {
    test("should update user successfully", async () => {
      // Mocked request and response objects
      const req = {
        params: { id: 1 },
        body: {
          /* updated user data */
        },
      };
      const res = { json: jest.fn(), status: jest.fn().mockReturnThis() };

      // Mocking updateUser function of userModel to indicate successful update
      userModel.updateUser = jest.fn().mockResolvedValueOnce();

      // Calling the updateUser function
      await updateUser(req, res);

      // Assertions
      expect(userModel.updateUser).toHaveBeenCalledWith(req.params.id, req.body);
      expect(res.json).toHaveBeenCalledWith({ message: "User updated successfully" });
    });

    test("should handle error when updating user", async () => {
      // Mocked request and response objects
      const req = {
        params: { id: 1 },
        body: {
          /* updated user data */
        },
      };
      const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };

      // Mocking updateUser function of userModel to throw an error
      const errorMessage = "Mock error message";
      userModel.updateUser = jest.fn().mockRejectedValueOnce(new Error(errorMessage));

      // Spy on console.error
      const consoleErrorSpy = jest.spyOn(console, "error").mockImplementation(() => {});

      // Calling the updateUser function
      await updateUser(req, res);

      // Assertions
      expect(userModel.updateUser).toHaveBeenCalledWith(req.params.id, req.body);
      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({ error: "Internal server error" });
      expect(consoleErrorSpy).toHaveBeenCalled(); // Check if console.error was called

      // Restoring console.error to its original implementation
      consoleErrorSpy.mockRestore();
    });
  });

  describe("deleteUser", () => {
    test("should delete user successfully", async () => {
      // Mocked request and response objects
      const req = { params: { id: 1 } };
      const res = { json: jest.fn(), status: jest.fn().mockReturnThis() };

      // Mocking deleteUser function of userModel to indicate successful deletion
      userModel.deleteUser = jest.fn().mockResolvedValueOnce();

      // Calling the deleteUser function
      await deleteUser(req, res);

      // Assertions
      expect(userModel.deleteUser).toHaveBeenCalledWith(req.params.id);
      expect(res.json).toHaveBeenCalledWith({ message: "User deleted successfully" });
    });

    test("should handle error when deleting user", async () => {
      // Mocked request and response objects
      const req = { params: { id: 1 } };
      const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };

      // Mocking deleteUser function of userModel to throw an error
      const errorMessage = "Mock error message";
      userModel.deleteUser = jest.fn().mockRejectedValueOnce(new Error(errorMessage));

      // Spy on console.error
      const consoleErrorSpy = jest.spyOn(console, "error").mockImplementation(() => {});

      // Calling the deleteUser function
      await deleteUser(req, res);

      // Assertions
      expect(userModel.deleteUser).toHaveBeenCalledWith(req.params.id);
      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({ error: "Internal server error" });
      expect(consoleErrorSpy).toHaveBeenCalled(); // Check if console.error was called

      // Restoring console.error to its original implementation
      consoleErrorSpy.mockRestore();
    });
  });

  describe("updateBotanistStatus", () => {
    test("should update botanist status successfully", async () => {
      // Mocked request and response objects
      const req = {
        params: { userId: 1 },
        body: { siret: "123456789", companyName: "Test Company", companyDate: "2024-04-07" },
      };
      const res = { json: jest.fn() };

      // Mocking updateBotanistStatus function of userModel to indicate successful update
      userModel.updateBotanistStatus = jest.fn().mockResolvedValueOnce({
        /* mock result */
      });

      // Calling the updateBotanistStatus function
      await updateBotanistStatus(req, res);

      // Assertions
      expect(userModel.updateBotanistStatus).toHaveBeenCalledWith(
        req.params.userId,
        req.body.siret,
        req.body.companyName,
        req.body.companyDate
      );
      expect(res.json).toHaveBeenCalledWith({
        /* mock result */
      });
    });

    test("should handle error when updating botanist status", async () => {
      // Mocked request and response objects
      const req = {
        params: { userId: 1 },
        body: { siret: "123456789", companyName: "Test Company", companyDate: "2024-04-07" },
      };
      const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };

      // Mocking updateBotanistStatus function of userModel to throw an error
      const errorMessage = "Mock error message";
      userModel.updateBotanistStatus = jest.fn().mockRejectedValueOnce(new Error(errorMessage));

      // Spy on console.error
      const consoleErrorSpy = jest.spyOn(console, "error").mockImplementation(() => {});

      // Calling the updateBotanistStatus function
      await updateBotanistStatus(req, res);

      // Assertions
      expect(userModel.updateBotanistStatus).toHaveBeenCalledWith(
        req.params.userId,
        req.body.siret,
        req.body.companyName,
        req.body.companyDate
      );
      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({ error: "Internal server error" });
      expect(consoleErrorSpy).toHaveBeenCalled(); // Check if console.error was called

      // Restoring console.error to its original implementation
      consoleErrorSpy.mockRestore();
    });

    test("should handle missing SIRET when updating botanist status", async () => {
      // Mocked request and response objects
      const req = { params: { userId: 1 }, body: { companyName: "Test Company", companyDate: "2024-04-07" } };
      const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };

      // Calling the updateBotanistStatus function
      await updateBotanistStatus(req, res);

      // Assertions
      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({ error: "SIRET is required" });
    });
  });
});
