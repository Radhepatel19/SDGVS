const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const multer = require('multer');

const upload = multer({ storage: multer.memoryStorage() });

const {
    uploadDocument,
    getAllDocuments,
    getDocumentsByUser,
    getDocumentById,
    deleteDocument
} = require('../controllers/userDocumentController');

router.post('/', auth, upload.single('file_path'), uploadDocument);
router.get('/', auth, getAllDocuments);
router.get('/user/:userId', auth, getDocumentsByUser);
router.get('/:id', auth, getDocumentById);
router.delete('/:id', auth, deleteDocument);

module.exports = router;