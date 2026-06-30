const db = require('../config/db');

exports.createVillage = async (villageData) => {
    const { name, taluka, district, population, status } = villageData;
    const query = `
        INSERT INTO villages (name, taluka, district, population, status) 
        VALUES ($1, $2, $3, $4, $5) 
        RETURNING *`;
    const values = [name, taluka, district, population || null, status || 'active'];
    const result = await db.query(query, values);
    return result.rows[0];
};

exports.getAllVillages = async () => {
    const query = `SELECT * FROM villages`;
    const result = await db.query(query);
    return result.rows;
};

exports.getVillageById = async (id) => {
    const query = `SELECT * FROM villages WHERE id = $1`;
    const result = await db.query(query, [id]);
    return result.rows[0];
};

exports.getVillageByName = async (name) => {
    const query = `SELECT * FROM villages WHERE LOWER(name) = LOWER($1)`;
    const result = await db.query(query, [name]);
    return result.rows[0];
};

exports.getVillageByNameAndTaluka = async (name, taluka) => {
    const query = `SELECT * FROM villages WHERE LOWER(name) = LOWER($1) AND LOWER(taluka) = LOWER($2)`;
    const result = await db.query(query, [name, taluka]);
    return result.rows[0];
};

exports.updateVillage = async (id, villageData) => {
    const { name, taluka, district, population, status } = villageData;
    const query = `
        UPDATE villages 
        SET 
            name = COALESCE($1, name),
            taluka = COALESCE($2, taluka),
            district = COALESCE($3, district),
            population = COALESCE($4, population),
            status = COALESCE($5, status),
            updated_at = CURRENT_TIMESTAMP
        WHERE id = $6 
        RETURNING *`;
    const values = [name, taluka, district, population, status, id];
    const result = await db.query(query, values);
    return result.rows[0];
};

exports.deleteVillage = async (id) => {
    const query = `DELETE FROM villages WHERE id = $1 RETURNING *`;
    const result = await db.query(query, [id]);
    return result.rows.length > 0;
};
