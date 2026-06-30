const db = require('../config/db');
const newsService = require('../services/newsService');

const validCategories = ['Success Story', 'New Development', 'Scholarship Winner', 'Govt Benefit Received','Village Achievement'];

exports.createNews = async (req, res) => {
    try {
        const { title, description, category, image_url, author, village_id } = req.body;

        if (!title || !description || !category || !author) {
            return res.status(400).json({ message: "title, description, category and author are required" });
        }

        if (!validCategories.includes(category)) {
            return res.status(400).json({ message: "Invalid category (successStory, newDevelopment)" });
        }

        const newNews = await newsService.createGoodNews({
            village_id, title, description, category, image_url, author
        });

        res.status(201).json({ message: "Good news created successfully", data: newNews });
    } catch (error) {
        res.status(500).json({ message: "Error creating good news", error: error.message });
    }
};

exports.getAllNews = async (req, res) => {
    try {
        const { village_id, user_id } = req.query;
        const news = await newsService.getAllGoodNews(village_id, user_id);
        res.json(news);
    } catch (error) {
        res.status(500).json({ message: "Error fetching news", error: error.message });
    }
};

exports.getNewsById = async (req, res) => {
    try {
        const query = `SELECT * FROM good_news WHERE id = $1`;
        const result = await db.query(query, [req.params.id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ message: "News not found" });
        }
        res.json(result.rows[0]);
    } catch (error) {
        res.status(500).json({ message: "Error fetching news", error: error.message });
    }
};

exports.getNewsByCategory = async (req, res) => {
    try {
        const query = `SELECT * FROM good_news WHERE category = $1 ORDER BY created_at DESC`;
        const result = await db.query(query, [req.params.category]);
        res.json(result.rows);
    } catch (error) {
        res.status(500).json({ message: "Error fetching news by category", error: error.message });
    }
};

exports.likeNews = async (req, res) => {
    try {
        const newsId = req.params.id;
        const { user_id } = req.body;

        if (!user_id) {
            return res.status(400).json({ message: "user_id is required" });
        }

        // Check if user already liked this news
        const checkQuery = `SELECT * FROM good_news_likes WHERE user_id = $1 AND news_id = $2`;
        const existing = await db.query(checkQuery, [user_id, newsId]);

        let liked;
        if (existing.rows.length > 0) {
            // Unlike: remove from likes table and decrement counter
            await db.query(`DELETE FROM good_news_likes WHERE user_id = $1 AND news_id = $2`, [user_id, newsId]);
            await db.query(`UPDATE good_news SET likes = GREATEST(0, likes - 1) WHERE id = $1`, [newsId]);
            liked = false;
        } else {
            // Like: insert into likes table and increment counter
            await db.query(`INSERT INTO good_news_likes (user_id, news_id) VALUES ($1, $2)`, [user_id, newsId]);
            await db.query(`UPDATE good_news SET likes = likes + 1 WHERE id = $1`, [newsId]);
            liked = true;
        }

        // Get updated like count
        const result = await db.query(`SELECT likes FROM good_news WHERE id = $1`, [newsId]);
        if (result.rows.length === 0) {
            return res.status(404).json({ message: "News not found" });
        }

        res.json({
            message: liked ? "News liked successfully" : "News unliked successfully",
            liked: liked,
            likes: result.rows[0].likes
        });
    } catch (error) {
        res.status(500).json({ message: "Error updating news likes", error: error.message });
    }
};

exports.deleteNews = async (req, res) => {
    try {
        const isDeleted = await newsService.deleteGoodNews(req.params.id);
        if (!isDeleted) {
            return res.status(404).json({ message: "News not found" });
        }
        res.json({ message: "News deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting news", error: error.message });
    }
};