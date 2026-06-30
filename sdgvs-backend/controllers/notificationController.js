const notificationService = require('../services/notificationService');

exports.createNotification = async (req, res) => {
    try {
        const { admin_id, village_id, title, message, type } = req.body;

        if (!admin_id || !village_id || !title || !message || !type) {
            return res.status(400).json({ message: "admin_id, village_id, title, message and type are required" });
        }

        const validTypes = ['complaint', 'scheme', 'announcement'];
        if (!validTypes.includes(type)) {
            return res.status(400).json({ message: "Invalid type. Allowed: complaint, scheme, announcement" });
        }

        const newNotification = await notificationService.createNotification({
            admin_id, village_id, title, message, type
        });

        res.status(201).json({
            message: "Notification created successfully",
            data: newNotification
        });
    } catch (error) {
        res.status(500).json({ message: "Error creating notification", error: error.message });
    }
};

exports.getNotifications = async (req, res) => {
    try {
        let villageId = req.query.village_id || req.query.villageId;

        // Fallback: If not in query parameters, attempt to fetch from the authenticated user's profile
        if (!villageId && req.userData && req.userData.id) {
            const userService = require('../services/userService');
            const user = await userService.getUserById(req.userData.id);
            if (user && user.village_id) {
                villageId = user.village_id;
            } else {
                const adminService = require('../services/adminService');
                const admin = await adminService.getAdminById(req.userData.id);
                if (admin && admin.village_id) {
                    villageId = admin.village_id;
                }
            }
        }

        let notifications;
        if (villageId) {
            notifications = await notificationService.getNotificationsByVillageId(villageId);
        } else {
            notifications = await notificationService.getAllNotifications();
        }
        res.json(notifications);
    } catch (error) {
        res.status(500).json({ message: "Error fetching notifications", error: error.message });
    }
};

exports.getUserNotifications = async (req, res) => {
    try {
        const villageId = req.params.userId; // Flutter app sends village_id as userId parameter here
        const notifications = await notificationService.getNotificationsByVillageId(villageId);
        res.json(notifications);
    } catch (error) {
        res.status(500).json({ message: "Error fetching notifications", error: error.message });
    }
};

exports.markAsRead = async (req, res) => {
    // DB doesn't track is_read (per user request). Handled locally on mobile device.
    res.json({ message: "Notification marked as read (simulated)" });
};

exports.markAllAsRead = async (req, res) => {
    // DB doesn't track is_read. Handled locally on mobile device.
    res.json({ message: "All notifications marked as read (simulated)" });
};

exports.deleteNotification = async (req, res) => {
    try {
        const isDeleted = await notificationService.deleteNotification(req.params.id);
        if (!isDeleted) {
            return res.status(404).json({ message: "Notification not found" });
        }
        res.json({ message: "Notification deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting notification", error: error.message });
    }
};