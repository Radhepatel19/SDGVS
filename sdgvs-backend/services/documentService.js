const db = require('../config/db');

exports.uploadDocument = async (data) => {
    const { user_id, title, type, file_path } = data;
    const query = `
        INSERT INTO user_documents (user_id, title, type, file_path) 
        VALUES ($1, $2, $3, $4) 
        RETURNING *`;
    const result = await db.query(query, [user_id, title, type, file_path]);
    return result.rows[0];
};

exports.getDocumentsByUser = async (userId) => {
    const query = `SELECT * FROM user_documents WHERE user_id = $1 ORDER BY upload_date DESC`;
    const result = await db.query(query, [userId]);
    return result.rows;
};

exports.getDocumentCountByUser = async (userId) => {
    const query = `SELECT count(*) FROM user_documents WHERE user_id = $1`;
    const result = await db.query(query, [userId]);
    return parseInt(result.rows[0].count, 10);
};

exports.getDocumentById = async (id) => {
    const query = `SELECT * FROM user_documents WHERE id = $1`;
    const result = await db.query(query, [id]);
    return result.rows[0];
};

exports.deleteDocument = async (id) => {
    const query = `DELETE FROM user_documents WHERE id = $1 RETURNING *`;
    const result = await db.query(query, [id]);
    return result.rows.length > 0;
};
