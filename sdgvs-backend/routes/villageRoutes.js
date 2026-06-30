const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    createVillage,
    getAllVillages,
    getVillageById,
    getVillageByName,
    updateVillage,
    deleteVillage
} = require('../controllers/villageController');

router.post('/', auth, createVillage);
router.get('/', auth, getAllVillages);
router.get('/search/by-name', auth, getVillageByName);
router.get('/:id', auth, getVillageById);
router.put('/:id', auth, updateVillage);
router.delete('/:id', auth, deleteVillage);

module.exports = router;