const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    initializeStats,
    getUserStats,
    updateStats,
    incrementStats,
    getLeaderboard
} = require('../controllers/userImpactController');

router.get('/leaderboard/top', auth, getLeaderboard);
router.post('/:userId', auth, initializeStats);
router.get('/:userId', auth, getUserStats);
router.put('/:userId', auth, updateStats);
router.patch('/:userId/increment', auth, incrementStats);
module.exports = router;