const postModel = require("../models/post");

async function getPosts(req, res) {
    try {
        const posts = await postModel.getProgressPosts();
        res.json(posts);
    } catch (error) {
        console.error("Error fetching posts:", error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

async function getPostById(req, res) {
    try {
        const postId = req.params.id;

        const post = await postModel.getPostById(postId);

        if (!post) {
            return res.status(404).json({ error: 'Post not found' });
        }

        res.status(200).json(post);
    } catch (error) {
        console.error("Error fetching post:", error);
        res.status(500).json({ error: 'Internal server error' });
    }
}


async function getNonProgressPosts(req, res) {
    try {
        const nonProgressPosts = await postModel.getNonProgressPosts();
        res.json(nonProgressPosts);
    } catch (error) {
        console.error("Error fetching non-progress posts:", error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

async function getNonProgressPostsbyCity(req, res) {
    try {
        const city = req.params.city;
        const nonProgressPosts = await postModel.getNonProgressPostsbyCity(city);
        res.json(nonProgressPosts);
    } catch (error) {
        console.error("Error fetching non-progress posts:", error);
        res.status(500).json({ error: 'Internal server error' });
    }
}


async function createPost(req, res) {
    try {
        const postData = req.body;
        if (!postData || !postData.date || !postData.user_id) {
            return res.status(400).json({ error: "Incomplete post data" });
        }

        const postId = await postModel.createPost(postData);

        res.status(201).json({ postId, message: 'Post created successfully' });
    } catch (error) {
        console.error("Error creating post:", error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

async function getCommentsByPost(req, res) {
    try {
        const postId = req.params.postId;
        const comments = await postModel.getCommentsByPost(postId);
        res.json({ comments });
    } catch (error) {
        console.error("Error fetching comments for post:", error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

async function createComment(req, res) {
    try {
        const { postId, userId, commentary } = req.body;

        if (!postId || !userId || !commentary) {
            return res.status(400).json({ error: "Incomplete comment data" });
        }

        await postModel.postComment(postId, userId, commentary);

        res.status(201).json({ success: true, message: 'Comment created successfully' });
    } catch (error) {
        console.error("Error creating comment:", error);
        res.status(500).json({ error: 'Internal server error' });
    }
}


module.exports = {
    getPosts,
    getNonProgressPosts,
    getNonProgressPostsbyCity,
    createPost,
    getCommentsByPost,
    getPostById,
    createComment
};
