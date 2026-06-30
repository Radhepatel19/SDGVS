const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    createAlert,
    getAllAlerts,
    getActiveAlerts,
    getExpiredAlerts,
    getAlertsByLevel,
    deleteAlert
} = require('../controllers/weatherAlertController');

router.post('/', auth, createAlert);
router.get('/', auth, getAllAlerts);
router.get('/active', auth, getActiveAlerts);
router.get('/expired', auth, getExpiredAlerts);
router.get('/level/:level', auth, getAlertsByLevel);
router.delete('/:id', auth, deleteAlert);

module.exports = router;