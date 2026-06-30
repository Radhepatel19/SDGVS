const db = require('../config/db');

exports.getGoodNews = async (req, res) => {
    try {
        const query = 'SELECT * FROM good_news ORDER BY created_at DESC';
        const result = await db.query(query);
        res.status(200).json(result.rows);
    } catch (e) {
        console.error("Error fetching good news:", e);
        res.status(500).json({ message: "Internal server error" });
    }
};

exports.getNotices = async (req, res) => {
    try {
        const query = 'SELECT * FROM notices ORDER BY created_at DESC';
        const result = await db.query(query);
        res.status(200).json(result.rows);
    } catch (e) {
        console.error("Error fetching notices:", e);
        res.status(500).json({ message: "Internal server error" });
    }
};

exports.getRewards = async (req, res) => {
    try {
        const villageId = req.query.villageId || req.query.village_id;
        
        if (!villageId || villageId === 'null' || villageId === 'undefined') {
            // Strictly return empty if no village context is provided
            return res.status(200).json([]);
        }

        const query = 'SELECT * FROM user_certificates WHERE village_id = $1 ORDER BY date_awarded DESC LIMIT 10';
        const params = [villageId];
        
        const result = await db.query(query, params);
        res.status(200).json(result.rows);
    } catch (e) {
        console.error("Error fetching rewards:", e);
        res.status(500).json({ message: "Internal server error" });
    }
};
