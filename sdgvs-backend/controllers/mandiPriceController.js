const db = require('../config/db');
const mandiService = require('../services/mandiService');

exports.createPrice = async (req, res) => {
    try {
        const { 
            crop_name, mandi_name, price_min, price_max, 
            price_avg, unit, price_date, status, village_id 
        } = req.body;

        if (!crop_name || !price_avg || !mandi_name) {
            return res.status(400).json({ message: "crop_name, price_avg and mandi_name are required" });
        }

        const newPrice = await mandiService.createMandiPrice({
            village_id, crop_name, mandi_name, price_min, 
            price_max, price_avg, unit, price_date, status
        });

        res.status(201).json({ message: "Mandi price added successfully", data: newPrice });
    } catch (error) {
        res.status(500).json({ message: "Error creating price entry", error: error.message });
    }
};

exports.getAllPrices = async (req, res) => {
    try {
        const villageId = req.query.villageId || req.params.villageId;
        const prices = await mandiService.getAllMandiPrices(villageId);
        res.json(prices);
    } catch (error) {
        res.status(500).json({ message: "Error fetching prices", error: error.message });
    }
};

exports.getPricesByCrop = async (req, res) => {
    try {
        const villageId = req.query.villageId || req.params.villageId;
        let query = `SELECT * FROM mandi_prices WHERE LOWER(crop_name) = $1`;
        let values = [req.params.name.toLowerCase()];
        if (villageId) {
            query += ` AND village_id = $2`;
            values.push(villageId);
        }
        query += ` ORDER BY created_at DESC`;
        const result = await db.query(query, values);
        res.json(result.rows);
    } catch (error) {
        res.status(500).json({ message: "Error fetching crops by name", error: error.message });
    }
};

exports.getPricesByLocation = async (req, res) => {
    try {
        const villageId = req.query.villageId || req.params.villageId;
        let query = `SELECT * FROM mandi_prices WHERE LOWER(mandi_name) = $1`;
        let values = [req.params.location.toLowerCase()];
        if (villageId) {
            query += ` AND village_id = $2`;
            values.push(villageId);
        }
        query += ` ORDER BY created_at DESC`;
        const result = await db.query(query, values);
        res.json(result.rows);
    } catch (error) {
        res.status(500).json({ message: "Error fetching crops by location", error: error.message });
    }
};

exports.getLatestPrices = async (req, res) => {
    try {
        const villageId = req.query.villageId || req.params.villageId;
        let query = `SELECT DISTINCT ON (crop_name) * FROM mandi_prices`;
        let values = [];
        if (villageId) {
            query += ` WHERE village_id = $1`;
            values.push(villageId);
        }
        query += ` ORDER BY crop_name, created_at DESC`;
        const result = await db.query(query, values);
        res.json(result.rows);
    } catch (error) {
        res.status(500).json({ message: "Error fetching latest prices", error: error.message });
    }
};

exports.getPriceTrend = async (req, res) => {
    try {
        const query = `SELECT * FROM mandi_prices WHERE LOWER(crop_name) = $1 ORDER BY created_at DESC LIMIT 7`;
        const result = await db.query(query, [req.params.name.toLowerCase()]);
        res.json(result.rows);
    } catch (error) {
        res.status(500).json({ message: "Error fetching price trend", error: error.message });
    }
};

exports.updatePrice = async (req, res) => {
    try {
        const { price_min, price_max, price_avg, unit, status } = req.body;
        const query = `
            UPDATE mandi_prices SET 
                price_min = COALESCE($1, price_min),
                price_max = COALESCE($2, price_max),
                price_avg = COALESCE($3, price_avg),
                unit = COALESCE($4, unit),
                status = COALESCE($5, status)
            WHERE id = $6 RETURNING *`;
        const result = await db.query(query, [price_min, price_max, price_avg, unit, status, req.params.id]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({ message: "Price entry not found" });
        }
        res.json({ message: "Price updated successfully", data: result.rows[0] });
    } catch (error) {
        res.status(500).json({ message: "Error updating price", error: error.message });
    }
};

exports.deletePrice = async (req, res) => {
    try {
        const isDeleted = await mandiService.deleteMandiPrice(req.params.id);
        if (!isDeleted) {
            return res.status(404).json({ message: "Price entry not found" });
        }
        res.json({ message: "Price entry deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting price entry", error: error.message });
    }
};