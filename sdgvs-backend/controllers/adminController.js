const adminService = require('../services/adminService');

// GET ADMIN BY VILLAGE ID
exports.getAdminByVillageId = async (req, res) => {
    try {
        const admin = await adminService.getAdminByVillageId(req.params.villageId);
        if (!admin) {
            return res.status(404).json({ message: "Admin not found for this village" });
        }
        res.json(admin);
    } catch (error) {
        res.status(500).json({ message: "Error fetching admin", error: error.message });
    }
};