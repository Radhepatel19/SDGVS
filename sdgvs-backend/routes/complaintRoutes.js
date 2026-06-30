const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const multer = require('multer');

const upload = multer({ storage: multer.memoryStorage() });

const {
    createComplaint,
    getAllComplaints,
    getComplaintById,
    updateComplaint,
    deleteComplaint
} = require('../controllers/complaintController');

router.post('/', auth, upload.fields([{ name: 'imagePath', maxCount: 1 }, { name: 'voicePath', maxCount: 1 }]), createComplaint);
router.get('/', auth, getAllComplaints);
router.get('/:id', auth, getComplaintById);
router.put('/:id', auth, updateComplaint);
router.delete('/:id', auth, deleteComplaint);

module.exports = router;