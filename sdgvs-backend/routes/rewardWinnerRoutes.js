const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    createWinner,
    getAllWinners,
    getWinnerById,
    getWinnersByMonthYear,
    getWinnersByCategory,
    getWinnersByVillage,
    updateWinner,
    deleteWinner
} = require('../controllers/rewardWinnerController');

router.post('/', auth, createWinner);
router.get('/', auth, getAllWinners);
router.get('/month/:month/:year', auth, getWinnersByMonthYear);
router.get('/category/:category', auth, getWinnersByCategory);
router.get('/village/:village', auth, getWinnersByVillage);
router.get('/:id', auth, getWinnerById);
router.put('/:id', auth, updateWinner);
router.delete('/:id', auth, deleteWinner);

module.exports = router;