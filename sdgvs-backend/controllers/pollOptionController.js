const pollService = require('../services/pollService');

exports.addOption = async (req, res) => {
    try {
        const { poll_id, option_text } = req.body;

        if (!poll_id || !option_text) {
            return res.status(400).json({ message: "poll_id and option_text are required" });
        }

        const poll = await pollService.getPollById(poll_id);
        if (!poll) return res.status(404).json({ message: "Poll not found" });

        const newOption = await pollService.addPollOption(poll_id, option_text);

        res.status(201).json({ message: "Option added successfully", data: newOption });
    } catch (error) {
        res.status(500).json({ message: "Error adding option", error: error.message });
    }
};

exports.getOptionsByPoll = async (req, res) => {
    try {
        const poll = await pollService.getPollById(req.params.pollId);
        if (!poll) return res.status(404).json({ message: "Poll not found" });
        res.json(poll.options || []);
    } catch (error) {
        res.status(500).json({ message: "Error fetching options", error: error.message });
    }
};

exports.voteOption = async (req, res) => {
    // Standardizing on userPollVoteController.votePoll for consistency
    res.status(403).json({ message: "Use /api/user-poll-votes/vote instead" });
};
