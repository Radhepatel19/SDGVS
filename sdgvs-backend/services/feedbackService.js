const db = require('../config/db');

exports.createFeedback = async (feedbackData) => {
    const { user_id, complaint_id, rating, comments } = feedbackData;
    const query = `
        INSERT INTO feedback (user_id, complaint_id, rating, comments) 
        VALUES ($1, $2, $3, $4) 
        RETURNING *`;
    const values = [user_id, complaint_id, rating, comments];
    const result = await db.query(query, values);
    return result.rows[0];
};

exports.getAllFeedback = async () => {
    const query = `SELECT * FROM feedback ORDER BY created_at DESC`;
    const result = await db.query(query);
    return result.rows;
};

exports.getFeedbackById = async (id) => {
    const query = `SELECT * FROM feedback WHERE id = $1`;
    const result = await db.query(query, [id]);
    return result.rows[0];
};
