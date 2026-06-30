const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    createService,
    getAllServices,
    getServiceById,
    getServicesByCategory,
    updateService,
    deleteService
} = require('../controllers/emergencyServiceController');

router.post('/', auth, createService);
router.get('/', auth, getAllServices);
router.get('/category/:category', auth, getServicesByCategory);
router.get('/:id', auth, getServiceById);
router.put('/:id', auth, updateService);
router.delete('/:id', auth, deleteService);

module.exports = router;