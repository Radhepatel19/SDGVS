const noticeService = require('../services/noticeService');

exports.createNotice = async (req, res) => {
    try {
        const { admin_id, village_id, title, message, type, is_high_priority } = req.body;

        if (!admin_id || !title || !message || !type) {
            return res.status(400).json({ message: "admin_id, title, message and type are required" });
        }

        const validTypes = ['general', 'water', 'power'];
        if (!validTypes.includes(type)) {
            return res.status(400).json({ message: "Invalid type. Allowed: general, water, power" });
        }

        const newNotice = await noticeService.createNotice({
            admin_id, village_id, title, message, type, is_high_priority
        });

        res.status(201).json({
            message: "Notice created successfully",
            data: newNotice
        });
    } catch (error) {
        res.status(500).json({ message: "Error creating notice", error: error.message });
    }
};

exports.getAllNotices = async (req, res) => {
    try {
        const { village_id } = req.query;
        let notices;
        if (village_id) {
            notices = await noticeService.getNoticesByVillageId(village_id);
        } else {
            notices = await noticeService.getAllNotices();
        }
        res.json(notices);
    } catch (error) {
        res.status(500).json({ message: "Error fetching notices", error: error.message });
    }
};

exports.getNoticeById = async (req, res) => {
    try {
        const notice = await noticeService.getNoticeById(req.params.id);
        if (!notice) {
            return res.status(404).json({ message: "Notice not found" });
        }
        res.json(notice);
    } catch (error) {
        res.status(500).json({ message: "Error fetching notice", error: error.message });
    }
};

exports.getNoticesByType = async (req, res) => {
    try {
        const { village_id } = req.query;
        const type = req.params.type;
        let notices = village_id ? await noticeService.getNoticesByVillageId(village_id) : await noticeService.getAllNotices();
        const filtered = notices.filter(n => n.type === type);
        res.json(filtered);
    } catch (error) {
        res.status(500).json({ message: "Error fetching notices by type", error: error.message });
    }
};

exports.getHighPriorityNotices = async (req, res) => {
    try {
        const { village_id } = req.query;
        let notices = village_id ? await noticeService.getNoticesByVillageId(village_id) : await noticeService.getAllNotices();
        const filtered = notices.filter(n => n.is_high_priority === true);
        res.json(filtered);
    } catch (error) {
        res.status(500).json({ message: "Error fetching priority notices", error: error.message });
    }
};

exports.getNoticesByAdmin = async (req, res) => {
    try {
        const notices = await noticeService.getAllNotices();
        const filtered = notices.filter(n => n.admin_id === req.params.adminId);
        res.json(filtered);
    } catch (error) {
        res.status(500).json({ message: "Error fetching notices by admin", error: error.message });
    }
};

exports.deleteNotice = async (req, res) => {
    try {
        const isDeleted = await noticeService.deleteNotice(req.params.id);
        if (!isDeleted) {
            return res.status(404).json({ message: "Notice not found" });
        }
        res.json({ message: "Notice deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting notice", error: error.message });
    }
};