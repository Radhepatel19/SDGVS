const db = require('../config/db');

// ==============================
// CREATE USER
// ==============================
exports.createUser = async (userData) => {
    const {
        name, mobile, email, gender, dob, address,
        village_name, village_id, taluka, district,
        occupation, profile_image_url, is_registered,
    } = userData;

    const query = `
        INSERT INTO users (
            name, mobile, email, gender, dob, address,
            village_name, village_id, taluka, district,
            occupation, profile_image_url, is_registered
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
        RETURNING *`;

    const values = [
        name, mobile, email, gender, dob, address,
        village_name, village_id, taluka, district,
        occupation, profile_image_url, is_registered ?? false,
    ];

    const result = await db.query(query, values);
    return result.rows[0];
};

// ==============================
// GET ALL USERS
// ==============================
exports.getAllUsers = async () => {
    const result = await db.query(`SELECT * FROM users ORDER BY created_at DESC`);
    return result.rows;
};

// ==============================
// GET USER BY ID
// ==============================
exports.getUserById = async (id) => {
    const result = await db.query(`SELECT * FROM users WHERE id = $1`, [id]);
    return result.rows[0];
};

// ==============================
// GET USER BY MOBILE
// ==============================
exports.getUserByMobile = async (mobile) => {
    const result = await db.query(`SELECT * FROM users WHERE mobile = $1`, [mobile]);
    return result.rows[0];
};

// ==============================
// GET USER BY EMAIL
// ==============================
exports.getUserByEmail = async (email) => {
    const result = await db.query(`SELECT * FROM users WHERE email = $1`, [email]);
    return result.rows[0];
};

// ==============================
// UPDATE USER
// ==============================
exports.updateUser = async (id, userData) => {
    const {
        name, email, gender, dob, address,
        village_name, village_id, taluka, district,
        occupation, profile_image_url, is_registered, status,
    } = userData;

    let query = `UPDATE users SET updated_at = CURRENT_TIMESTAMP`;
    const values = [];
    let i = 1;

    if (name             !== undefined) { query += `, name = $${i++}`;              values.push(name); }
    if (email            !== undefined) { query += `, email = $${i++}`;             values.push(email); }
    if (gender           !== undefined) { query += `, gender = $${i++}`;            values.push(gender); }
    if (dob              !== undefined) { query += `, dob = $${i++}`;               values.push(dob); }
    if (address          !== undefined) { query += `, address = $${i++}`;           values.push(address); }
    if (village_name     !== undefined) { query += `, village_name = $${i++}`;      values.push(village_name); }
    if (village_id       !== undefined) { query += `, village_id = $${i++}`;        values.push(village_id); }
    if (taluka           !== undefined) { query += `, taluka = $${i++}`;            values.push(taluka); }
    if (district         !== undefined) { query += `, district = $${i++}`;          values.push(district); }
    if (occupation       !== undefined) { query += `, occupation = $${i++}`;        values.push(occupation); }
    if (profile_image_url !== undefined){ query += `, profile_image_url = $${i++}`; values.push(profile_image_url); }
    if (is_registered    !== undefined) { query += `, is_registered = $${i++}`;     values.push(is_registered); }
    if (status           !== undefined) { query += `, status = $${i++}`;            values.push(status); }

    query += ` WHERE id = $${i} RETURNING *`;
    values.push(id);

    const result = await db.query(query, values);
    return result.rows[0];
};

// ==============================
// VERIFY USER (set is_verified = true)
// ==============================
exports.verifyUser = async (id) => {
    const result = await db.query(
        `UPDATE users SET is_verified = TRUE, updated_at = CURRENT_TIMESTAMP WHERE id = $1 RETURNING *`,
        [id]
    );
    return result.rows[0];
};

// ==============================
// UPDATE LAST LOGIN
// ==============================
exports.updateLastLogin = async (id) => {
    const result = await db.query(
        `UPDATE users SET last_login = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = $1 RETURNING *`,
        [id]
    );
    return result.rows[0];
};

// ==============================
// DELETE USER
// ==============================
exports.deleteUser = async (id) => {
    const result = await db.query(`DELETE FROM users WHERE id = $1 RETURNING id`, [id]);
    return result.rows.length > 0;
};
