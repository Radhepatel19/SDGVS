const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    createNotification,
    getNotifications,
    getUserNotifications,
    markAsRead,
    markAllAsRead,
    deleteNotification
} = require('../controllers/notificationController');

router.post('/', auth, createNotification);
router.get('/', auth, getNotifications); // Matches NotificationApi.getNotifications()
router.get('/user/:userId', auth, getUserNotifications);
router.post('/:id/read', auth, markAsRead); // Matches NotificationApi.markAsRead(id)
router.post('/read-all', auth, markAllAsRead); // Matches NotificationApi.markAllAsRead()
router.delete('/:id', auth, deleteNotification);

module.exports = router;