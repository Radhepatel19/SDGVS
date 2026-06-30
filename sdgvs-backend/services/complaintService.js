const db = require('../config/db');

exports.createComplaint = async (complaintData) => {
    const { user_id, complaint_id_display, category, description, priority, image_url, audio_url } = complaintData;
    const query = `
        INSERT INTO complaints (user_id, complaint_id_display, category, description, priority, image_url, audio_url) 
        VALUES ($1, $2, $3, $4, $5, $6, $7) 
        RETURNING *`;
    const values = [user_id, complaint_id_display, category, description, priority || 'medium', image_url || null, audio_url || null];
    const result = await db.query(query, values);
    return result.rows[0];
};

exports.getAllComplaints = async (userId) => {
    let query = `SELECT * FROM complaints`;
    const values = [];
    if (userId) {
        query += ` WHERE user_id = $1`;
        values.push(userId);
    }
    query += ` ORDER BY created_at DESC`;
    const result = await db.query(query, values);
    return result.rows;
};

exports.getComplaintById = async (id) => {
    const query = `SELECT * FROM complaints WHERE id::text = $1 OR complaint_id_display = $1`;
    const result = await db.query(query, [id]);
    return result.rows[0];
};

exports.getComplaintsByUserId = async (userId) => {
    const query = `SELECT * FROM complaints WHERE user_id = $1 ORDER BY created_at DESC`;
    const result = await db.query(query, [userId]);
    return result.rows;
};

exports.updateComplaintStatus = async (id, status, admin_remarks) => {
    const query = `
        UPDATE complaints 
        SET status = $1, admin_remarks = COALESCE($2, admin_remarks), updated_at = CURRENT_TIMESTAMP 
        WHERE id = $3 
        RETURNING *`;
    const result = await db.query(query, [status, admin_remarks, id]);
    return result.rows[0];
};

exports.deleteComplaint = async (id) => {
    const query = `DELETE FROM complaints WHERE id = $1 RETURNING *`;
    const result = await db.query(query, [id]);
    return result.rows.length > 0;
};
