const knex = require("../db/knex");
const bcrypt = require("bcrypt");

async function loginUser(email) {
  try {
    const user = await knex("user").where({ email }).first();
    return user;
  } catch (error) {
    throw error;
  }
}

async function signUpUser(user) {
  try {
    const { last_name, first_name, email, phone, address, zip_code, city, password } = user;

    await knex("user").insert({
      last_name,
      first_name,
      email,
      phone,
      address,
      zip_code,
      city,
      password: password,
    });

    return { message: "User created successfully" };
  } catch (error) {
    throw error;
  }
}

async function getAllUsers() {
  try {
    const users = await knex("user").select("*");
    return users;
  } catch (error) {
    throw error;
  }
}

async function getAllUsernames() {
  try {
    const users = await knex("user").select("*");
    const formattedUsers = users.map((user) => {
      return {
        userId: user.id,
        userName: `${user.first_name} ${user.last_name}`,
      };
    });
    return formattedUsers;
  } catch (error) {
    throw error;
  }
}

async function getUserById(id) {
  try {
    const user = await knex("user")
      .select("user.id", "user.first_name", "user.last_name", "user.city", "user.bio")
      .where("user.id", id)
      .first();

    return user;
  } catch (error) {
    throw error;
  }
}

async function deleteUser(id) {
  try {
    await knex("user").where("id", id).del();
    return { message: "User deleted successfully" };
  } catch (error) {
    throw error;
  }
}

async function updateUser(id, userData) {
  try {
    if (userData.password) {
      const hashedPassword = await bcrypt.hash(userData.password, 10);
      userData.password = hashedPassword;
    }
    await knex("user").where("id", id).update(userData);
    return { message: "User updated successfully" };
  } catch (error) {
    throw error;
  }
}

async function updateBotanistStatus(userId, siret, companyName, companyDate) {
  try {
    const user = await knex("user").select("status_botaniste").where("id", userId).first();

    if (user && user.status_botaniste) {
      return { success: false, message: "Botanist status is already true" };
    }

    await knex("user").where("id", userId).update({
      status_botaniste: true,
      siret,
      companyName,
      companyDate,
    });

    return { success: true, message: "Botanist status updated successfully" };
  } catch (error) {
    throw error;
  }
}

module.exports = {
  loginUser,
  signUpUser,
  getAllUsers,
  getUserById,
  deleteUser,
  updateUser,
  updateBotanistStatus,
  getAllUsernames,
};
