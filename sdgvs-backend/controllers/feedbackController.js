const feedbackService = require('../services/feedbackService');
const complaintService = require('../services/complaintService');

exports.createFeedback = async (req, res) => {
    try {
        const { user_id, complaint_id, rating, comments } = req.body;

        if (!user_id || !complaint_id || !rating) {
            return res.status(400).json({ message: "user_id, complaint_id and rating are required" });
        }

        const complaint = await complaintService.getComplaintById(complaint_id);
        if (!complaint) {
            return res.status(400).json({ message: "Invalid complaint_id" });
        }

        if (rating < 1 || rating > 5) {
            return res.status(400).json({ message: "Rating must be between 1 and 5" });
        }

        // Use the actual UUID from the database for storing the feedback
        const newFeedback = await feedbackService.createFeedback({
            user_id, 
            complaint_id: complaint.id, 
            rating, 
            comments
        });

        res.status(201).json({
            message: "Feedback submitted successfully",
            data: newFeedback
        });
    } catch (error) {
        res.status(500).json({ message: "Error submitting feedback", error: error.message });
    }
};

exports.getAllFeedback = async (req, res) => {
    try {
        const feedbacks = await feedbackService.getAllFeedback();
        res.json(feedbacks);
    } catch (error) {
        res.status(500).json({ message: "Error fetching feedback", error: error.message });
    }
};

exports.getFeedbackByComplaint = async (req, res) => {
    try {
        const feedbacks = await feedbackService.getAllFeedback();
        const filtered = feedbacks.filter(f => f.complaint_id === req.params.complaintId);
        res.json(filtered);
    } catch (error) {
        res.status(500).json({ message: "Error fetching complaint feedback", error: error.message });
    }
};

exports.getFeedbackByUser = async (req, res) => {
    try {
        const feedbacks = await feedbackService.getAllFeedback();
        const filtered = feedbacks.filter(f => f.user_id === req.params.userId);
        res.json(filtered);
    } catch (error) {
        res.status(500).json({ message: "Error fetching user feedback", error: error.message });
    }
};

exports.deleteFeedback = (req, res) => {
    // Left empty for now as feedback shouldn't typically be deleted, but maintaining interface.
    res.status(403).json({ message: "Feedback deletion is not supported through REST API" });
};