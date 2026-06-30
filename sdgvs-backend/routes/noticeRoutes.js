const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    createNotice,
    getAllNotices,
    getNoticeById,
    getNoticesByType,
    getHighPriorityNotices,
    getNoticesByAdmin,
    deleteNotice
} = require('../controllers/noticeController');

router.post('/', auth, createNotice);
router.get('/', auth, getAllNotices);
router.get('/type/:type', auth, getNoticesByType);
router.get('/high-priority', auth, getHighPriorityNotices);
router.get('/admin/:adminId', auth, getNoticesByAdmin);
router.get('/:id', auth, getNoticeById);
router.delete('/:id', auth, deleteNotice);

module.exports = router;