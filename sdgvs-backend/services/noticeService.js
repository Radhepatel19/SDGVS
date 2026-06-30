const db = require('../config/db');

exports.createNotice = async (noticeData) => {
    const { admin_id, village_id, title, message, type, is_high_priority } = noticeData;
    const query = `
        INSERT INTO notices (admin_id, village_id, title, message, type, is_high_priority) 
        VALUES ($1, $2, $3, $4, $5, $6) 
        RETURNING *`;
    const values = [admin_id, village_id, title, message, type, is_high_priority || false];
    const result = await db.query(query, values);
    return result.rows[0];
};

exports.getAllNotices = async () => {
    const query = `SELECT * FROM notices ORDER BY created_at DESC`;
    const result = await db.query(query);
    return result.rows;
};

exports.getNoticeById = async (id) => {
    const query = `SELECT * FROM notices WHERE id = $1`;
    const result = await db.query(query, [id]);
    return result.rows[0];
};

exports.getNoticesByVillageId = async (villageId) => {
    const query = `SELECT * FROM notices WHERE village_id = $1 ORDER BY created_at DESC`;
    const result = await db.query(query, [villageId]);
    return result.rows;
};

exports.updateNotice = async (id, noticeData) => {
    const { title, message, type, is_high_priority } = noticeData;
    const query = `
        UPDATE notices 
        SET 
            title = COALESCE($1, title),
            message = COALESCE($2, message),
            type = COALESCE($3, type),
            is_high_priority = COALESCE($4, is_high_priority)
        WHERE id = $5 
        RETURNING *`;
    const values = [title, message, type, is_high_priority, id];
    const result = await db.query(query, values);
    return result.rows[0];
};

exports.deleteNotice = async (id) => {
    const query = `DELETE FROM notices WHERE id = $1 RETURNING *`;
    const result = await db.query(query, [id]);
    return result.rows.length > 0;
};
