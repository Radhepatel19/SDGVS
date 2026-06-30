const db = require('../config/db');

exports.createWeatherAlert = async (data) => {
    const { village_id, title, message, alert_level, expires_at } = data;
    const query = `
        INSERT INTO weather_alerts (village_id, title, message, alert_level, expires_at) 
        VALUES ($1, $2, $3, $4, $5) 
        RETURNING *`;
    const result = await db.query(query, [village_id, title, message, alert_level, expires_at]);
    return result.rows[0];
};

exports.getAllWeatherAlerts = async (villageId) => {
    let query = `SELECT * FROM weather_alerts`;
    let values = [];
    if (villageId) {
        query += ` WHERE village_id = $1`;
        values.push(villageId);
    }
    query += ` ORDER BY created_at DESC`;
    const result = await db.query(query, values);
    return result.rows;
};

exports.getActiveWeatherAlerts = async (villageId) => {
    let query = `SELECT * FROM weather_alerts WHERE (expires_at IS NULL OR expires_at > CURRENT_TIMESTAMP)`;
    let values = [];
    if (villageId) {
        query += ` AND village_id = $1`;
        values.push(villageId);
    }
    query += ` ORDER BY created_at DESC`;
    const result = await db.query(query, values);
    return result.rows;
};

exports.getWeatherAlertsByLevel = async (level) => {
    const query = `SELECT * FROM weather_alerts WHERE alert_level = $1 ORDER BY created_at DESC`;
    const result = await db.query(query, [level]);
    return result.rows;
};

exports.deleteWeatherAlert = async (id) => {
    const query = `DELETE FROM weather_alerts WHERE id = $1 RETURNING *`;
    const result = await db.query(query, [id]);
    return result.rows.length > 0;
};
