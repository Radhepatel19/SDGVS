const agricultureService = require('../services/agricultureService');

exports.createResource = async (req, res) => {
    try {
        const { resource_name, availability_percentage, village_id, status_color } = req.body;

        if (!resource_name) {
            return res.status(400).json({ message: "resource_name is required" });
        }

        if (availability_percentage === undefined || isNaN(availability_percentage) || availability_percentage < 0 || availability_percentage > 100) {
            return res.status(400).json({ message: "availability_percentage must be between 0 and 100" });
        }

        const newResource = await agricultureService.createAgriResource({
            village_id, 
            resource_name, 
            availability_percentage: Number(availability_percentage),
            status_color
        });

        res.status(201).json({ message: "Agri resource created successfully", data: newResource });
    } catch (error) {
        res.status(500).json({ message: "Error creating agri resource", error: error.message });
    }
};

exports.getAllResources = async (req, res) => {
    try {
        const villageId = req.query.villageId || req.params.villageId;
        const resources = await agricultureService.getAllAgriResources(villageId);
        res.json(resources);
    } catch (error) {
        res.status(500).json({ message: "Error fetching resources", error: error.message });
    }
};

exports.getResourceById = async (req, res) => {
    try {
        const resources = await agricultureService.getAllAgriResources();
        const resource = resources.find(r => r.id === req.params.id);
        if (!resource) return res.status(404).json({ message: "Resource not found" });
        res.json(resource);
    } catch (error) {
        res.status(500).json({ message: "Error fetching resource", error: error.message });
    }
};

exports.updateResource = async (req, res) => {
    // Standardizing on creation/deletion for now as per schema limitations
    res.status(403).json({ message: "Update not allowed" });
};

exports.deleteResource = async (req, res) => {
    try {
        const isDeleted = await agricultureService.deleteAgriResource(req.params.id);
        if (!isDeleted) return res.status(404).json({ message: "Resource not found" });
        res.json({ message: "Resource deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting resource", error: error.message });
    }
};