const express = require("express");
const router = express.Router();
const uploadController = require("../controllers/upload");
const auth = require("../controllers/auth");

router.use(auth.authenticateToken);

router.post("/", uploadController.uploadImage);
router.get('/:imageId', uploadController.getImage);

module.exports = router;
