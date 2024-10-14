const userModel = require("../models/user");

async function createUser(req, res) {
    try {
        const user = req.body;
        await userModel.createUser(user);
        res.status(201).json({ message: 'User created successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

async function getAllUsers(req, res) {
    try {
        const users = await userModel.getAllUsers();
        res.json(users);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

async function getUserById(req, res) {
    const { id } = req.params;
    try {
        const user = await userModel.getUserById(id);
        if (user) {
            res.json(user);
        } else {
            res.status(404).json({ error: 'User not found' });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

async function updateUser(req, res) {
    const { id } = req.params;
    const updatedUser = req.body;
    try {
        await userModel.updateUser(id, updatedUser);
        res.json({ message: 'User updated successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

async function deleteUser(req, res) {
    const { id } = req.params;
    try {
        await userModel.deleteUser(id);
        res.json({ message: 'User deleted successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

async function updateBotanistStatus(req, res) {
    const userId = req.params.userId;
    const { siret, companyName, companyDate } = req.body;

    try {
        if (!siret) {
            return res.status(400).json({ error: 'SIRET is required' });
        }

        const result = await userModel.updateBotanistStatus(userId, siret, companyName, companyDate);
        res.json(result);
    } catch (error) {
        console.error("Error updating botanist status:", error);
        res.status(500).json({ error: 'Internal server error' });
    }
}
async function getAllUsernames(req, res) {
    try {
      const usernames = await userModel.getAllUsernames();
  
      res.status(200).json(usernames);
    } catch (error) {
      console.error('Error in getAllUsernames controller:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
module.exports = {
    createUser,
    getAllUsers,
    getUserById,
    updateUser,
    deleteUser,
    updateBotanistStatus,
    getAllUsernames
};
