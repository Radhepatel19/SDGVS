-- DUMMY INSERTS FOR SDGVS UI PRESENTATION
-- Note: These queries assume there is at least one village existing in your database.

-- 1. Good News Feed Inserts
INSERT INTO good_news (village_id, title, description, category, author, likes)
VALUES (
    (SELECT id FROM villages LIMIT 1),
    'New Solar Panels Installed',
    'The panchayat has successfully installed 50 new solar panels across key village streets, leading to 24/7 lighting and safer community spaces for all residents.',
    'Development',
    'Ramesh Patel',
    42
),
(
    (SELECT id FROM villages LIMIT 1),
    'Record Crop Yield This Season',
    'Local farmers have reported a 20% increase in wheat production due to the new organic farming techniques shared in last month''s agricultural workshop.',
    'Agriculture',
    'Suresh Kumar',
    156
),
(
    (SELECT id FROM villages LIMIT 1),
    'Panchayat School Renovation Complete',
    'The primary school has a brand new computer lab and a renovated playground to ensure better education for our children.',
    'Education',
    'Priya Sharma',
    89
);

-- 2. Village Notice Board Inserts
INSERT INTO notices (village_id, title, message, type, priority_order)
VALUES (
    (SELECT id FROM villages LIMIT 1),
    'Water Supply Interruption',
    'Water supply will be interrupted tomorrow from 10 AM to 4 PM due to main pipeline maintenance near the reservoir. Please store adequate water for your daily needs.',
    'water',
    1
),
(
    (SELECT id FROM villages LIMIT 1),
    'Gram Sabha General Meeting',
    'The monthly Gram Sabha meeting is scheduled for this Sunday at 10 AM at the Panchayat Bhawan. All adult residents are requested to attend to discuss the new budget allocation.',
    'general',
    2
),
(
    (SELECT id FROM villages LIMIT 1),
    'Power Grid Upgrades scheduled',
    'Power outages expected in Sector 3 this Wednesday due to ongoing transformer upgrades. Backup generators will be deployed at the hospital.',
    'power',
    3
);

-- 3. Yearly Certificates Inserts
INSERT INTO user_certificates (village_id, village_name, name, category, year, achievement, admin_id)
VALUES (
    (SELECT id FROM villages LIMIT 1),
    (SELECT name FROM villages LIMIT 1),
    'Anita Desai',
    'Farmer',
    '2024',
    'Adopted and implemented highly efficient drip irrigation resulting in water conservation.',
    (SELECT id FROM admins LIMIT 1)
),
(
    (SELECT id FROM villages LIMIT 1),
    (SELECT name FROM villages LIMIT 1),
    'Vijay Singh',
    'Citizen',
    '2024',
    'Actively participated and helped resolve 15 community complaints successfully.',
    (SELECT id FROM admins LIMIT 1)
),
(
    (SELECT id FROM villages LIMIT 1),
    (SELECT name FROM villages LIMIT 1),
    'Meera Patel',
    'Student',
    '2024',
    'Volunteered 100+ hours tutoring village children in Mathematics and Science after school hours.',
    (SELECT id FROM admins LIMIT 1)
);

-- 4. Mandi Prices Inserts
INSERT INTO mandi_prices (village_id, crop_name, mandi_name, price_min, price_max, price_avg, unit, price_date, status)
VALUES (
    (SELECT id FROM villages LIMIT 1),
    'Wheat (Sharbati)',
    'Rajkot Main APMC',
    2100.00,
    2350.00,
    2225.00,
    'Quintal',
    CURRENT_DATE,
    'up'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Rice (Basmati)',
    'Ahmedabad Mandi',
    4200.00,
    4800.00,
    4500.00,
    'Quintal',
    CURRENT_DATE,
    'stable'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Cotton (Long Staple)',
    'Surat Agri Market',
    7500.00,
    8200.00,
    7850.00,
    'Quintal',
    CURRENT_DATE,
    'up'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Groundnut',
    'Junagadh Yard',
    6000.00,
    6600.00,
    6300.00,
    'Quintal',
    CURRENT_DATE,
    'down'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Bajra',
    'Mehsana Market',
    1800.00,
    2000.00,
    1900.00,
    'Quintal',
    CURRENT_DATE,
    'stable'
);

-- 5. Crop Calendar Inserts
INSERT INTO crop_calendar (village_id, crop_name, season, current_stage, recommended_dates, current_status, sowing_period, duration, harvest_period, best_soil, water_requirement, description)
VALUES (
    (SELECT id FROM villages LIMIT 1),
    'Rice (Paddy)',
    'Monsoon',
    'Vegetative',
    'June - July',
    'Ideal',
    'June 15 - July 15',
    '120 - 150 Days',
    'Oct - Nov',
    'Clayey or Clay Loam',
    'High (Continuous)',
    'Ensure proper field puddling before transplanting. Maintain water depth of 5cm during the early growth stage.'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Wheat',
    'Winter',
    'Planning',
    'Nov - Dec',
    'Planning',
    'Nov 1 - Dec 15',
    '110 - 130 Days',
    'Mar - Apr',
    'Loamy Soil',
    'Moderate',
    'Treat seeds with fungicides before sowing. 4-6 irrigations required depending on soil moisture.'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Groundnut',
    'Summer',
    'Harvesting',
    'Feb - Mar',
    'Ideal',
    'Jan 15 - Feb 15',
    '100 - 120 Days',
    'May - June',
    'Sandy Loam',
    'Low',
    'Avoid water logging during pod development. Apply gypsum for better nut filling.'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Cotton',
    'Monsoon',
    'Flowering',
    'May - June',
    'Delayed',
    'May 20 - June 20',
    '160 - 180 Days',
    'Dec - Jan',
    'Black Deep Soil',
    'Moderate',
    'Monitor for pink bollworm regularly. Proper drainage is essential during heavy rains.'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Chickpea (Gram)',
    'Winter',
    'Sowing',
    'Oct - Nov',
    'Ideal',
    'Oct 15 - Nov 15',
    '90 - 110 Days',
    'Feb - Mar',
    'Well-drained Loamy Soil',
    'Very Low',
    'Pre-sowing irrigation is recommended. Avoid nitrogen-heavy fertilizers.'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Moong Bean',
    'Summer',
    'Sowing',
    'Mar - Apr',
    'Planning',
    'Mar 1 - Apr 15',
    '60 - 75 Days',
    'May - June',
    'Sandy Loam',
    'Very Low',
    'Short duration crop, excellent for field rotation and improving soil nitrogen.'
);

-- 6. Agri Resources Inserts
INSERT INTO agri_resources (village_id, resource_name, availability_percentage, status_color)
VALUES (
    (SELECT id FROM villages LIMIT 1),
    'Urea Fertilizer',
    85,
    'green'
),
(
    (SELECT id FROM villages LIMIT 1),
    'DAP Fertilizer',
    15,
    'red'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Certified Wheat Seeds',
    60,
    'green'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Organic Pesticides',
    40,
    'orange'
);

-- 7. Weather Alerts Inserts
INSERT INTO weather_alerts (village_id, title, message, alert_level, expires_at)
VALUES (
    (SELECT id FROM villages LIMIT 1),
    'Heavy Rainfall Warning',
    'Expect very heavy rainfall over the next 48 hours. Please ensure proper drainage in low-lying fields.',
    'critical',
    CURRENT_TIMESTAMP + INTERVAL '2 days'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Heatwave Advisory',
    'Temperatures likely to reach 45°C this week. Increase irrigation frequency for vegetable crops.',
    'warning',
    CURRENT_TIMESTAMP + INTERVAL '5 days'
);

-- 8. Agri Notices Inserts
INSERT INTO agri_notices (village_id, title, message)
VALUES (
    (SELECT id FROM villages LIMIT 1),
    'Soil Testing Camp',
    'Free soil testing camp at the Panchayat office this Friday from 9 AM to 2 PM. Please bring 500g of soil from your field.'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Solar Pump Subsidy',
    'Applications are open for the 60% PM-KUSUM solar pump subsidy. Last date to apply is April 30th.'
),
(
    (SELECT id FROM villages LIMIT 1),
    'KCC Renewal Notice',
    'Farmers are requested to renew their Kisan Credit Cards before the monsoon season to avail interest subvention.'
);

-- 9. Schemes (Welfare Hub) Inserts
INSERT INTO schemes (title, category, description, objectives, eligibility, benefits, documents_required, url)
VALUES (
    'PM-Kisan Samman Nidhi',
    'Agriculture',
    'A central sector scheme to provide income support to all landholding farmers'' families in the country to supplement their financial needs for procuring various inputs.',
    ARRAY['To provide income support to all eligible land-holding farmers', 'To supplement financial needs for agricultural inputs', 'To protect farmers from moneylenders'],
    ARRAY['All landholding farmers families are eligible', 'Farmer must be a resident of India', 'Excludes institutional landholders and high-income individuals'],
    ARRAY['Financial benefit of Rs. 6,000 per year', 'Paid in three equal installments of Rs. 2,000 every four months', 'Direct Benefit Transfer (DBT) to bank accounts'],
    ARRAY['Aadhaar Card', 'Land holding documents', 'Bank Account details', 'Mobile Number'],
    'https://pmkisan.gov.in/'
),
(
    'PM Awas Yojana (Gramin)',
    'Social Welfare',
    'Housing for All initiative aiming to provide a pucca house with basic amenities to all houseless householders and those households living in kutcha and dilapidated houses.',
    ARRAY['To provide pucca houses for all by the end of the year', 'To improve living standards of rural poor', 'To provide basic amenities like electricity and water'],
    ARRAY['Socio-Economic Caste Census (SECC) targets', 'Families with no adult member between 16-59 years', 'Female-headed households', 'Families with disabled members'],
    ARRAY['Financial assistance of Rs. 1.2 Lakh in plains', 'Financial assistance of Rs. 1.3 Lakh in hilly/difficult areas', 'Mandatory 90/95 days of unskilled labor under MGNREGS'],
    ARRAY['Aadhaar Card', 'MGNREGS Job Card', 'Bank Passbook', 'Swachh Bharat Mission (SBM) ID'],
    'https://pmayg.nic.in/'
),
(
    'Post-Matric Scholarship',
    'Education',
    'Scholarships for students belonging to Scheduled Castes, Scheduled Tribes, and other minority categories for pursuing post-matriculation or post-secondary courses.',
    ARRAY['To provide financial assistance to minority students', 'To reduce dropout rates at post-matric stage', 'To encourage higher education'],
    ARRAY['Students belonging to SC/ST/OBC categories', 'Annual family income below Rs. 2.5 Lakhs', 'Minimum 50% marks in previous final examination'],
    ARRAY['Full tuition fee reimbursement', 'Monthly maintenance allowance (Hosteller/Day Scholar)', 'Special allowances for students with disabilities'],
    ARRAY['Caste Certificate', 'Income Certificate', 'Previous Year Marksheet', 'Domicile Certificate', 'Fee Receipt'],
    'https://scholarships.gov.in/'
);

-- 10. Polls Inserts
INSERT INTO polls (id, village_id, question, expiry_date)
VALUES 
(
    'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d',
    (SELECT id FROM villages LIMIT 1),
    'Should we convert the old community center into a digital library?',
    CURRENT_TIMESTAMP + INTERVAL '14 days'
),
(
    'b2c3d4e5-f6a7-4b6c-9d0e-1f2a3b4c5d6e',
    (SELECT id FROM villages LIMIT 1),
    'Which crop should we focus on for the next organic farming workshop?',
    CURRENT_TIMESTAMP + INTERVAL '7 days'
),
(
    'c3d4e5f6-a7b8-4c7d-0e1f-2a3b4c5d6e7f',
    (SELECT id FROM villages LIMIT 1),
    'Are you satisfied with the recent solar street light installation?',
    CURRENT_TIMESTAMP - INTERVAL '1 day' -- Expired poll
),
(
    '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
    (SELECT id FROM villages LIMIT 1),
    'What should be the main focus for the upcoming village development fund?',
    CURRENT_TIMESTAMP + INTERVAL '30 days'
);

-- 11. Poll Options Inserts
INSERT INTO poll_options (id, poll_id, option_text)
VALUES 
-- Options for Poll 1
('d4e5f6a7-b8c9-4d8e-1f2a-3b4c5d6e7f8a', 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'Yes, definitely needed'),
('e5f6a7b8-c9d0-4e9f-2a3b-4c5d6e7f8a9b', 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'No, keep it as is'),
('f6a7b8c9-d0e1-4fa2-3b4c-5d6e7f8a9b0c', 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'Maybe, if we have budget'),

-- Options for Poll 2
('a7b8c9d0-e1f2-4fb3-4c5d-6e7f8a9b0c1d', 'b2c3d4e5-f6a7-4b6c-9d0e-1f2a3b4c5d6e', 'Organic Wheat'),
('b8c9d0e1-f2a3-4fc4-5d6e-7f8a9b0c1d2e', 'b2c3d4e5-f6a7-4b6c-9d0e-1f2a3b4c5d6e', 'Basmati Rice'),
('c9d0e1f2-a3b4-4fd5-6e7f-8a9b0c1d2e3f', 'b2c3d4e5-f6a7-4b6c-9d0e-1f2a3b4c5d6e', 'Vegetables'),

-- Options for Poll 3
('d0e1f2a3-b4c5-4fe6-7f8a-9b0c1d2e3f4a', 'c3d4e5f6-a7b8-4c7d-0e1f-2a3b4c5d6e7f', 'Very Satisfied'),
('e1f2a3b4-c5d6-4ff7-8a9b-0c1d2e3f4a5b', 'c3d4e5f6-a7b8-4c7d-0e1f-2a3b4c5d6e7f', 'Somewhat Satisfied'),
('f2a3b4c5-d6e7-4f08-9b0c-1d2e3f4a5b6c', 'c3d4e5f6-a7b8-4c7d-0e1f-2a3b4c5d6e7f', 'Not Satisfied'),

-- Options for newly added Poll 4
('2a3b4c5d-6e7f-8a9b-0c1d-2e3f4a5b6c7d', '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d', 'Education & Schools'),
('3b4c5d6e-7f8a-9b0c-1d2e-3f4a5b6c7d8e', '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d', 'Healthcare & Clinics'),
('4c5d6e7f-8a9b-0c1d-2e3f-4a5b6c7d8e9f', '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d', 'Road & Transport');

-- 12. Emergency Services Inserts
INSERT INTO emergency_services (village_id, title, contact_number, category, description)
VALUES 
(
    (SELECT id FROM villages LIMIT 1),
    'Health Center Helpline',
    '108',
    'medical',
    'Immediate medical assistance and ambulance services'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Village Police Station',
    '100',
    'police',
    'Emergency police assistance and security concerns'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Fire Safety Department',
    '101',
    'fire',
    'Fire emergencies and rescue operations'
),
(
    (SELECT id FROM villages LIMIT 1),
    'Gram Panchayat Helpline',
    '1800-456-7890',
    'panchayat',
    'General support and administrative assistance'
);

-- 13. Complaints Inserts (Human-readable IDs)
INSERT INTO complaints (user_id, complaint_id_display, category, description, priority, status, image_url, audio_url)
VALUES 
(
    (SELECT id FROM users LIMIT 1),
    'SDGVS-PAL-2024-1024',
    'Electricity',
    'Street light not working in front of House No. 45 for the last 3 days.',
    'medium',
    'Resolved',
    'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?auto=format&fit=crop&q=80&w=2070',
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'
),
(
    (SELECT id FROM users LIMIT 1),
    'SDGVS-PAL-2024-5521',
    'Water Supply',
    'Major leakage in the main pipeline near the village well.',
    'high',
    'Pending',
    'https://images.unsplash.com/photo-1542037104857-ffbb0b9155fb?auto=format&fit=crop&q=80&w=2070',
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'
),
(
    (SELECT id FROM users LIMIT 1),
    'SDGVS-PAL-2024-8902',
    'Sanitation',
    'Garbage collection van has not visited our street this week.',
    'low',
    'In Progress',
    NULL,
    NULL
);

INSERT INTO user_badges (user_id, name, description, icon_path, admin_id)
VALUES (
    (SELECT id FROM users LIMIT 1),
    'Community Hero',
    'Awarded for resolving more than 10 village complaints.',
    'verified_user_rounded',
    (SELECT id FROM admins LIMIT 1)
),
(
    (SELECT id FROM users LIMIT 1),
    'Top Contributor',
    'Recognized for outstanding contribution to village development projects.',
    'stars_rounded',
    (SELECT id FROM admins LIMIT 1)
),
(
    (SELECT id FROM users LIMIT 1),
    'Eco Warrior',
    'Awarded for active participation in the village tree plantation drive.',
    'eco_rounded',
    (SELECT id FROM admins LIMIT 1)
);
