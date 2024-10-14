const express = require('express');
const router = express.Router();
const postController = require('../controllers/post');
const auth = require('../controllers/auth');

router.use(auth.authenticateToken);

router.get('/', postController.getPosts);
router.post('/', postController.createPost);
router.get('/non-progress', postController.getNonProgressPosts);
router.get('/non-progress/:city', postController.getNonProgressPostsbyCity);
router.get('/comments/:postId', postController.getCommentsByPost);
router.get('/:id', postController.getPostById);
router.post('/comments', postController.createComment);

module.exports = router;
