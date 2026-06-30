const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    createPoll,
    getAllPolls,
    getPollById,
    getActivePolls,
    getExpiredPolls,
    deletePoll
} = require('../controllers/pollController');

router.post('/', auth, createPoll);
router.get('/', auth, getAllPolls);
router.get('/active', auth, getActivePolls);
router.get('/expired', auth, getExpiredPolls);
router.get('/:id', auth, getPollById);
router.delete('/:id', auth, deletePoll);

module.exports = router;