const express = require('express');
const router = express.Router();
const loginScreenController = require('../controllers/loginScreenController');

router.post('/admin', loginScreenController.adminLogin);
router.post('/user/generate-otp', loginScreenController.userGenerateOTP);
router.post('/user/verify-otp', loginScreenController.userVerifyOTP);

module.exports = router;
