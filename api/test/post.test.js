const postModel = require("../models/post");
const {
  getPosts,
  getPostById,
  getNonProgressPosts,
  getNonProgressPostsbyCity,
  createPost,
  getCommentsByPost,
  createComment,
} = require("../controllers/post");

jest.mock("../models/post");

describe("Post Controller", () => {
  describe("getPosts", () => {
    test("should return all posts successfully", async () => {
      // Mocked request and response objects
      const req = {};
      const res = { json: jest.fn() };

      // Mocking getProgressPosts function of postModel to return mock posts
      const mockPosts = [{ title: "Post 1" }, { title: "Post 2" }];
      postModel.getProgressPosts = jest.fn().mockResolvedValueOnce(mockPosts);

      // Calling the getPosts function
      await getPosts(req, res);

      // Assertions
      expect(postModel.getProgressPosts).toHaveBeenCalled();
      expect(res.json).toHaveBeenCalledWith(mockPosts);
    });
  });

  describe("getPostById", () => {
    test("should return the post with the given ID if it exists", async () => {
      // Mocked request and response objects
      const req = { params: { id: "123" } };
      const res = { json: jest.fn(), status: jest.fn().mockReturnThis() };

      // Mocking getPostById function of postModel to return a mock post
      const mockPost = { id: "123", title: "Mock Post" };
      postModel.getPostById = jest.fn().mockResolvedValueOnce(mockPost);

      // Calling the getPostById function
      await getPostById(req, res);

      // Assertions
      expect(postModel.getPostById).toHaveBeenCalledWith(req.params.id);
      expect(res.json).toHaveBeenCalledWith(mockPost);
    });

    test("should return 404 if the post with the given ID does not exist", async () => {
      // Mocked request and response objects
      const req = { params: { id: "456" } };
      const res = { json: jest.fn(), status: jest.fn().mockReturnThis() };

      // Mocking getPostById function of postModel to return null (post not found)
      postModel.getPostById = jest.fn().mockResolvedValueOnce(null);

      // Calling the getPostById function
      await getPostById(req, res);

      // Assertions
      expect(postModel.getPostById).toHaveBeenCalledWith(req.params.id);
      expect(res.status).toHaveBeenCalledWith(404);
      expect(res.json).toHaveBeenCalledWith({ error: "Post not found" });
    });
  });
});
