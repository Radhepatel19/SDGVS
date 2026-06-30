const db = require('../config/db');

exports.getSettingByKey = async (key) => {
    const query = `SELECT * FROM app_settings WHERE key = $1`;
    const result = await db.query(query, [key]);
    return result.rows[0];
};

exports.upsertSetting = async (data) => {
    const { key, value, description } = data;
    const query = `
        INSERT INTO app_settings (key, value, description)
        VALUES ($1, $2, $3)
        ON CONFLICT (key) 
        DO UPDATE SET 
            value = EXCLUDED.value,
            description = COALESCE(EXCLUDED.description, app_settings.description),
            updated_at = CURRENT_TIMESTAMP
        RETURNING *`;
    const result = await db.query(query, [key, value, description]);
    return result.rows[0];
};

exports.getAllSettings = async () => {
    const query = `SELECT * FROM app_settings ORDER BY key ASC`;
    const result = await db.query(query);
    return result.rows;
};

exports.deleteSetting = async (key) => {
    const query = `DELETE FROM app_settings WHERE key = $1 RETURNING *`;
    const result = await db.query(query, [key]);
    return result.rows.length > 0;
};

exports.createAuditLog = async (data) => {
    const { admin_id, action, target_type, target_id, details } = data;
    const query = `
        INSERT INTO audit_logs (admin_id, action, target_type, target_id, details) 
        VALUES ($1, $2, $3, $4, $5) 
        RETURNING *`;
    const result = await db.query(query, [admin_id, action, target_type, target_id, details]);
    return result.rows[0];
};

exports.getAuditLogs = async () => {
    const query = `SELECT * FROM audit_logs ORDER BY created_at DESC LIMIT 100`;
    const result = await db.query(query);
    return result.rows;
};
