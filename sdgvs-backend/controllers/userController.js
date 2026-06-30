const userService = require('../services/userService');
const villageService = require('../services/villageService');
const cloudinaryService = require('../services/cloudinaryService');

// ==============================
// CREATE USER
// ==============================
exports.createUser = async (req, res) => {
    try {
        const {
            name,
            mobile,
            email,
            gender,
            dob,
            address,
            village_name,
            village_id,
            taluka,
            district,
            occupation,
            profile_image_url,
        } = req.body;

        // --- Validation ---
        if (!mobile) {
            return res.status(400).json({ message: 'Mobile is required' });
        }

        const existingMobile = await userService.getUserByMobile(mobile);
        if (existingMobile) {
            return res.status(400).json({ message: 'Mobile already registered' });
        }

        if (email) {
            const existingEmail = await userService.getUserByEmail(email);
            if (existingEmail) {
                return res.status(400).json({ message: 'Email already registered' });
            }
        }

        // --- Village Lookup/Creation Logic ---
        let finalVillageId = village_id;
        let finalVillageName = village_name;

        if (village_name && !village_id) {
            // Try to find existing village by name and taluka
            let existingVillage = null;
            if (taluka && district) {
                existingVillage = await villageService.getVillageByNameAndTaluka(village_name, taluka);
            } else {
                existingVillage = await villageService.getVillageByName(village_name);
            }

            if (existingVillage) {
                finalVillageId = existingVillage.id;
            } else if (taluka && district) {
                // Create new village if it doesn't exist
                const newVillage = await villageService.createVillage({
                    name: village_name,
                    taluka,
                    district,
                    population: null,
                    status: 'active'
                });
                finalVillageId = newVillage.id;
            }
        }

        if (finalVillageId) {
            const villageExists = await villageService.getVillageById(finalVillageId);
            if (!villageExists) {
                return res.status(400).json({ message: 'Invalid village_id — village not found' });
            }
        }

        // A user is considered "registered" if they have provided all core profile fields
        const is_registered = !!(name && gender && dob && occupation && (finalVillageId || finalVillageName));

        const newUser = await userService.createUser({
            name,
            mobile,
            email,
            gender,
            dob,
            address,
            village_name: finalVillageName,
            village_id: finalVillageId,
            taluka,
            district,
            occupation,
            profile_image_url,
            is_registered,
        });

        res.status(201).json({
            message: 'User created successfully',
            data: newUser,
        });
    } catch (error) {
        console.error('createUser error:', error);
        res.status(500).json({ message: 'Error creating user', error: error.message });
    }
};

// ==============================
// GET ALL USERS
// ==============================
exports.getAllUsers = async (req, res) => {
    try {
        const users = await userService.getAllUsers();
        res.json(users);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching users', error: error.message });
    }
};

// ==============================
// GET USER BY ID
// ==============================
exports.getUserById = async (req, res) => {
    try {
        const user = await userService.getUserById(req.params.id);
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
        res.json(user);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching user', error: error.message });
    }
};

// ==============================
// UPDATE USER PROFILE
// ==============================
exports.updateUser = async (req, res) => {
    try {
        const user = await userService.getUserById(req.params.id);
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        const {
            name,
            email,
            gender,
            dob,
            address,
            village_name,
            village_id,
            taluka,
            district,
            occupation,
            profile_image_url,
            status,
        } = req.body;

        let finalProfileImageUrl = profile_image_url;

        // Handle Profile Image Upload to Cloudinary
        if (req.files && req.files.profile_image && req.files.profile_image[0]) {
            try {
                const result = await cloudinaryService.uploadStream(
                    req.files.profile_image[0].buffer, 
                    'sdgvs_profile_images', 
                    'image'
                );
                finalProfileImageUrl = result.secure_url;
                console.log('✅ Profile image uploaded to Cloudinary:', finalProfileImageUrl);
            } catch (uploadError) {
                console.error('❌ Cloudinary upload error:', uploadError);
                // Continue with update even if image upload fails, or return error? 
                // Usually better to return error if user specifically tried to upload
                return res.status(500).json({ message: 'Error uploading profile image', error: uploadError.message });
            }
        }

        // Validate email uniqueness
        if (email) {
            const existingEmail = await userService.getUserByEmail(email);
            if (existingEmail && existingEmail.id !== user.id) {
                return res.status(400).json({ message: 'Email already in use by another account' });
            }
        }

        // Validate status enum
        const validStatuses = ['active', 'inactive', 'suspended'];
        if (status && !validStatuses.includes(status)) {
            return res.status(400).json({ message: `Invalid status. Must be one of: ${validStatuses.join(', ')}` });
        }

        // --- Village Lookup/Creation Logic ---
        let finalVillageId = village_id !== undefined ? village_id : user.village_id;
        let finalVillageName = village_name !== undefined ? village_name : user.village_name;

        if (village_name && !village_id) {
            // Try to find existing village by name and taluka
            let existingVillage = null;
            const updateTaluka = taluka || user.taluka;
            const updateDistrict = district || user.district;

            if (updateTaluka && updateDistrict) {
                existingVillage = await villageService.getVillageByNameAndTaluka(village_name, updateTaluka);
            } else {
                existingVillage = await villageService.getVillageByName(village_name);
            }

            if (existingVillage) {
                finalVillageId = existingVillage.id;
            } else if (updateTaluka && updateDistrict) {
                // Create new village if it doesn't exist
                const newVillage = await villageService.createVillage({
                    name: village_name,
                    taluka: updateTaluka,
                    district: updateDistrict,
                    population: null,
                    status: 'active'
                });
                finalVillageId = newVillage.id;
            }
        }

        if (finalVillageId) {
            const villageExists = await villageService.getVillageById(finalVillageId);
            if (!villageExists) {
                return res.status(400).json({ message: 'Invalid village_id — village not found' });
            }
        }

        // Determine if user is now fully registered
        const resolvedName        = name        ?? user.name;
        const resolvedGender      = gender      ?? user.gender;
        const resolvedDob         = dob         ?? user.dob;
        const resolvedOccupation  = occupation  ?? user.occupation;

        const is_registered = !!(
            resolvedName && resolvedGender && resolvedDob &&
            resolvedOccupation && (finalVillageId || finalVillageName)
        );

        const updatedUser = await userService.updateUser(user.id, {
            name,
            email,
            gender,
            dob,
            address,
            village_name: finalVillageName,
            village_id: finalVillageId,
            taluka,
            district,
            occupation,
            profile_image_url: finalProfileImageUrl,
            is_registered,
            status,
        });

        // Auto-initialize Impact Stats on first registration completion
        if (updatedUser.is_registered && !user.is_registered) {
            try {
                const rewardService = require('../services/rewardService');
                const stats = await rewardService.getImpactStats(user.id);
                if (!stats) {
                    await rewardService.updateImpactStats(user.id, {
                        complaints_resolved: 0,
                        schemes_applied: 0,
                        contribution_hours: 0,
                        community_impact_score: 0,
                    });
                }
            } catch (impactError) {
                console.warn('Impact stats init skipped:', impactError.message);
            }
        }

        res.json({
            message: 'User profile updated successfully',
            data: updatedUser,
        });
    } catch (error) {
        console.error('updateUser error:', error);
        res.status(500).json({ message: 'Error updating user', error: error.message });
    }
};

// ==============================
// VERIFY USER (Admin action)
// ==============================
exports.verifyUser = async (req, res) => {
    try {
        const user = await userService.getUserById(req.params.id);
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        const verifiedUser = await userService.verifyUser(user.id);
        res.json({
            message: 'User verified successfully',
            data: verifiedUser,
        });
    } catch (error) {
        res.status(500).json({ message: 'Error verifying user', error: error.message });
    }
};

// ==============================
// DELETE USER (Full cascade)
// ==============================
exports.deleteUser = async (req, res) => {
    try {
        const isDeleted = await userService.deleteUser(req.params.id);
        if (!isDeleted) {
            return res.status(404).json({ message: 'User not found' });
        }
        res.json({ message: 'User and all related data deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting user', error: error.message });
    }
};