const villageService = require('../services/villageService');

// CREATE
exports.createVillage = async (req, res) => {
    try {
        const { name, taluka, district } = req.body;
        if (!name || !taluka || !district) {
            return res.status(400).json({
                message: "Name, taluka, and district are required fields"
            });
        }
        const newVillage = await villageService.createVillage(req.body);
        res.status(201).json({
            message: "Village created successfully",
            data: newVillage
        });
    } catch (error) {
        res.status(500).json({ message: "Error creating village", error: error.message });
    }
};

// READ ALL
exports.getAllVillages = async (req, res) => {
    try {
        const villages = await villageService.getAllVillages();
        res.json(villages);
    } catch (error) {
        res.status(500).json({ message: "Error fetching villages", error: error.message });
    }
};

// READ ONE
exports.getVillageById = async (req, res) => {
    try {
        const village = await villageService.getVillageById(req.params.id);
        if (!village) {
            return res.status(404).json({ message: "Village not found" });
        }
        res.json(village);
    } catch (error) {
        res.status(500).json({ message: "Error fetching village", error: error.message });
    }
};

// READ BY NAME
exports.getVillageByName = async (req, res) => {
    try {
        const { name, taluka } = req.query;
        if (!name) {
            return res.status(400).json({ message: "Village name is required" });
        }

        let village;
        if (taluka) {
            village = await villageService.getVillageByNameAndTaluka(name, taluka);
        } else {
            village = await villageService.getVillageByName(name);
        }

        if (!village) {
            return res.status(404).json({ message: "Village not found" });
        }
        res.json(village);
    } catch (error) {
        res.status(500).json({ message: "Error fetching village", error: error.message });
    }
};

// UPDATE
exports.updateVillage = async (req, res) => {
    try {
        const { status } = req.body;
        if (status && !["active", "inactive"].includes(status)) {
            return res.status(400).json({ message: "Invalid status value. Must be 'active' or 'inactive'." });
        }
        const village = await villageService.updateVillage(req.params.id, req.body);
        if (!village) {
            return res.status(404).json({ message: "Village not found" });
        }
        res.json({
            message: "Village updated successfully",
            data: village
        });
    } catch (error) {
        res.status(500).json({ message: "Error updating village", error: error.message });
    }
};

// DELETE
exports.deleteVillage = async (req, res) => {
    try {
        const isDeleted = await villageService.deleteVillage(req.params.id);
        if (!isDeleted) {
            return res.status(404).json({ message: "Village not found" });
        }
        res.json({ message: "Village deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting village", error: error.message });
    }
};