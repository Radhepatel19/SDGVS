const agricultureService = require('../services/agricultureService');

const validSeasons = ['Monsoon', 'Winter', 'Summer'];

// ==============================
// CREATE CROP CALENDAR ENTRY
// ==============================
exports.createCrop = async (req, res) => {
    try {
        const {
            village_id,
            crop_name,
            season,
            stage,           // maps to current_stage
            start_date,      // maps to sowing_period
            end_date,        // maps to harvest_period
            duration,
            best_soil,
            water_requirement,
            description,
            recommended_dates,
            status           // maps to current_status
        } = req.body;

        // --- Validation ---
        if (!crop_name || !season || !stage || !start_date || !end_date) {
            return res.status(400).json({ message: 'crop_name, season, stage, start_date, end_date are required' });
        }
        if (!validSeasons.includes(season)) {
            return res.status(400).json({ message: `Invalid season. Must be one of: ${validSeasons.join(', ')}` });
        }
        const startDate = new Date(start_date);
        const endDate   = new Date(end_date);
        if (isNaN(startDate) || isNaN(endDate) || startDate >= endDate) {
            return res.status(400).json({ message: 'Invalid dates: start_date must be before end_date' });
        }

        const newCrop = await agricultureService.createCropCalendar({
            village_id,
            crop_name,
            season,
            current_stage:     stage,
            sowing_period:     start_date,
            harvest_period:    end_date,
            duration:          duration || null,
            best_soil:         best_soil || null,
            water_requirement: water_requirement || null,
            description:       description || null,
            recommended_dates: recommended_dates || null,
            current_status:    status || 'Upcoming',
        });

        res.status(201).json({ message: 'Crop calendar entry created successfully', data: newCrop });
    } catch (error) {
        console.error('createCrop error:', error);
        res.status(500).json({ message: 'Error creating crop', error: error.message });
    }
};

// ==============================
// GET ALL CROPS (with village filter)
// ==============================
exports.getAllCrops = async (req, res) => {
    try {
        const villageId = req.query.villageId || req.params.villageId;
        const crops = await agricultureService.getAllCropCalendars(villageId);
        res.json(crops);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching crops', error: error.message });
    }
};

// ==============================
// GET CROPS BY SEASON
// ==============================
exports.getCropsBySeason = async (req, res) => {
    try {
        const { season } = req.params;
        if (!validSeasons.includes(season)) {
            return res.status(400).json({ message: `Invalid season. Must be one of: ${validSeasons.join(', ')}` });
        }
        const crops = await agricultureService.getAllCropCalendars();
        res.json(crops.filter(c => c.season === season));
    } catch (error) {
        res.status(500).json({ message: 'Error fetching crops by season', error: error.message });
    }
};

// ==============================
// GET CROPS BY NAME
// ==============================
exports.getCropsByName = async (req, res) => {
    try {
        const crops = await agricultureService.getAllCropCalendars();
        const result = crops.filter(c => c.crop_name.toLowerCase() === req.params.name.toLowerCase());
        res.json(result);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching crops by name', error: error.message });
    }
};

// ==============================
// GET CURRENTLY ACTIVE CROPS
// ==============================
exports.getActiveCrops = async (req, res) => {
    try {
        const crops = await agricultureService.getAllCropCalendars();
        const today = new Date();
        const active = crops.filter(crop => {
            if (!crop.sowing_period || !crop.harvest_period) return false;
            return new Date(crop.sowing_period) <= today && new Date(crop.harvest_period) >= today;
        });
        res.json(active);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching active crops', error: error.message });
    }
};

// ==============================
// UPDATE CROP CALENDAR ENTRY
// ==============================
exports.updateCrop = async (req, res) => {
    try {
        const {
            crop_name, season, stage, start_date, end_date,
            duration, best_soil, water_requirement, description,
            recommended_dates, status
        } = req.body;

        if (season && !validSeasons.includes(season)) {
            return res.status(400).json({ message: `Invalid season. Must be one of: ${validSeasons.join(', ')}` });
        }

        const updated = await agricultureService.updateCropCalendar(req.params.id, {
            crop_name,
            season,
            current_stage:     stage,
            sowing_period:     start_date,
            harvest_period:    end_date,
            duration,
            best_soil,
            water_requirement,
            description,
            recommended_dates,
            current_status:    status,
        });

        if (!updated) return res.status(404).json({ message: 'Crop entry not found' });
        res.json({ message: 'Crop calendar updated successfully', data: updated });
    } catch (error) {
        res.status(500).json({ message: 'Error updating crop', error: error.message });
    }
};

// ==============================
// DELETE CROP CALENDAR ENTRY
// ==============================
exports.deleteCrop = async (req, res) => {
    try {
        const isDeleted = await agricultureService.deleteCropCalendar(req.params.id);
        if (!isDeleted) return res.status(404).json({ message: 'Crop entry not found' });
        res.json({ message: 'Crop entry deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting crop', error: error.message });
    }
};