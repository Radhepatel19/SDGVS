const db = require('../config/db');

exports.createEmergencyService = async (data) => {
    const { village_id, title, contact_number, category } = data;
    const query = `
        INSERT INTO emergency_services (village_id, title, contact_number, category) 
        VALUES ($1, $2, $3, $4) 
        RETURNING *`;
    const result = await db.query(query, [village_id, title, contact_number, category]);
    return result.rows[0];
};

exports.getAllEmergencyServices = async () => {
    const query = `SELECT * FROM emergency_services ORDER BY created_at DESC`;
    const result = await db.query(query);
    return result.rows;
};

exports.getEmergencyServicesByVillage = async (villageId) => {
    const query = `SELECT * FROM emergency_services WHERE village_id = $1 ORDER BY created_at DESC`;
    const result = await db.query(query, [villageId]);
    return result.rows;
};

exports.getEmergencyServiceById = async (id) => {
    const query = `SELECT * FROM emergency_services WHERE id = $1`;
    const result = await db.query(query, [id]);
    return result.rows[0];
};

exports.updateEmergencyService = async (id, data) => {
    const { title, contact_number, category, description } = data;
    const query = `
        UPDATE emergency_services 
        SET title = $1, contact_number = $2, category = $3, description = $4, updated_at = CURRENT_TIMESTAMP
        WHERE id = $5 
        RETURNING *`;
    const result = await db.query(query, [title, contact_number, category, description, id]);
    return result.rows[0];
};

exports.deleteEmergencyService = async (id) => {
    const query = `DELETE FROM emergency_services WHERE id = $1 RETURNING *`;
    const result = await db.query(query, [id]);
    return result.rows.length > 0;
};
