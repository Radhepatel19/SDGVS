const pollService = require('../services/pollService');

exports.votePoll = async (req, res) => {
    try {
        const { user_id, poll_id, option_id } = req.body;

        if (!user_id || !poll_id || !option_id) {
            return res.status(400).json({ message: "user_id, poll_id and option_id are required" });
        }

        const poll = await pollService.getPollById(poll_id);
        if (!poll) return res.status(404).json({ message: "Poll not found" });

        if (new Date(poll.expiry_date) <= new Date()) {
            return res.status(400).json({ message: "Poll has expired" });
        }

        const result = await pollService.votePoll(poll_id, option_id, user_id);
        res.status(201).json({ message: "Vote recorded successfully", data: result });
    } catch (error) {
        res.status(500).json({ message: "Error recording vote", error: error.message });
    }
};

exports.getVotesByPoll = async (req, res) => {
    try {
        const poll = await pollService.getPollById(req.params.pollId);
        if (!poll) return res.status(404).json({ message: "Poll not found" });

        const options = poll.options || [];
        const totalVotes = options.reduce((sum, opt) => sum + Number(opt.votes_count), 0);

        const results = options.map(opt => ({
            option_id: opt.id,
            option_text: opt.option_text,
            votes_count: opt.votes_count,
            percentage: totalVotes === 0 ? 0 : ((opt.votes_count / totalVotes) * 100).toFixed(2)
        }));

        res.json({ total_votes: totalVotes, results });
    } catch (error) {
        res.status(500).json({ message: "Error fetching poll results", error: error.message });
    }
};