const agricultureService = require('../services/agricultureService');

exports.createNotice = async (req, res) => {
    try {
        const { village_id, title, message } = req.body;

        if (!title || !message) {
            return res.status(400).json({ message: "title and message are required" });
        }

        const newNotice = await agricultureService.createAgriNotice({
            village_id, title, message
        });

        res.status(201).json({
            message: "Agriculture notice created successfully",
            data: newNotice
        });
    } catch (error) {
        res.status(500).json({ message: "Error creating agri notice", error: error.message });
    }
};

exports.getAllNotices = async (req, res) => {
    try {
        const villageId = req.query.villageId || req.params.villageId;
        const notices = await agricultureService.getAllAgriNotices(villageId);
        res.json(notices);
    } catch (error) {
        res.status(500).json({ message: "Error fetching agri notices", error: error.message });
    }
};

exports.getNoticesByVillage = async (req, res) => {
    try {
        const notices = await agricultureService.getAllAgriNotices();
        const filtered = notices.filter(n => n.village_id === req.params.villageId);
        res.json(filtered);
    } catch (error) {
        res.status(500).json({ message: "Error fetching agri notices by village", error: error.message });
    }
};

exports.deleteNotice = async (req, res) => {
    try {
        const isDeleted = await agricultureService.deleteAgriNotice(req.params.id);
        if (!isDeleted) return res.status(404).json({ message: "Notice not found" });
        res.json({ message: "Agriculture notice deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting agri notice", error: error.message });
    }
};
