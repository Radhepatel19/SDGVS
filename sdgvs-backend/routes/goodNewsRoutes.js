const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    createNews,
    getAllNews,
    getNewsByCategory,
    getNewsById,
    likeNews,
    deleteNews
} = require('../controllers/goodNewsController');

router.post('/', auth, createNews);
router.get('/', auth, getAllNews);
router.get('/category/:category', auth, getNewsByCategory);
router.get('/:id', auth, getNewsById);
router.put('/:id/like', auth, likeNews);
router.delete('/:id', auth, deleteNews);

module.exports = router;