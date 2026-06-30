const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    votePoll,
    getVotesByPoll
} = require('../controllers/userPollVoteController');

router.post('/', auth, votePoll);
router.get('/poll/:pollId', auth, getVotesByPoll);

module.exports = router;