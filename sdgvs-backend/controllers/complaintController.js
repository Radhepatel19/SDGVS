const complaintService = require('../services/complaintService');
const rewardService = require('../services/rewardService');
const cloudinaryService = require('../services/cloudinaryService');
const { v4: uuidv4 } = require('uuid');

const generateComplaintId = () => {
    const year = new Date().getFullYear();
    const random = Math.floor(1000 + Math.random() * 9000);
    return `SDGVS-${year}-${random}`;
};

exports.createComplaint = async (req, res) => {
    try {
        const { user_id, category, description, priority, complaint_id_display } = req.body;
        let { image_url, audio_url } = req.body;

        if (!user_id || !category || !description) {
            return res.status(400).json({ message: "user_id, category and description are required" });
        }

        const validPriorities = ["low", "medium", "high"];
        const complaintPriority = priority || "medium";
        if (!validPriorities.includes(complaintPriority)) {
            return res.status(400).json({ message: "Invalid priority value" });
        }

        // Handle File Uploads to Cloudinary
        if (req.files) {
            if (req.files.imagePath && req.files.imagePath[0]) {
                const result = await cloudinaryService.uploadStream(req.files.imagePath[0].buffer, 'sdgvs_complaints_images', 'image');
                image_url = result.secure_url;
            }
            if (req.files.voicePath && req.files.voicePath[0]) {
                const result = await cloudinaryService.uploadStream(req.files.voicePath[0].buffer, 'sdgvs_complaints_audio', 'video'); // Cloudinary handles audio as video
                audio_url = result.secure_url;
            }
        }

        const finalComplaintIdDisplay = complaint_id_display || generateComplaintId();

        const newComplaint = await complaintService.createComplaint({
            user_id,
            complaint_id_display: finalComplaintIdDisplay,
            category,
            description,
            priority: complaintPriority,
            image_url,
            audio_url
        });

        res.status(201).json({
            message: "Complaint registered successfully",
            data: newComplaint
        });
    } catch (error) {
        res.status(500).json({ message: "Error creating complaint", error: error.message });
    }
};

exports.getAllComplaints = async (req, res) => {
    try {
        const userId = req.query.userId;
        const complaints = await complaintService.getAllComplaints(userId);
        res.json(complaints);
    } catch (error) {
        res.status(500).json({ message: "Error fetching complaints", error: error.message });
    }
};

exports.getComplaintById = async (req, res) => {
    try {
        const complaint = await complaintService.getComplaintById(req.params.id);
        if (!complaint) {
            return res.status(404).json({ message: "Complaint not found" });
        }
        res.json(complaint);
    } catch (error) {
        res.status(500).json({ message: "Error fetching complaint", error: error.message });
    }
};

exports.updateComplaint = async (req, res) => {
    try {
        const complaint = await complaintService.getComplaintById(req.params.id);
        if (!complaint) {
            return res.status(404).json({ message: "Complaint not found" });
        }

        const { status, priority, admin_remarks } = req.body;

        // Match schema: 'Pending', 'In Progress', 'Resolved'
        const validStatuses = ["Pending", "In Progress", "Resolved"];
        if (status && !validStatuses.includes(status)) {
            return res.status(400).json({ message: `Invalid status. Must be one of: ${validStatuses.join(', ')}` });
        }

        const validPriorities = ["low", "medium", "high"];
        if (priority && !validPriorities.includes(priority)) {
            return res.status(400).json({ message: "Invalid priority value" });
        }

        const updatedComplaint = await complaintService.updateComplaintStatus(req.params.id, status || complaint.status, admin_remarks);
        
        res.json({
            message: "Complaint updated successfully",
            data: updatedComplaint
        });
    } catch (error) {
        res.status(500).json({ message: "Error updating complaint", error: error.message });
    }
};

exports.deleteComplaint = async (req, res) => {
    try {
        const isDeleted = await complaintService.deleteComplaint(req.params.id);
        if (!isDeleted) {
            return res.status(404).json({ message: "Complaint not found" });
        }
        res.json({ message: "Complaint deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting complaint", error: error.message });
    }
};
