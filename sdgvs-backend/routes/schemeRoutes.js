const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    createScheme,
    getAllSchemes,
    getSchemeById,
    getSchemesByCategory,
    updateScheme,
    deleteScheme,
    getUniqueCategories,
    applyScheme
} = require('../controllers/schemeController');

router.post('/', auth, createScheme);
router.get('/', auth, getAllSchemes);
router.get('/categories', auth, getUniqueCategories);
router.get('/category/:category', auth, getSchemesByCategory);
router.get('/:id', auth, getSchemeById);
router.put('/:id', auth, updateScheme);
router.delete('/:id', auth, deleteScheme);
router.post('/apply', auth, applyScheme);

module.exports = router;