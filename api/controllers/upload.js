const multer = require('multer');
const assetModel = require('../models/asset');
const knex = require('../db/knex');
const path = require('path');

function getImage(req, res) {
    try {
        const imageId = req.params.imageId;
        const imagePath = path.join(__dirname, '..', 'uploads', imageId)
        res.sendFile(imagePath);
    } catch (error) {
        console.error("Error fetching image:", error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, './uploads/');
    },
    filename: function (req, file, cb) {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, uniqueSuffix + '.' + file.originalname.split('.').pop());
    }
});

const upload = multer({ 
    storage: storage, 
}).single('image');

async function uploadImage(req, res) {
    try {
        upload(req, res, async function (err) {
            if (err instanceof multer.MulterError) {
                return res.status(400).json({ error: 'Multer error: ' + err.message });
            } else if (err) {
                return res.status(400).json({ error: err.message });
            }

            const file = req.file;
            const postId = req.body.post_id;

            if (!file) {
                return res.status(400).json({ error: 'No image uploaded.' });
            }

            const assetId = await assetModel.createAsset({ name: file.filename });
            await knex('post_has_asset').insert({ post_id: postId, asset_id: assetId });

            res.status(201).json({ message: 'Image uploaded successfully', assetId });
        });
    } catch (error) {
        console.error("Error uploading image:", error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

module.exports = {
    uploadImage,
    getImage
};
