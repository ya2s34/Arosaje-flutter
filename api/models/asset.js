const knex = require("../db/knex");

async function createAsset(assetData) {
    try {
        const assetId = await knex('asset').insert(assetData);
        return assetId[0];
    } catch (error) {
        throw error;
    }
}

module.exports = {
    createAsset
};
