const db = require('../config/db');

const calculateImpactScore = (stats) => {
    return (
        (stats.complaints_resolved * 10) +
        (stats.schemes_applied * 5) +
        (stats.contribution_hours * 5)
    );
};
exports.calculateImpactScore = calculateImpactScore;


exports.getImpactStats = async (userId) => {
    const query = `SELECT * FROM user_impact_stats WHERE user_id = $1`;
    const result = await db.query(query, [userId]);
    return result.rows[0];
};

exports.updateImpactStats = async (userId, data) => {
    const { complaints_resolved, schemes_applied, contribution_hours, community_impact_score } = data;
    const query = `
        INSERT INTO user_impact_stats (user_id, complaints_resolved, schemes_applied, contribution_hours, community_impact_score) 
        VALUES ($1, $2, $3, $4, $5)
        ON CONFLICT (user_id) 
        DO UPDATE SET 
            complaints_resolved = EXCLUDED.complaints_resolved,
            schemes_applied = EXCLUDED.schemes_applied,
            contribution_hours = EXCLUDED.contribution_hours,
            community_impact_score = EXCLUDED.community_impact_score,
            updated_at = CURRENT_TIMESTAMP
        RETURNING *`;
    const result = await db.query(query, [userId, complaints_resolved, schemes_applied, contribution_hours, community_impact_score]);
    return result.rows[0];
};

exports.addBadge = async (userId, data) => {
    const { name, description, admin_id } = data;
    const query = `
        INSERT INTO user_badges (user_id, admin_id, name, description) 
        VALUES ($1, $2, $3, $4) 
        RETURNING *`;
    const result = await db.query(query, [userId, admin_id, name, description]);
    return result.rows[0];
};

exports.getUserBadges = async (userId) => {
    const query = `SELECT * FROM user_badges WHERE user_id = $1 ORDER BY date_earned DESC`;
    const result = await db.query(query, [userId]);
    return result.rows;
};

exports.addRewardWinner = async (data) => {
    const { user_id, admin_id, name, village_id, category, year, certificate_url, achievement } = data;
    const query = `
        INSERT INTO user_certificates (user_id, admin_id, name, village_id, category, year, certificate_url, achievement) 
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8) 
        RETURNING *`;
    const result = await db.query(query, [user_id, admin_id, name, village_id, category, year, certificate_url, achievement]);
    return result.rows[0];
};

exports.getRewardWinners = async (villageId) => {
    let query = `SELECT * FROM user_certificates`;
    const params = [];

    if (villageId) {
        query += ` WHERE village_id = $1`;
        params.push(villageId);
    }

    query += ` ORDER BY date_awarded DESC`;
    const result = await db.query(query, params);
    return result.rows;
};

exports.updateRewardWinner = async (id, data) => {
    const { name, village_id, village_name, category, year, certificate_url, achievement } = data;
    const query = `
        UPDATE user_certificates SET 
            name = COALESCE($1, name),
            village_id = COALESCE($2, village_id),
            village_name = COALESCE($3, village_name),
            category = COALESCE($4, category),
            year = COALESCE($5, year),
            certificate_url = COALESCE($6, certificate_url),
            achievement = COALESCE($7, achievement)
        WHERE id = $8 RETURNING *`;
    const result = await db.query(query, [name, village_id, village_name, category, year, certificate_url, achievement, id]);
    return result.rows[0];
};

exports.deleteRewardWinner = async (id) => {
    const query = `DELETE FROM user_certificates WHERE id = $1 RETURNING *`;
    const result = await db.query(query, [id]);
    return result.rows.length > 0;
};

exports.getLeaderboard = async (villageId, occupation) => {
    let query = `
        SELECT 
            u.id as "userId", 
            u.name as "userName", 
            u.profile_image_url as "profileImageUrl",
            u.occupation,
            s.complaints_resolved,
            s.schemes_applied,
            s.contribution_hours,
            s.community_impact_score as points
        FROM user_impact_stats s
        JOIN users u ON s.user_id = u.id
        WHERE 1=1
    `;
    const params = [];

    if (villageId) {
        params.push(villageId);
        query += ` AND u.village_id = $${params.length}`;
    }

    if (occupation) {
        params.push(`%${occupation}%`);
        query += ` AND u.occupation ILIKE $${params.length}`;
    }

    query += ` ORDER BY s.community_impact_score DESC LIMIT 8`;

    const result = await db.query(query, params);

    return result.rows.map((row, index) => ({
        ...row,
        rank: index + 1
    }));
};

exports.incrementImpactStat = async (userId, field, increment = 1) => {
    const currentStats = await exports.getImpactStats(userId) || {
        complaints_resolved: 0,
        schemes_applied: 0,
        contribution_hours: 0
    };

    const updatedData = {
        complaints_resolved: Number(currentStats.complaints_resolved || 0),
        schemes_applied: Number(currentStats.schemes_applied || 0),
        contribution_hours: Number(currentStats.contribution_hours || 0),
    };

    if (field === 'complaints_resolved') updatedData.complaints_resolved += increment;
    if (field === 'schemes_applied') updatedData.schemes_applied += increment;
    if (field === 'contribution_hours') updatedData.contribution_hours += increment;

    updatedData.community_impact_score = calculateImpactScore(updatedData);
    return await exports.updateImpactStats(userId, updatedData);
};

