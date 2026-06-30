const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const authService = require('../services/authService');

const otpStore = {};

// ==============================
// ADMIN LOGIN
// ==============================
exports.adminLogin = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ message: "Email and password are required" });
        }

        const admin = await authService.getAdminByEmail(email);
        if (!admin) {
            return res.status(401).json({ message: "Invalid email or password" });
        }

        const isMatch = await bcrypt.compare(password, admin.password_hash);
        if (!isMatch) {
            return res.status(401).json({ message: "Invalid email or password" });
        }

        if (admin.status === 'inactive' || admin.status === 'suspended') {
            return res.status(403).json({ message: "Admin account is inactive or suspended" });
        }

        await authService.updateAdminStatus(admin.id, 'online', new Date());

        const token = jwt.sign({ id: admin.id, role: admin.role }, process.env.JWT_SECRET || 'secret', { expiresIn: '1d' });

        res.status(200).json({
            message: "Admin logged in successfully",
            data: {
                id: admin.id,
                name: admin.name,
                email: admin.email,
                role: admin.role,
                village_id: admin.village_id,
                is_first_login: admin.is_first_login
            },
            token
        });

    } catch (error) {
        console.error("Admin login error:", error);
        res.status(500).json({ message: "Internal server error during login", error: error.message });
    }
};

// ==============================
// USER CHECK MOBILE
// ==============================
exports.checkMobile = async (req, res) => {
    try {
        const { mobile } = req.body;

        if (!mobile) {
            return res.status(400).json({ message: "Mobile number is required" });
        }

        const user = await authService.getUserByMobile(mobile);

        res.status(200).json({
            message: "Check mobile successful",
            exists: !!user,
            is_registered: user ? user.is_registered : false
        });

    } catch (error) {
        console.error("Check mobile error:", error);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

// ==============================
// USER GENERATE OTP (Login Step 1)
// ==============================
exports.userGenerateOTP = async (req, res) => {
    try {
        const { mobile } = req.body;

        if (!mobile) {
            return res.status(400).json({ message: "Mobile number is required" });
        }

        let user = await authService.getUserByMobile(mobile);

        if (user && (user.status === 'inactive' || user.status === 'suspended')) {
            return res.status(403).json({ message: "User account is inactive or suspended" });
        }

        const otp = Math.floor(100000 + Math.random() * 900000).toString();

        otpStore[mobile] = otp;

        console.log(`\n=========================================`);
        console.log(`🔑 OTP GENERATED FOR ${mobile}: ${otp} `);
        console.log(`=========================================\n`);

        res.status(200).json({
            message: "OTP generated successfully. Please check the terminal."
        });

    } catch (error) {
        console.error("User generate OTP error:", error);
        res.status(500).json({ message: "Internal server error during OTP generation", error: error.message });
    }
};

// ==============================
// USER VERIFY OTP (Login Step 2)
// ==============================
exports.userVerifyOTP = async (req, res) => {
    try {
        const { mobile, otp } = req.body;

        if (!mobile || !otp) {
            return res.status(400).json({ message: "Mobile number and OTP are required" });
        }

        if (otpStore[mobile] !== otp) {
            return res.status(401).json({ message: "Invalid OTP" });
        }

        let user = await authService.getUserByMobile(mobile);

        if (!user) {
            const userService = require('../services/userService');
            user = await userService.createUser({
                mobile,
                is_registered: false,
                is_verified: false
            });
            console.log(`🆕 REGISTERED NEW USER AFTER OTP: ${mobile}`);
        }

        if (user.status === 'inactive' || user.status === 'suspended') {
            return res.status(403).json({ message: "User account is inactive or suspended" });
        }
        delete otpStore[mobile];


        await authService.updateUserLastLogin(user.id, new Date());
        const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET || 'secret', { expiresIn: '7d' });
        res.status(200).json({
            message: "OTP verified successfully. Login complete.",
            data: user,
            token
        });

    } catch (error) {
        console.error("User verify OTP error:", error);
        res.status(500).json({ message: "Internal server error during OTP verification", error: error.message });
    }
};


// ==============================
// COMPLETE PROFILE
// ==============================
exports.completeProfile = async (req, res) => {
    try {
        const { id, name, village_id, village_name, taluka, district, gender, dob, occupation, address, email } = req.body;

        if (!id || !name || !village_id) {
            return res.status(400).json({ message: "User ID, Name, and Village ID are required" });
        }

        const userService = require('../services/userService');

        if (email) {
            const existingUser = await userService.getUserByEmail(email);
            if (existingUser && existingUser.id !== id) {
                return res.status(400).json({ message: "Email already exists. Please use a different email." });
            }
        }

        const updatedUser = await userService.updateUser(id, {
            name,
            village_id,
            village_name,
            taluka,
            district,
            gender,
            dob,
            occupation,
            address,
            email,
            is_registered: true
        });

        res.status(200).json({
            message: "Profile completed successfully",
            data: updatedUser
        });

    } catch (error) {
        console.error("Complete profile error:", error);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

// ==============================
// GET USER STATUS
// ==============================
exports.getUserStatus = async (req, res) => {
    try {
        const userId = req.userData.id;
        const userService = require('../services/userService');
        const user = await userService.getUserById(userId);

        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        res.status(200).json({
            isVerified: !!user.is_verified,
            isRegistered: !!user.is_registered,
            status: user.status,
        });

    } catch (error) {
        console.error("Get user status error:", error);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};
