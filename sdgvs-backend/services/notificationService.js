const db = require('../config/db');

exports.createNotification = async (data) => {
    const { admin_id, village_id, title, message, type } = data;
    const query = `
        INSERT INTO notifications (admin_id, village_id, title, message, type) 
        VALUES ($1, $2, $3, $4, $5) 
        RETURNING *`;
    const result = await db.query(query, [admin_id, village_id, title, message, type]);
    return result.rows[0];
};

exports.getAllNotifications = async () => {
    const query = `SELECT * FROM notifications ORDER BY created_at DESC`;
    const result = await db.query(query);
    return result.rows;
};

exports.getNotificationsByVillageId = async (villageId) => {
    const query = `SELECT * FROM notifications WHERE village_id = $1 ORDER BY created_at DESC`;
    const result = await db.query(query, [villageId]);
    return result.rows;
};

exports.deleteNotification = async (id) => {
    const query = `DELETE FROM notifications WHERE id = $1 RETURNING *`;
    const result = await db.query(query, [id]);
    return result.rows.length > 0;
};
