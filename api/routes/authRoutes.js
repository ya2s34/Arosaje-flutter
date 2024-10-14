const express = require('express');
const router = express.Router();
const authControllers = require('../controllers/auth');
const userControllers = require('../controllers/user');
const bcrypt = require('bcrypt');

router.post('/login', authControllers.login);
router.post('/signup', authControllers.signup);

module.exports = router;
