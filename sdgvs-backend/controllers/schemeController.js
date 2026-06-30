const schemeService = require('../services/schemeService');

exports.createScheme = async (req, res) => {
    try {
        const { title, category, description } = req.body;

        if (!title || !category || !description) {
            return res.status(400).json({
                message: "title, category and description are required"
            });
        }

        const newScheme = await schemeService.createScheme(req.body);

        res.status(201).json({
            message: "Scheme created successfully",
            data: newScheme
        });
    } catch (error) {
        res.status(500).json({ message: "Error creating scheme", error: error.message });
    }
};

exports.getAllSchemes = async (req, res) => {
    try {
        const schemes = await schemeService.getAllSchemes();
        res.json(schemes);
    } catch (error) {
        res.status(500).json({ message: "Error fetching schemes", error: error.message });
    }
};

exports.getSchemeById = async (req, res) => {
    try {
        const scheme = await schemeService.getSchemeById(req.params.id);
        if (!scheme) {
            return res.status(404).json({ message: "Scheme not found" });
        }
        res.json(scheme);
    } catch (error) {
        res.status(500).json({ message: "Error fetching scheme", error: error.message });
    }
};

exports.getSchemesByCategory = async (req, res) => {
    try {
        const schemes = await schemeService.getSchemesByCategory(req.params.category);
        res.json(schemes);
    } catch (error) {
        res.status(500).json({ message: "Error fetching category schemes", error: error.message });
    }
};

exports.updateScheme = async (req, res) => {
    try {
        const schemeId = req.params.id;
        const exists = await schemeService.getSchemeById(schemeId);

        if (!exists) {
            return res.status(404).json({ message: "Scheme not found" });
        }

        const updatedScheme = await schemeService.updateScheme(schemeId, req.body);

        res.json({
            message: "Scheme updated successfully",
            data: updatedScheme
        });
    } catch (error) {
        res.status(500).json({ message: "Error updating scheme", error: error.message });
    }
};

exports.deleteScheme = async (req, res) => {
    try {
        const isDeleted = await schemeService.deleteScheme(req.params.id);

        if (!isDeleted) {
            return res.status(404).json({ message: "Scheme not found" });
        }

        res.json({ message: "Scheme deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting scheme", error: error.message });
    }
};

exports.applyScheme = async (req, res) => {
    try {
        const { user_id, scheme_id } = req.body;
        if (!user_id || !scheme_id) {
            return res.status(400).json({ message: "user_id and scheme_id are required" });
        }

        // In a real app, we would save to an applied_schemes table here.
        // For now, we just increment the impact stats.
        const rewardService = require('../services/rewardService');
        await rewardService.incrementImpactStat(user_id, 'schemes_applied', 1);

        res.json({
            message: "Scheme application submitted successfully",
            success: true
        });
    } catch (error) {
        res.status(500).json({ message: "Error applying for scheme", error: error.message });
    }
};

exports.getUniqueCategories = async (req, res) => {
    try {
        const categories = await schemeService.getUniqueCategories();
        res.json(categories);
    } catch (error) {
        res.status(500).json({ message: "Error fetching unique categories", error: error.message });
    }
};