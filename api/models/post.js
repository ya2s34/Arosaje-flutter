const knex = require("../db/knex");

async function getProgressPosts() {
  try {
    const posts = await knex
      .select(
        "post.id as post_id",
        "post.title",
        "post.date",
        "post.location",
        "post.description",
        "post.category",
        "user.first_name",
        "user.last_name",
        "asset.name as image_name",
        "post.user_id",
        "post.linked_user_id",
        "linked_user.first_name as linked_first_name",
        "linked_user.last_name as linked_last_name"
      )
      .from("post")
      .leftJoin("user", "post.user_id", "user.id")
      .leftJoin("post_has_asset", "post.id", "post_has_asset.post_id")
      .leftJoin("asset", "post_has_asset.asset_id", "asset.id")
      .leftJoin("user as linked_user", "post.linked_user_id", "linked_user.id")
      .where("post.isProgress_post", 1);

    const formattedPosts = {};

    for (const post of posts) {
      const postId = post.post_id;
      if (!formattedPosts[postId]) {
        formattedPosts[postId] = {
          post_id: postId,
          date: post.date,
          description: post.description,
          user_name: `${post.first_name} ${post.last_name}`,
          user_id: post.user_id,
          linked_user_id: post.linked_user_id,
          linked_username: `${post.linked_first_name} ${post.linked_last_name}`,
          images: [],
        };
      }
      if (post.image_name) {
        formattedPosts[postId].images.push(post.image_name);
      }
    }

    return Object.values(formattedPosts);
  } catch (error) {
    throw error;
  }
}


async function getNonProgressPosts() {
  try {
    const posts = await knex
      .select(
        "post.title",
        "post.date",
        "post.location",
        "post.description",
        "post.category",
        "user.first_name",
        "user.last_name",
        "asset.name as image_name"
      )
      .from("post")
      .leftJoin("user", "post.user_id", "user.id")
      .leftJoin("post_has_asset", "post.id", "post_has_asset.post_id")
      .leftJoin("asset", "post_has_asset.asset_id", "asset.id")
      .where("post.isProgress_post", 0);

    const formattedPosts = posts.map((post) => {
      return {
        title: post.title,
        date: post.date,
        location: post.location,
        description: post.description,
        category: post.category,
        user_name: `${post.first_name} ${post.last_name}`,
        image_name: post.image_name,
      };
    });

    return formattedPosts;
  } catch (error) {
    throw error;
  }
}

async function getNonProgressPostsbyCity(city) {
  try {
    const posts = await knex
      .select(
        "post.title",
        "post.date",
        "post.location",
        "post.description",
        "post.category",
        "user.first_name",
        "user.last_name",
        "asset.name as image_name"
      )
      .from("post")
      .leftJoin("user", "post.user_id", "user.id")
      .leftJoin("post_has_asset", "post.id", "post_has_asset.post_id")
      .leftJoin("asset", "post_has_asset.asset_id", "asset.id")
      .where({
        "post.isProgress_post": 0,
        "post.location": city,
      });

    const formattedPosts = posts.map((post) => {
      return {
        title: post.title,
        date: post.date,
        location: post.location,
        description: post.description,
        category: post.category,
        user_name: `${post.first_name} ${post.last_name}`,
        image_name: post.image_name,
      };
    });

    return formattedPosts;
  } catch (error) {
    throw error;
  }
}

async function createPost(postData) {
  try {
    const postId = await knex("post").insert(postData);
    return postId[0];
  } catch (error) {
    throw error;
  }
}

async function getCommentsByPost(postId) {
  try {
    const comments = await knex("post_has_commentary")
      .join("commentary", "post_has_commentary.commentary_id", "=", "commentary.id")
      .join("user", "commentary.user_id", "=", "user.id")
      .where("post_has_commentary.post_id", postId)
      .select("commentary.id", "commentary.commentary", knex.raw("CONCAT(user.first_name, ' ', user.last_name) AS username"));

    return comments;
  } catch (error) {
    throw error;
  }
}

async function getPostById(postId) {
  try {
    const post = await knex("post").where("id", postId).first();

    return post;
  } catch (error) {
    throw error;
  }
}

async function postComment(postId, userId, commentary) {
  try {
    const insertedComment = await knex('commentary').insert({
      commentary: commentary,
      date: new Date().toISOString().slice(0, 19).replace('T', ' '), 
      user_id: userId
    });
    
    await knex('post_has_commentary').insert({
      post_id: postId,
      commentary_id: insertedComment[0]
    });

    return true;
  } catch (error) {
    console.error("Error inserting comment:", error);
    throw error; 
  }
}

module.exports = {
  getProgressPosts,
  getNonProgressPosts,
  getNonProgressPostsbyCity,
  createPost,
  getCommentsByPost,
  getPostById,
  postComment,
};
