const { updateImpactStats, getImpactStats, getLeaderboard, calculateImpactScore } = require('../services/rewardService');

// calculateImpactScore moved to rewardService.js


exports.initializeStats = async (req, res) => {
    try {
        const userId = req.params.userId;
        const newStats = await updateImpactStats(userId, {
            complaints_resolved: 0,
            schemes_applied: 0,
            contribution_hours: 0,
            community_impact_score: 0
        });
        res.status(201).json({ message: "User impact stats initialized", data: newStats });
    } catch (error) {
        res.status(500).json({ message: "Error initializing stats", error: error.message });
    }
};

exports.getUserStats = async (req, res) => {
    try {
        const userId = req.params.userId;
        let stats = await getImpactStats(userId);
        if (!stats) {
            // Auto-initialize stats for user
            stats = await updateImpactStats(userId, {
                complaints_resolved: 0,
                schemes_applied: 0,
                contribution_hours: 0,
                community_impact_score: 0
            });
        }
        res.json(stats);
    } catch (error) {
        res.status(500).json({ message: "Error fetching stats", error: error.message });
    }
};

exports.updateStats = async (req, res) => {
    try {
        const userId = req.params.userId;
        const currentStats = await getImpactStats(userId) || { complaints_resolved: 0, schemes_applied: 0, contribution_hours: 0 };
        
        const { complaints_resolved, schemes_applied, contribution_hours } = req.body;
        
        const updatedData = {
            complaints_resolved: complaints_resolved !== undefined ? complaints_resolved : currentStats.complaints_resolved,
            schemes_applied: schemes_applied !== undefined ? schemes_applied : currentStats.schemes_applied,
            contribution_hours: contribution_hours !== undefined ? contribution_hours : currentStats.contribution_hours,
        };
        
        updatedData.community_impact_score = calculateImpactScore(updatedData);
        const savedStats = await updateImpactStats(userId, updatedData);
        
        res.json({ message: "Stats updated successfully", data: savedStats });
    } catch (error) {
        res.status(500).json({ message: "Error updating stats", error: error.message });
    }
};

exports.incrementStats = async (req, res) => {
    try {
        const userId = req.params.userId;
        const currentStats = await getImpactStats(userId) || { complaints_resolved: 0, schemes_applied: 0, contribution_hours: 0 };
        
        const { complaints_resolved = 0, schemes_applied = 0, contribution_hours = 0 } = req.body;
        
        const updatedData = {
            complaints_resolved: currentStats.complaints_resolved + complaints_resolved,
            schemes_applied: currentStats.schemes_applied + schemes_applied,
            contribution_hours: currentStats.contribution_hours + contribution_hours,
        };
        
        updatedData.community_impact_score = calculateImpactScore(updatedData);
        const savedStats = await updateImpactStats(userId, updatedData);
        
        res.json({ message: "Stats incremented successfully", data: savedStats });
    } catch (error) {
        res.status(500).json({ message: "Error incrementing stats", error: error.message });
    }
};

exports.getLeaderboard = async (req, res) => {
    try {
        const { villageId, occupation } = req.query;
        const leaderboard = await getLeaderboard(villageId, occupation);
        res.json(leaderboard);
    } catch (error) {
        res.status(500).json({ message: "Error fetching leaderboard", error: error.message });
    }
};