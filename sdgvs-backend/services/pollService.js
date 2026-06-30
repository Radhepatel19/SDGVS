const db = require('../config/db');

exports.createPoll = async (pollData) => {
    const { village_id, question, expiry_date, options } = pollData;
    
    // Create Poll
    const query = `
        INSERT INTO polls (village_id, question, expiry_date) 
        VALUES ($1, $2, $3) 
        RETURNING *`;
    const result = await db.query(query, [village_id, question, expiry_date]);
    const poll = result.rows[0];

    // Create Options
    const currentOptions = [];
    if (options && Array.isArray(options)) {
        for (const optionText of options) {
            const optQuery = `INSERT INTO poll_options (poll_id, option_text) VALUES ($1, $2) RETURNING *`;
            const optResult = await db.query(optQuery, [poll.id, optionText]);
            currentOptions.push(optResult.rows[0]);
        }
    }
    
    poll.options = currentOptions;
    return poll;
};

exports.getAllPolls = async (villageId, userId) => {
    let query = `SELECT * FROM polls`;
    let params = [];
    if (villageId) {
        query += ` WHERE village_id = $1`;
        params.push(villageId);
    }
    query += ` ORDER BY created_at DESC`;
    const result = await db.query(query, params);
    
    // Fetch options for each poll (with dynamic vote counts)
    for (const poll of result.rows) {
        const optQuery = `
            SELECT po.*, COUNT(uv.user_id) as votes_count
            FROM poll_options po
            LEFT JOIN user_poll_votes uv ON po.id = uv.option_id
            WHERE po.poll_id = $1
            GROUP BY po.id
            ORDER BY po.option_text ASC
        `;
        const optResult = await db.query(optQuery, [poll.id]);
        poll.options = optResult.rows;

        // Check if this user voted for this poll
        poll.user_voted_option_index = null;
        if (userId) {
            const voteQuery = `SELECT option_id FROM user_poll_votes WHERE poll_id = $1 AND user_id = $2`;
            const voteRes = await db.query(voteQuery, [poll.id, userId]);
            if (voteRes.rows.length > 0) {
                const votedOptId = voteRes.rows[0].option_id;
                const optIndex = poll.options.findIndex(o => o.id === votedOptId);
                if (optIndex !== -1) {
                    poll.user_voted_option_index = optIndex;
                }
            }
        }
    }
    return result.rows;
};

exports.getPollById = async (id, userId) => {
    const query = `SELECT * FROM polls WHERE id = $1`;
    const result = await db.query(query, [id]);
    const poll = result.rows[0];
    if (poll) {
        const optQuery = `
            SELECT po.*, COUNT(uv.user_id) as votes_count
            FROM poll_options po
            LEFT JOIN user_poll_votes uv ON po.id = uv.option_id
            WHERE po.poll_id = $1
            GROUP BY po.id
            ORDER BY po.option_text ASC
        `;
        const optResult = await db.query(optQuery, [poll.id]);
        poll.options = optResult.rows;

        poll.user_voted_option_index = null;
        if (userId) {
            const voteQuery = `SELECT option_id FROM user_poll_votes WHERE poll_id = $1 AND user_id = $2`;
            const voteRes = await db.query(voteQuery, [poll.id, userId]);
            if (voteRes.rows.length > 0) {
                const votedOptId = voteRes.rows[0].option_id;
                const optIndex = poll.options.findIndex(o => o.id === votedOptId);
                if (optIndex !== -1) {
                    poll.user_voted_option_index = optIndex;
                }
            }
        }
    }
    return poll;
};

exports.votePoll = async (pollId, optionId, userId) => {
    // Has user already voted?
    const checkQuery = `SELECT * FROM user_poll_votes WHERE poll_id = $1 AND user_id = $2`;
    const checkResult = await db.query(checkQuery, [pollId, userId]);
    
    if (checkResult.rows.length > 0) {
        throw new Error('User has already voted in this poll');
    }

    // Register vote
    const voteQuery = `INSERT INTO user_poll_votes (user_id, poll_id, option_id) VALUES ($1, $2, $3)`;
    await db.query(voteQuery, [userId, pollId, optionId]);

    // Return the updated option with full vote count dynamically
    const optQuery = `
        SELECT po.*, COUNT(uv.user_id) as votes_count
        FROM poll_options po
        LEFT JOIN user_poll_votes uv ON po.id = uv.option_id
        WHERE po.id = $1
        GROUP BY po.id
    `;
    const incResult = await db.query(optQuery, [optionId]);

    return incResult.rows[0];
};

exports.deletePoll = async (id) => {
    const query = `DELETE FROM polls WHERE id = $1 RETURNING *`;
    const result = await db.query(query, [id]);
    return result.rows.length > 0;
};

exports.addPollOption = async (pollId, optionText) => {
    const query = `INSERT INTO poll_options (poll_id, option_text) VALUES ($1, $2) RETURNING *`;
    const result = await db.query(query, [pollId, optionText]);
    return result.rows[0];
};
