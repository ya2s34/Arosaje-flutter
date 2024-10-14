const express = require('express');
const router = express.Router();
const userControllers = require('../controllers/user');
const auth = require('../controllers/auth');

router.use(auth.authenticateToken);
router.post('/', userControllers.createUser);
router.get('/', userControllers.getAllUsers);
router.get('/usernames', userControllers.getAllUsernames);
router.get('/:id', userControllers.getUserById);
router.put('/:id', userControllers.updateUser);
router.delete('/:id', userControllers.deleteUser);
router.put('/botanist/:userId', userControllers.updateBotanistStatus);

module.exports = router;
