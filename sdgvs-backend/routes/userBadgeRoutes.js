const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    awardBadge,
    getUserBadges,
    getAllBadges,
    deleteBadge
} = require('../controllers/userBadgeController');

router.get('/', auth, getAllBadges);
router.post('/', auth, awardBadge);
router.get('/user/:userId', auth, getUserBadges);
router.delete('/:id', auth, deleteBadge);

module.exports = router;