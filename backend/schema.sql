-- SDGVS GLOBAL SCHEMA (Synchronized with Dart Models)
-- Proper Structure for Villages, Users, Admins, Agriculture, and Community Features

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. VILLAGES (Master Scope)
CREATE TABLE villages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    taluka VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL,
    population VARCHAR(20),
    status VARCHAR(20) DEFAULT 'active', -- 'active', 'inactive'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. USERS (Gramin Users - Synchronized with UserModel.dart)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100),
    mobile VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    gender VARCHAR(20),
    dob DATE,
    address TEXT,
    village_id UUID REFERENCES villages(id) ON DELETE SET NULL,
    village_name VARCHAR(100), -- Denormalized for mobile app alignment
    taluka VARCHAR(100),
    district VARCHAR(100),
    occupation VARCHAR(100),
    is_registered BOOLEAN DEFAULT FALSE,
    is_verified BOOLEAN DEFAULT FALSE,
    status VARCHAR(20) DEFAULT 'active', -- 'active', 'inactive', 'suspended'
    profile_image_url TEXT,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. ADMINS (System & Gramin Admins)
CREATE TABLE admins (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) DEFAULT 'village_admin',
    address TEXT,
    village_id UUID REFERENCES villages(id) ON DELETE SET NULL,
    village_name VARCHAR(100), -- Denormalized for mobile app alignment
    is_first_login BOOLEAN DEFAULT TRUE, -- Force password change flow
    status VARCHAR(20) DEFAULT 'offline', -- 'online', 'offline'
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);  

-- 4. COMPLAINTS (Synchronized with ComplaintModel.dart)
CREATE TABLE complaints (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    complaint_id_display VARCHAR(50) UNIQUE NOT NULL, -- Human-readable ID (SDGVS-2024-XXX)
    category VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'medium',
    status VARCHAR(20) DEFAULT 'Pending', -- 'Pending', 'In Progress', 'Resolved'
    image_url TEXT, -- imagePath in Dart
    audio_url TEXT, -- voicePath in Dart
    admin_remarks TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. DOCUMENTS (Identity Locker - Synchronized with DocumentModel.dart)
CREATE TABLE user_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL, -- 'Aadhaar', 'PAN', etc.
    file_path TEXT NOT NULL,
    upload_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. NOTICES (Broadcasts - Synchronized with NoticeModel.dart)
CREATE TABLE notices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    admin_id UUID REFERENCES admins(id) ON DELETE SET NULL,
    village_id UUID REFERENCES villages(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(20) NOT NULL,
    priority_order INTEGER
        CHECK (priority_order BETWEEN 1 AND 10),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (village_id, priority_order)
);
-- 7. NOTIFICATIONS (Pushes from Admins to Villages)
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    admin_id UUID REFERENCES admins(id) ON DELETE CASCADE,
    village_id UUID REFERENCES villages(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(20) NOT NULL, -- 'complaint', 'scheme', 'announcement'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE
);

-- 8. SCHEMES (Welfare Hub - Synchronized with SchemeModel.dart)
CREATE TABLE schemes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(200) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    objectives TEXT[],
    eligibility TEXT[],
    benefits TEXT[],
    documents_required TEXT[],
    url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 9. POLLS & VOTING (Synchronized with PollModel.dart)
CREATE TABLE polls (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    village_id UUID REFERENCES villages(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    expiry_date TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE poll_options (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    poll_id UUID REFERENCES polls(id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    UNIQUE (poll_id, option_text)
);

CREATE TABLE user_poll_votes (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    poll_id UUID REFERENCES polls(id) ON DELETE CASCADE,
    option_id UUID REFERENCES poll_options(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, poll_id)
);

-- 10. AGRICULTURE & ADVISORY (Farmer Advisory Hub)
CREATE TABLE crop_calendar (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    village_id UUID REFERENCES villages(id) ON DELETE CASCADE,
    crop_name VARCHAR(100) NOT NULL,
    season VARCHAR(50) NOT NULL,
    current_stage VARCHAR(50),
    recommended_dates VARCHAR(100),
    current_status VARCHAR(50),
    sowing_period VARCHAR(50),
    duration VARCHAR(50),
    harvest_period VARCHAR(50),
    best_soil VARCHAR(100),
    water_requirement VARCHAR(50),
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE mandi_prices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    village_id UUID REFERENCES villages(id) ON DELETE CASCADE,
    crop_name VARCHAR(100) NOT NULL,
    mandi_name VARCHAR(100) NOT NULL,
    price_min DECIMAL(10, 2),
    price_max DECIMAL(10, 2),
    price_avg DECIMAL(10, 2) NOT NULL,
    unit VARCHAR(20) DEFAULT 'Quintal',
    price_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'stable', -- 'up', 'down', 'stable'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE agri_resources (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    village_id UUID REFERENCES villages(id) ON DELETE CASCADE,
    resource_name VARCHAR(100) NOT NULL,
    availability_percentage INTEGER CHECK (availability_percentage >= 0 AND availability_percentage <= 100),
    status_color VARCHAR(20) DEFAULT 'green', -- 'green', 'red', 'orange'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE weather_alerts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    village_id UUID REFERENCES villages(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    alert_level VARCHAR(20) DEFAULT 'info',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE agri_notices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    village_id UUID REFERENCES villages(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 11. COMMUNITY & NEWS (Good News Feed - Synchronized with GoodNewsItem)
CREATE TABLE good_news (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    village_id UUID REFERENCES villages(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(50) NOT NULL,
    image_url TEXT,
    author VARCHAR(100) NOT NULL,
    likes INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 11b. GOOD NEWS LIKES (Per-user like tracking)
CREATE TABLE good_news_likes (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    news_id UUID REFERENCES good_news(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, news_id)
);

CREATE INDEX idx_good_news_likes_news_id ON good_news_likes(news_id);

-- 12. IMPACT & REWARDS (Synchronized with ImpactModel.dart)
CREATE TABLE user_impact_stats (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    complaints_resolved INTEGER DEFAULT 0,
    schemes_applied INTEGER DEFAULT 0,
    contribution_hours INTEGER DEFAULT 0,
    community_impact_score INTEGER DEFAULT 0,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_badges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    admin_id UUID REFERENCES admins(id) ON DELETE SET NULL, -- Admin who issued the badge
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    date_earned TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 12. IMPACT & REWARDS (Synchronized with CertificateModel.dart)
CREATE TABLE user_certificates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    admin_id UUID REFERENCES admins(id) ON DELETE SET NULL, -- Admin who decided/issued
    village_id UUID REFERENCES villages(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL, -- Recipient name (denormalized)
    village_name VARCHAR(100), -- Village name (denormalized)
    category VARCHAR(50) NOT NULL,
    year VARCHAR(10) NOT NULL,
    achievement TEXT NOT NULL,
    date_awarded TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, category, year) -- Ensure one per category per year
);

-- 13. EMERGENCY SERVICES
CREATE TABLE emergency_services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    village_id UUID REFERENCES villages(id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    category VARCHAR(100),
    description TEXT, -- Maps to 'desc' in Flutter
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 14. SYSTEM & FEEDBACK
CREATE TABLE feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    complaint_id UUID REFERENCES complaints(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comments TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    admin_id UUID REFERENCES admins(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(50),
    record_id UUID,
    details JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE app_settings (
    key VARCHAR(100) PRIMARY KEY,
    value TEXT NOT NULL,
    description TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


-- INDEXES
CREATE INDEX idx_users_mobile ON users(mobile);
CREATE INDEX idx_users_village_id ON users(village_id);
CREATE INDEX idx_admins_village_id ON admins(village_id);
CREATE INDEX idx_complaints_user_id ON complaints(user_id);
CREATE INDEX idx_notices_village_id ON notices(village_id);
CREATE INDEX idx_notifications_village_id ON notifications(village_id);
CREATE INDEX idx_crop_calendar_village_id ON crop_calendar(village_id);
CREATE INDEX idx_good_news_village_id ON good_news(village_id);
CREATE INDEX idx_reward_winners_village_id ON reward_winners(village_id);
CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token);

-- TRIGGERS
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
CREATE TRIGGER update_admins_updated_at BEFORE UPDATE ON admins FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
CREATE TRIGGER update_complaints_updated_at BEFORE UPDATE ON complaints FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
CREATE TRIGGER update_villages_updated_at BEFORE UPDATE ON villages FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
CREATE TRIGGER update_crop_calendar_updated_at BEFORE UPDATE ON crop_calendar FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
CREATE TRIGGER update_impact_stats_updated_at BEFORE UPDATE ON user_impact_stats FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
