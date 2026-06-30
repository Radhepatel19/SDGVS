const utilityService = require('../services/utilityService');

exports.createAuditLog = async (req, res) => {
    try {
        const { admin_id, action, table_name, record_id, details } = req.body;

        if (!action || !table_name) {
            return res.status(400).json({ message: "action and table_name are required" });
        }

        const newLog = await utilityService.createAuditLog({
            admin_id, action, target_type: table_name, target_id: record_id, details
        });

        res.status(201).json({ message: "Audit log created successfully", data: newLog });
    } catch (error) {
        res.status(500).json({ message: "Error creating audit log", error: error.message });
    }
};

exports.getAllAuditLogs = async (req, res) => {
    try {
        const logs = await utilityService.getAuditLogs();
        res.json(logs);
    } catch (error) {
        res.status(500).json({ message: "Error fetching audit logs", error: error.message });
    }
};

exports.getAuditLogsByAdmin = async (req, res) => {
    try {
        const logs = await utilityService.getAuditLogs();
        const filtered = logs.filter(l => l.admin_id === req.params.adminId);
        res.json(filtered);
    } catch (error) {
        res.status(500).json({ message: "Error fetching admin audit logs", error: error.message });
    }
};

exports.deleteAuditLog = async (req, res) => {
    res.status(403).json({ message: "Audit log deletion not allowed" });
};