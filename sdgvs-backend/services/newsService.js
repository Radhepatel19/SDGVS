const db = require('../config/db');

exports.createGoodNews = async (data) => {
    const { village_id, title, description, category, image_url, author } = data;
    const query = `
        INSERT INTO good_news (village_id, title, description, category, image_url, author) 
        VALUES ($1, $2, $3, $4, $5, $6) 
        RETURNING *`;
    const result = await db.query(query, [village_id, title, description, category, image_url, author]);
    return result.rows[0];
};

exports.getAllGoodNews = async (villageId, userId) => {
    let query;
    let params = [];
    let paramIndex = 1;

    if (userId) {
        // Include user_liked field via LEFT JOIN
        query = `
            SELECT gn.*, 
                   CASE WHEN gnl.user_id IS NOT NULL THEN true ELSE false END AS user_liked
            FROM good_news gn
            LEFT JOIN good_news_likes gnl ON gn.id = gnl.news_id AND gnl.user_id = $${paramIndex}`;
        params.push(userId);
        paramIndex++;
    } else {
        query = `SELECT *, false AS user_liked FROM good_news gn`;
    }

    if (villageId) {
        query += ` WHERE gn.village_id = $${paramIndex}`;
        params.push(villageId);
        paramIndex++;
    }

    query += ` ORDER BY gn.likes DESC, gn.created_at DESC`;
    const result = await db.query(query, params);
    return result.rows;
};

exports.deleteGoodNews = async (id) => {
    const query = `DELETE FROM good_news WHERE id = $1 RETURNING *`;
    const result = await db.query(query, [id]);
    return result.rows.length > 0;
};
