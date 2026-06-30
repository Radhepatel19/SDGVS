const weatherService = require('../services/weatherService');

exports.createAlert = async (req, res) => {
    try {
        const { village_id, title, message, alert_level, expires_at } = req.body;

        if (!title || !message) {
            return res.status(400).json({ message: "title and message are required" });
        }

        const validLevels = ['info', 'warning', 'critical'];
        const level = alert_level || 'info';

        if (!validLevels.includes(level)) {
            return res.status(400).json({ message: "Invalid alert_level (info, warning, critical)" });
        }

        const newAlert = await weatherService.createWeatherAlert({
            village_id, title, message, alert_level: level, expires_at: expires_at ? new Date(expires_at) : null
        });

        res.status(201).json({
            message: "Weather alert created successfully",
            data: newAlert
        });
    } catch (error) {
        res.status(500).json({ message: "Error creating weather alert", error: error.message });
    }
};

exports.getAllAlerts = async (req, res) => {
    try {
        const villageId = req.query.villageId || req.params.villageId;
        const alerts = await weatherService.getAllWeatherAlerts(villageId);
        res.json(alerts);
    } catch (error) {
        res.status(500).json({ message: "Error fetching alerts", error: error.message });
    }
};

exports.getActiveAlerts = async (req, res) => {
    try {
        const villageId = req.query.villageId || req.params.villageId;
        const active = await weatherService.getActiveWeatherAlerts(villageId);
        res.json(active);
    } catch (error) {
        res.status(500).json({ message: "Error fetching active alerts", error: error.message });
    }
};

exports.getExpiredAlerts = async (req, res) => {
    try {
        const alerts = await weatherService.getAllWeatherAlerts();
        const now = new Date();
        const expired = alerts.filter(a => a.expires_at && new Date(a.expires_at) <= now);
        res.json(expired);
    } catch (error) {
        res.status(500).json({ message: "Error fetching expired alerts", error: error.message });
    }
};

exports.getAlertsByLevel = async (req, res) => {
    try {
        const alerts = await weatherService.getWeatherAlertsByLevel(req.params.level);
        res.json(alerts);
    } catch (error) {
        res.status(500).json({ message: "Error fetching alerts by level", error: error.message });
    }
};

exports.deleteAlert = async (req, res) => {
    try {
        const isDeleted = await weatherService.deleteWeatherAlert(req.params.id);
        if (!isDeleted) return res.status(404).json({ message: "Alert not found" });
        res.json({ message: "Weather alert deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting alert", error: error.message });
    }
};