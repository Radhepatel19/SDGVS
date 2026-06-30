const rewardService = require('../services/rewardService');

const validMonths = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
];

exports.createWinner = async (req, res) => {
    try {
        const { user_id, name, village_id, category, month, year, profile_image_url, achievement } = req.body;

        if (!name || !village_id || !category || !month || !year || !achievement) {
            return res.status(400).json({ message: "All required fields must be provided" });
        }

        if (!validMonths.includes(month)) {
            return res.status(400).json({ message: "Invalid month name" });
        }

        if (!/^\d{4}$/.test(year)) {
            return res.status(400).json({ message: "Year must be 4 digits (e.g., 2025)" });
        }

        const newWinner = await rewardService.addRewardWinner({
            user_id, name, village_id, category, month, year, profile_image_url, achievement
        });

        res.status(201).json({ message: "Reward winner created successfully", data: newWinner });
    } catch (error) {
        res.status(500).json({ message: "Error creating winner", error: error.message });
    }
};

exports.getAllWinners = async (req, res) => {
    try {
        const villageId = req.query.villageId || req.query.village_id;

        if (!villageId || villageId === 'null' || villageId === 'undefined') {
            return res.status(200).json([]);
        }

        const winners = await rewardService.getRewardWinners(villageId);
        res.json(winners);
    } catch (error) {
        res.status(500).json({ message: "Error fetching winners", error: error.message });
    }
};

exports.getWinnerById = async (req, res) => {
    try {
        const winners = await rewardService.getRewardWinners();
        const winner = winners.find(w => w.id === req.params.id);
        if (!winner) return res.status(404).json({ message: "Winner not found" });
        res.json(winner);
    } catch (error) {
        res.status(500).json({ message: "Error fetching winner", error: error.message });
    }
};

exports.getWinnersByMonthYear = async (req, res) => {
    try {
        const { month, year } = req.params;
        const winners = await rewardService.getRewardWinners();
        const filtered = winners.filter(w => w.month === month && w.year === year);
        res.json(filtered);
    } catch (error) {
        res.status(500).json({ message: "Error fetching winners by date", error: error.message });
    }
};

exports.getWinnersByCategory = async (req, res) => {
    try {
        const { category } = req.params;
        const winners = await rewardService.getRewardWinners();
        const filtered = winners.filter(w => w.category === category);
        res.json(filtered);
    } catch (error) {
        res.status(500).json({ message: "Error fetching winners by category", error: error.message });
    }
};

exports.getWinnersByVillage = async (req, res) => {
    try {
        const winners = await rewardService.getRewardWinners();
        // Match the route parameter name :village
        const filtered = winners.filter(w => w.village_id === req.params.village || w.village_name === req.params.village);
        res.json(filtered);
    } catch (error) {
        res.status(500).json({ message: "Error fetching winners by village", error: error.message });
    }
};

exports.updateWinner = async (req, res) => {
    try {
        const { id } = req.params;
        const winners = await rewardService.getRewardWinners();
        const exists = winners.find(w => w.id === id);
        if (!exists) return res.status(404).json({ message: "Winner not found" });

        const updated = await rewardService.updateRewardWinner(id, req.body);
        res.json({ message: "Winner updated successfully", data: updated });
    } catch (error) {
        res.status(500).json({ message: "Error updating winner", error: error.message });
    }
};

exports.deleteWinner = async (req, res) => {
    try {
        const isDeleted = await rewardService.deleteRewardWinner(req.params.id);
        if (!isDeleted) return res.status(404).json({ message: "Winner not found" });
        res.json({ message: "Winner deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting winner", error: error.message });
    }
};