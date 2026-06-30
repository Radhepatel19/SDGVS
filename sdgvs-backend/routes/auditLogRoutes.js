const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const {
    createAuditLog,
    getAllAuditLogs,
    getAuditLogsByAdmin,
    deleteAuditLog
} = require('../controllers/auditLogController');

router.post('/', auth, createAuditLog);
router.get('/', auth, getAllAuditLogs);
router.get('/admin/:adminId', auth, getAuditLogsByAdmin);
router.delete('/:id', auth, deleteAuditLog);

module.exports = router;