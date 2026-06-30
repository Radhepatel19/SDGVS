const express = require('express');
const router = express.Router();
const loginScreenController = require('../controllers/loginScreenController');
const auth = require('../middleware/auth');

// Standardizing auth routes for Flutter integration
router.post('/login', loginScreenController.adminLogin);
router.post('/user-verify', loginScreenController.userVerifyOTP);
router.post('/generate-otp', loginScreenController.userGenerateOTP);
router.post('/check-mobile', loginScreenController.checkMobile);
router.post('/complete-profile', loginScreenController.completeProfile);
router.get('/status', auth, loginScreenController.getUserStatus);
module.exports = router;
