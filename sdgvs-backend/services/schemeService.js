const db = require('../config/db');

exports.createScheme = async (schemeData) => {
    const { title, category, description, objectives, eligibility, benefits, documents_required } = schemeData;
    const query = `
        INSERT INTO schemes (title, category, description, objectives, eligibility, benefits, documents_required) 
        VALUES ($1, $2, $3, $4, $5, $6, $7) 
        RETURNING *`;
    const values = [
        title, 
        category, 
        description, 
        objectives || [], 
        eligibility || [], 
        benefits || [], 
        documents_required || []
    ];
    const result = await db.query(query, values);
    return result.rows[0];
};

exports.getAllSchemes = async () => {
    const query = `SELECT * FROM schemes`;
    const result = await db.query(query);
    return result.rows;
};

exports.getSchemeById = async (id) => {
    const query = `SELECT * FROM schemes WHERE id = $1`;
    const result = await db.query(query, [id]);
    return result.rows[0];
};

exports.getSchemesByCategory = async (category) => {
    const query = `SELECT * FROM schemes WHERE category = $1`;
    const result = await db.query(query, [category]);
    return result.rows;
};

exports.updateScheme = async (id, schemeData) => {
    const { title, category, description, objectives, eligibility, benefits, documents_required } = schemeData;
    let query = `UPDATE schemes SET `;
    const values = [];
    let counter = 1;

    if (title !== undefined) { query += `title = $${counter++}, `; values.push(title); }
    if (category !== undefined) { query += `category = $${counter++}, `; values.push(category); }
    if (description !== undefined) { query += `description = $${counter++}, `; values.push(description); }
    if (objectives !== undefined) { query += `objectives = $${counter++}, `; values.push(objectives); }
    if (eligibility !== undefined) { query += `eligibility = $${counter++}, `; values.push(eligibility); }
    if (benefits !== undefined) { query += `benefits = $${counter++}, `; values.push(benefits); }
    if (documents_required !== undefined) { query += `documents_required = $${counter++}, `; values.push(documents_required); }

    // Remove trailing comma
    query = query.replace(/, $/, ' ');
    query += ` WHERE id = $${counter} RETURNING *`;
    values.push(id);

    const result = await db.query(query, values);
    return result.rows[0];
};

exports.deleteScheme = async (id) => {
    const query = `DELETE FROM schemes WHERE id = $1 RETURNING *`;
    const result = await db.query(query, [id]);
    return result.rows.length > 0;
};

exports.getUniqueCategories = async () => {
    const query = `SELECT DISTINCT category FROM schemes ORDER BY category ASC`;
    const result = await db.query(query);
    return result.rows.map(row => row.category);
};
