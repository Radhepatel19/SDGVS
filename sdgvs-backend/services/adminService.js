const db = require('../config/db');

exports.getAdminByVillageId = async (villageId) => {
    const query = `SELECT id, name, email, role, village_id, address, status FROM admins WHERE village_id = $1 LIMIT 1`;
    const result = await db.query(query, [villageId]);
    return result.rows[0];
};
