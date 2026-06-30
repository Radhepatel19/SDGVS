const pollService = require('../services/pollService');

exports.createPoll = async (req, res) => {
    try {
        const { village_id, question, expiry_date, options } = req.body;

        if (!question || !expiry_date) {
            return res.status(400).json({ message: "question and expiry_date are required" });
        }

        const expiry = new Date(expiry_date);
        if (isNaN(expiry.getTime())) {
            return res.status(400).json({ message: "Invalid expiry_date format" });
        }

        if (expiry <= new Date()) {
            return res.status(400).json({ message: "expiry_date must be in the future" });
        }

        const newPoll = await pollService.createPoll({
            village_id, question, expiry_date: expiry, options
        });

        res.status(201).json({
            message: "Poll created successfully",
            data: newPoll
        });
    } catch (error) {
        res.status(500).json({ message: "Error creating poll", error: error.message });
    }
};

exports.getAllPolls = async (req, res) => {
    try {
        const { village_id, user_id } = req.query;
        const polls = await pollService.getAllPolls(village_id, user_id);
        res.json(polls);
    } catch (error) {
        res.status(500).json({ message: "Error fetching polls", error: error.message });
    }
};

exports.getPollById = async (req, res) => {
    try {
        const { user_id } = req.query;
        const poll = await pollService.getPollById(req.params.id, user_id);
        if (!poll) {
            return res.status(404).json({ message: "Poll not found" });
        }
        res.json(poll);
    } catch (error) {
        res.status(500).json({ message: "Error fetching poll", error: error.message });
    }
};

exports.getActivePolls = async (req, res) => {
    try {
        const { village_id, user_id } = req.query;
        const now = new Date();
        const polls = await pollService.getAllPolls(village_id, user_id);
        const activePolls = polls.filter(p => new Date(p.expiry_date) > now);
        res.json(activePolls);
    } catch (error) {
        res.status(500).json({ message: "Error fetching active polls", error: error.message });
    }
};

exports.getExpiredPolls = async (req, res) => {
    try {
        const { village_id, user_id } = req.query;
        const now = new Date();
        const polls = await pollService.getAllPolls(village_id, user_id);
        const expiredPolls = polls.filter(p => new Date(p.expiry_date) <= now);
        res.json(expiredPolls);
    } catch (error) {
        res.status(500).json({ message: "Error fetching expired polls", error: error.message });
    }
};

exports.deletePoll = async (req, res) => {
    try {
        const isDeleted = await pollService.deletePoll(req.params.id);
        if (!isDeleted) {
            return res.status(404).json({ message: "Poll not found" });
        }
        res.json({ message: "Poll and related options deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting poll", error: error.message });
    }
};