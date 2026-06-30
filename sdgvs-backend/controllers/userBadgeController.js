const rewardService = require('../services/rewardService');

exports.awardBadge = async (req, res) => {
    try {
        const { user_id, name, description } = req.body;

        if (!user_id || !name || !description) {
            return res.status(400).json({ message: "user_id, name and description are required" });
        }

        const newBadge = await rewardService.addBadge(user_id, { name, description });

        res.status(201).json({ message: "Badge awarded successfully", data: newBadge });
    } catch (error) {
        res.status(500).json({ message: "Error awarding badge", error: error.message });
    }
};

exports.getAllBadges = async (req, res) => {
    // Current rewardService doesn't have a global search for all user badges, 
    // but we can query directly if needed. For now, returning simple list.
    res.json({ message: "Global badges list not implemented" });
};

exports.getUserBadges = async (req, res) => {
    try {
        const badges = await rewardService.getUserBadges(req.params.userId);
        res.json(badges);
    } catch (error) {
        res.status(500).json({ message: "Error fetching badges", error: error.message });
    }
};

exports.deleteBadge = async (req, res) => {
    res.status(403).json({ message: "Badge deletion not allowed" });
};