const express = require('express');
const router = express.Router();
const agriNoticeController = require('../controllers/agriNoticeController');
const auth = require('../middleware/auth');

router.post('/', auth, agriNoticeController.createNotice);
router.get('/', auth, agriNoticeController.getAllNotices);
router.get('/village/:villageId', auth, agriNoticeController.getNoticesByVillage);
router.delete('/:id', auth, agriNoticeController.deleteNotice);

module.exports = router;
