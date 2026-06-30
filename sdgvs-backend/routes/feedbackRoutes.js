const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    createFeedback,
    getAllFeedback,
    getFeedbackByComplaint,
    getFeedbackByUser,
    deleteFeedback
} = require('../controllers/feedbackController');

router.post('/', auth, createFeedback);
router.get('/', auth, getAllFeedback);
router.get('/complaint/:complaintId', auth, getFeedbackByComplaint);
router.get('/user/:userId', auth, getFeedbackByUser);
router.delete('/:id', auth, deleteFeedback);

module.exports = router;