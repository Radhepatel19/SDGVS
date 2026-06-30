require('dotenv').config();
const express = require('express');
const cors = require('cors');

const villageRoutes = require('./routes/villageRoutes');
const userRoutes = require('./routes/userRoutes');
const adminRoutes = require('./routes/adminRoutes');
const complaintRoutes = require('./routes/complaintRoutes');
const userDocumentRoutes = require('./routes/userDocumentRoutes');
const noticeRoutes = require('./routes/noticeRoutes');
const schemeRoutes = require('./routes/schemeRoutes');
const pollRoutes = require('./routes/pollRoutes');
const pollOptionRoutes = require('./routes/pollOptionRoutes');
const userPollVoteRoutes = require('./routes/userPollVoteRoutes');
const notificationRoutes = require('./routes/notificationRoutes');
const feedbackRoutes = require('./routes/feedbackRoutes');
const emergencyServiceRoutes = require('./routes/emergencyServiceRoutes');
const weatherAlertRoutes = require('./routes/weatherAlertRoutes');
const cropCalendarRoutes = require('./routes/cropCalendarRoutes');
const mandiPriceRoutes = require('./routes/mandiPriceRoutes');
const agriResourceRoutes = require('./routes/agriResourceRoutes');
const agriNoticeRoutes = require('./routes/agriNoticeRoutes');
const goodNewsRoutes = require('./routes/goodNewsRoutes');
const rewardWinnerRoutes = require('./routes/rewardWinnerRoutes');
const userImpactRoutes = require('./routes/userImpactRoutes');
const userBadgeRoutes = require('./routes/userBadgeRoutes');
const auditLogRoutes = require('./routes/auditLogRoutes');
const appSettingsRoutes = require('./routes/appSettingsRoutes');
const loginScreenRoutes = require('./routes/loginScreenRoutes');
const authRoutes = require('./routes/authRoutes');

const app = express();


app.use(cors());
app.use(express.json());


app.use('/api/villages', villageRoutes);
app.use('/api/users', userRoutes);
app.use('/api/admins', adminRoutes);
app.use('/api/complaints', complaintRoutes);
app.use('/api/user-documents', userDocumentRoutes);
app.use('/api/notices', noticeRoutes);
app.use('/api/schemes', schemeRoutes);
app.use('/api/polls', pollRoutes);
app.use('/api/poll-options', pollOptionRoutes);
app.use('/api/poll-votes', userPollVoteRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/feedback', feedbackRoutes);
app.use('/api/emergency-services', emergencyServiceRoutes);
app.use('/api/weather-alerts', weatherAlertRoutes);
app.use('/api/crop-calendar', cropCalendarRoutes);
app.use('/api/mandi-prices', mandiPriceRoutes);
app.use('/api/agri-resources', agriResourceRoutes);
app.use('/api/agri-notices', agriNoticeRoutes);
app.use('/api/good-news', goodNewsRoutes);
app.use('/api/certificates', rewardWinnerRoutes);
app.use('/api/user-impact', userImpactRoutes);
app.use('/api/user-badges', userBadgeRoutes);
app.use('/api/audit-logs', auditLogRoutes);
app.use('/api/app-settings', appSettingsRoutes);
app.use('/api/login-screen', loginScreenRoutes);
app.use('/api/auth', authRoutes);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});