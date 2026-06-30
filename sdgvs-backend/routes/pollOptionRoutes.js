const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    addOption,
    getOptionsByPoll,
    voteOption
} = require('../controllers/pollOptionController');

router.post('/', auth, addOption);
router.get('/poll/:pollId', auth, getOptionsByPoll);
router.post('/vote/:optionId', auth, voteOption);

module.exports = router;