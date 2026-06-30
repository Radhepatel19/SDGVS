const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const multer = require('multer');

const upload = multer({ storage: multer.memoryStorage() });


const {
    createUser,
    getAllUsers,
    getUserById,
    updateUser,
    deleteUser,
    verifyUser
} = require('../controllers/userController');

router.post('/', auth, createUser);
router.get('/', auth, getAllUsers);
router.get('/:id', auth, getUserById);
router.put('/:id', auth, upload.fields([{ name: 'profile_image', maxCount: 1 }]), updateUser);
router.post('/verify/:id', auth, verifyUser); // Admin action
router.delete('/:id', auth, deleteUser);

module.exports = router;