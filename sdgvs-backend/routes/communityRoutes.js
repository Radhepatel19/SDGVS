const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const communityController = require('../controllers/communityController');

// All endpoints prefixed with /api/community

router.get('/good-news', auth, communityController.getGoodNews);
router.get('/notices', auth, communityController.getNotices);
router.get('/rewards', auth, communityController.getRewards);

module.exports = router;
