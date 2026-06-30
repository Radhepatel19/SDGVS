const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    createResource,
    getAllResources,
    getResourceById,
    updateResource,
    deleteResource
} = require('../controllers/agriResourceController');

router.post('/', auth, createResource);
router.get('/', auth, getAllResources);
router.get('/:id', auth, getResourceById);
router.put('/:id', auth, updateResource);
router.delete('/:id', auth, deleteResource);

module.exports = router;