const emergencyService = require('../services/emergencyService');

const isValidHex = (color) => {
    return /^#([0-9A-F]{3}){1,2}$/i.test(color);
};

exports.createService = async (req, res) => {
    try {
        const { title, contact_number, category, village_id } = req.body;

        if (!title || !contact_number) {
            return res.status(400).json({ message: "title and contact_number are required" });
        }

        if (!/^[0-9+()-\s]{5,20}$/.test(contact_number)) {
            return res.status(400).json({ message: "Invalid contact_number format" });
        }

        const newService = await emergencyService.createEmergencyService({
            village_id, title, contact_number, category
        });

        res.status(201).json({
            message: "Emergency service created successfully",
            data: newService
        });
    } catch (error) {
        res.status(500).json({ message: "Error creating emergency service", error: error.message });
    }
};

exports.getAllServices = async (req, res) => {
    try {
        const villageId = req.query.village_id || req.query.villageId;
        let services;
        if (villageId) {
            services = await emergencyService.getEmergencyServicesByVillage(villageId);
        } else {
            services = await emergencyService.getAllEmergencyServices();
        }
        res.json(services);
    } catch (error) {
        res.status(500).json({ message: "Error fetching emergency services", error: error.message });
    }
};

exports.getServiceById = async (req, res) => {
    try {
        const services = await emergencyService.getAllEmergencyServices();
        const service = services.find(s => s.id === req.params.id);
        if (!service) return res.status(404).json({ message: "Service not found" });
        res.json(service);
    } catch (error) {
        res.status(500).json({ message: "Error fetching emergency service", error: error.message });
    }
};

exports.getServicesByCategory = async (req, res) => {
    try {
        const services = await emergencyService.getAllEmergencyServices();
        const filtered = services.filter(s => s.category === req.params.category);
        res.json(filtered);
    } catch (error) {
        res.status(500).json({ message: "Error fetching services by category", error: error.message });
    }
};

exports.updateService = async (req, res) => {
    try {
        const { id } = req.params;
        const exists = await emergencyService.getEmergencyServiceById(id);
        if (!exists) return res.status(404).json({ message: "Service not found" });

        const updated = await emergencyService.updateEmergencyService(id, req.body);
        res.json({ message: "Emergency service updated successfully", data: updated });
    } catch (error) {
        res.status(500).json({ message: "Error updating emergency service", error: error.message });
    }
};

exports.deleteService = async (req, res) => {
    try {
        const isDeleted = await emergencyService.deleteEmergencyService(req.params.id);
        if (!isDeleted) return res.status(404).json({ message: "Service not found" });
        res.json({ message: "Service deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting emergency service", error: error.message });
    }
};