const documentService = require('../services/documentService');
const cloudinaryService = require('../services/cloudinaryService');

exports.uploadDocument = async (req, res) => {
    try {
        const { user_id, title, type } = req.body;
        let file_path = req.body.file_path;

        if (!user_id || !title || !type) {
            return res.status(400).json({ message: "user_id, title and type are required" });
        }

        // Check the document limit (Max 10)
        const docCount = await documentService.getDocumentCountByUser(user_id);
        if (docCount >= 10) {
            return res.status(400).json({ message: "Upload limit reached. You can only upload a maximum of 10 documents." });
        }

        // Upload to Cloudinary if a file buffer is present
        if (req.file) {
            const result = await cloudinaryService.uploadStream(req.file.buffer, 'sdgvs_documents', 'auto');
            file_path = result.secure_url;
        }

        if (!file_path) {
            return res.status(400).json({ message: "file_path or uploaded file is required" });
        }

        const newDocument = await documentService.uploadDocument({
            user_id, title, type, file_path
        });

        res.status(201).json({
            message: "Document uploaded successfully",
            data: newDocument
        });
    } catch (error) {
        res.status(500).json({ message: "Error uploading document", error: error.message });
    }
};

exports.getAllDocuments = async (req, res) => {
    // Global list usually not exposed to users, but for admin we can query directly.
    res.status(403).json({ message: "Not implemented" });
};

exports.getDocumentsByUser = async (req, res) => {
    try {
        const docs = await documentService.getDocumentsByUser(req.params.userId);
        res.json(docs);
    } catch (error) {
        res.status(500).json({ message: "Error fetching documents", error: error.message });
    }
};

exports.getDocumentById = async (req, res) => {
    try {
        const doc = await documentService.getDocumentById(req.params.id);
        if (!doc) return res.status(404).json({ message: "Document not found" });
        res.json(doc);
    } catch (error) {
        res.status(500).json({ message: "Error fetching document", error: error.message });
    }
};

exports.deleteDocument = async (req, res) => {
    try {
        const isDeleted = await documentService.deleteDocument(req.params.id);
        if (!isDeleted) return res.status(404).json({ message: "Document not found" });
        res.json({ message: "Document deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting document", error: error.message });
    }
};