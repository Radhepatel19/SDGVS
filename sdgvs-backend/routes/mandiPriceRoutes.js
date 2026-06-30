const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    createPrice,
    getAllPrices,
    getPricesByCrop,
    getPricesByLocation,
    getLatestPrices,
    getPriceTrend,
    updatePrice,
    deletePrice
} = require('../controllers/mandiPriceController');

router.post('/', auth, createPrice);
router.get('/', auth, getAllPrices);
router.get('/latest', auth, getLatestPrices);
router.get('/crop/:name', auth, getPricesByCrop);
router.get('/location/:location', auth, getPricesByLocation);
router.get('/trend/:name', auth, getPriceTrend);
router.put('/:id', auth, updatePrice);
router.delete('/:id', auth, deletePrice);

module.exports = router;