const db = require('../config/db');

exports.createMandiPrice = async (data) => {
    const { 
        village_id, crop_name, mandi_name, price_min, price_max, 
        price_avg, unit, price_date, status 
    } = data;
    const query = `
        INSERT INTO mandi_prices (
            village_id, crop_name, mandi_name, price_min, 
            price_max, price_avg, unit, price_date, status
        ) 
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) 
        RETURNING *`;
    const result = await db.query(query, [
        village_id, crop_name, mandi_name, price_min, 
        price_max, price_avg, unit, price_date || new Date(), 
        status || 'stable'
    ]);
    return result.rows[0];
};

exports.getAllMandiPrices = async (villageId) => {
    let query = `SELECT * FROM mandi_prices`;
    let values = [];
    if (villageId) {
        query += ` WHERE village_id = $1`;
        values.push(villageId);
    }
    query += ` ORDER BY created_at DESC`;
    const result = await db.query(query, values);
    return result.rows;
};

exports.deleteMandiPrice = async (id) => {
    const query = `DELETE FROM mandi_prices WHERE id = $1 RETURNING *`;
    const result = await db.query(query, [id]);
    return result.rows.length > 0;
};
