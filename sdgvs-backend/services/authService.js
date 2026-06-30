const db = require('../config/db');

// ==============================
// ADMIN QUERIES
// ==============================
exports.getAdminByEmail = async (email) => {
    const query = `SELECT * FROM admins WHERE email = $1`;
    const result = await db.query(query, [email]);
    return result.rows[0];
};

exports.updateAdminStatus = async (id, status, lastLogin) => {
    const query = `UPDATE admins SET status = $1, last_login = $2 WHERE id = $3 RETURNING *`;
    const result = await db.query(query, [status, lastLogin, id]);
    return result.rows[0];
};

// ==============================
// USER QUERIES
// ==============================
exports.getUserByMobile = async (mobile) => {
    const query = `SELECT * FROM users WHERE mobile = $1`;
    const result = await db.query(query, [mobile]);
    return result.rows[0];
};

exports.updateUserLastLogin = async (id, lastLogin) => {
    const query = `UPDATE users SET last_login = $1 WHERE id = $2 RETURNING *`;
    const result = await db.query(query, [lastLogin, id]);
    return result.rows[0];
};
