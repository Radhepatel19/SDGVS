const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    createOrUpdateSetting,
    getAllSettings,
    getSettingByKey,
    deleteSetting
} = require('../controllers/appSettingsController');

router.get('/', auth, getAllSettings);
router.get('/:key', auth, getSettingByKey);
router.post('/', auth, createOrUpdateSetting);
router.delete('/:key', auth, deleteSetting);

module.exports = router;