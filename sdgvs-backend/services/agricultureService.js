const db = require('../config/db');

exports.createCropCalendar = async (data) => {
    const { village_id, crop_name, season, current_stage, recommended_dates, current_status, sowing_period, duration, harvest_period, best_soil, water_requirement, description } = data;
    const query = `
        INSERT INTO crop_calendar (village_id, crop_name, season, current_stage, recommended_dates, current_status, sowing_period, duration, harvest_period, best_soil, water_requirement, description) 
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) 
        RETURNING *`;
    const values = [village_id, crop_name, season, current_stage, recommended_dates, current_status, sowing_period, duration, harvest_period, best_soil, water_requirement, description];
    const result = await db.query(query, values);
    return result.rows[0];
};

exports.getAllCropCalendars = async (villageId) => {
    let query = `SELECT * FROM crop_calendar`;
    let values = [];
    if (villageId) {
        query += ` WHERE village_id = $1`;
        values.push(villageId);
    }
    query += ` ORDER BY created_at DESC`;
    const result = await db.query(query, values);
    return result.rows;
};

exports.deleteCropCalendar = async (id) => {
    const query = `DELETE FROM crop_calendar WHERE id = $1 RETURNING *`;
    const result = await db.query(query, [id]);
    return result.rows.length > 0;
};

exports.updateCropCalendar = async (id, data) => {
    const {
        crop_name, season, current_stage, sowing_period, harvest_period,
        duration, best_soil, water_requirement, description,
        recommended_dates, current_status
    } = data;

    const query = `
        UPDATE crop_calendar SET
            crop_name         = COALESCE($1,  crop_name),
            season            = COALESCE($2,  season),
            current_stage     = COALESCE($3,  current_stage),
            sowing_period     = COALESCE($4,  sowing_period),
            harvest_period    = COALESCE($5,  harvest_period),
            duration          = COALESCE($6,  duration),
            best_soil         = COALESCE($7,  best_soil),
            water_requirement = COALESCE($8,  water_requirement),
            description       = COALESCE($9,  description),
            recommended_dates = COALESCE($10, recommended_dates),
            current_status    = COALESCE($11, current_status),
            updated_at        = CURRENT_TIMESTAMP
        WHERE id = $12
        RETURNING *`;

    const values = [
        crop_name, season, current_stage, sowing_period, harvest_period,
        duration, best_soil, water_requirement, description,
        recommended_dates, current_status, id
    ];

    const result = await db.query(query, values);
    return result.rows[0] || null;
};


exports.createAgriResource = async (data) => {
    const { village_id, resource_name, availability_percentage, status_color } = data;
    const query = `
        INSERT INTO agri_resources (village_id, resource_name, availability_percentage, status_color) 
        VALUES ($1, $2, $3, $4) 
        RETURNING *`;
    const result = await db.query(query, [village_id, resource_name, availability_percentage, status_color || 'green']);
    return result.rows[0];
};

exports.getAllAgriResources = async (villageId) => {
    let query = `SELECT * FROM agri_resources`;
    let values = [];
    if (villageId) {
        query += ` WHERE village_id = $1`;
        values.push(villageId);
    }
    query += ` ORDER BY created_at DESC`;
    const result = await db.query(query, values);
    return result.rows;
};

exports.deleteAgriResource = async (id) => {
    const query = `DELETE FROM agri_resources WHERE id = $1 RETURNING *`;
    const result = await db.query(query, [id]);
    return result.rows.length > 0;
};

exports.createAgriNotice = async (data) => {
    const { village_id, title, message } = data;
    const query = `
        INSERT INTO agri_notices (village_id, title, message) 
        VALUES ($1, $2, $3) 
        RETURNING *`;
    const result = await db.query(query, [village_id, title, message]);
    return result.rows[0];
};

exports.getAllAgriNotices = async (villageId) => {
    let query = `SELECT * FROM agri_notices`;
    let values = [];
    if (villageId) {
        query += ` WHERE village_id = $1`;
        values.push(villageId);
    }
    query += ` ORDER BY created_at DESC`;
    const result = await db.query(query, values);
    return result.rows;
};

exports.deleteAgriNotice = async (id) => {
    const query = `DELETE FROM agri_notices WHERE id = $1 RETURNING *`;
    const result = await db.query(query, [id]);
    return result.rows.length > 0;
};
