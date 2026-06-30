const utilityService = require('../services/utilityService');

exports.createOrUpdateSetting = async (req, res) => {
    try {
        const { key, value, description } = req.body;

        if (!key || !value) {
            return res.status(400).json({ message: "key and value are required" });
        }

        const setting = await utilityService.upsertSetting({ key, value, description });

        res.status(201).json({
            message: "Setting updated successfully",
            data: setting
        });
    } catch (error) {
        res.status(500).json({ message: "Error updating setting", error: error.message });
    }
};

exports.getAllSettings = async (req, res) => {
    try {
        const settings = await utilityService.getAllSettings();
        res.json(settings);
    } catch (error) {
        res.status(500).json({ message: "Error fetching settings", error: error.message });
    }
};

exports.getSettingByKey = async (req, res) => {
    try {
        const setting = await utilityService.getSettingByKey(req.params.key);
        if (!setting) return res.status(404).json({ message: "Setting not found" });
        res.json(setting);
    } catch (error) {
        res.status(500).json({ message: "Error fetching setting", error: error.message });
    }
};

exports.deleteSetting = async (req, res) => {
    try {
        const isDeleted = await utilityService.deleteSetting(req.params.key);
        if (!isDeleted) return res.status(404).json({ message: "Setting not found" });
        res.json({ message: "Setting deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting setting", error: error.message });
    }
};