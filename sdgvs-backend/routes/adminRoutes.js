const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    getAdminByVillageId
} = require('../controllers/adminController');

router.get('/village/:villageId', auth, getAdminByVillageId);

module.exports = router;