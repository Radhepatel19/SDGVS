const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    createCrop,
    getAllCrops,
    getCropsBySeason,
    getCropsByName,
    getActiveCrops,
    updateCrop,
    deleteCrop
} = require('../controllers/cropCalendarController');

router.post('/', auth, createCrop);
router.get('/', auth, getAllCrops);
router.get('/season/:season', auth, getCropsBySeason);
router.get('/crop/:name', auth, getCropsByName);
router.get('/active/current', auth, getActiveCrops);
router.put('/:id', auth, updateCrop);
router.delete('/:id', auth, deleteCrop);

module.exports = router;