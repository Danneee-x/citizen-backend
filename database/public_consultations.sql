-- ====================================================================
-- CIVENTRAL CITIZEN ENGAGEMENT PLATFORM - PUBLIC CONSULTATION & SURVEY SUBSYSTEM
-- Target Databases: `citizen_verification` & `civentral_certificates`
-- Supports mobile app question types: rating_scale, likert_scale, multiple_choice, multiple_selection, yes_no, long_answer
-- Compatible with: MySQL 5.7+, MySQL 8.0+, MariaDB 10.4+, and Dokploy Cloud MySQL
-- ====================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS `citizen_verification` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS `civentral_certificates` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `citizen_verification`;

-- 1. Public Surveys Table
CREATE TABLE IF NOT EXISTS `public_surveys` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `survey_code` VARCHAR(50) NOT NULL UNIQUE,
    `title` VARCHAR(255) NOT NULL,
    `short_description` TEXT NOT NULL,
    `category` VARCHAR(100) NOT NULL,
    `estimated_time` VARCHAR(50) NOT NULL DEFAULT '3 mins',
    `target_audience` VARCHAR(100) NOT NULL DEFAULT 'All Residents',
    `sub_target` VARCHAR(150) NULL DEFAULT NULL,
    `open_date` DATE NOT NULL,
    `close_date` DATE NOT NULL,
    `privacy_setting` ENUM('Identified', 'Anonymous') NOT NULL DEFAULT 'Identified',
    `is_public_results` TINYINT(1) NOT NULL DEFAULT 1,
    `status` ENUM('Draft', 'Open', 'Closing Soon', 'Completed', 'Closed') NOT NULL DEFAULT 'Open',
    `created_by` VARCHAR(150) NOT NULL DEFAULT 'City Administration',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_survey_status` (`status`),
    INDEX `idx_survey_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Survey Questions Table
CREATE TABLE IF NOT EXISTS `survey_questions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `survey_id` INT NOT NULL,
    `question_order` INT NOT NULL DEFAULT 1,
    `title` TEXT NOT NULL,
    `question_type` ENUM(
        'multiple_choice',
        'multiple_selection',
        'yes_no',
        'rating_scale',
        'likert_scale',
        'short_answer',
        'long_answer'
    ) NOT NULL DEFAULT 'multiple_choice',
    `options_json` JSON NULL,
    `is_required` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`survey_id`) REFERENCES `public_surveys`(`id`) ON DELETE CASCADE,
    INDEX `idx_question_survey` (`survey_id`, `question_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Survey Responses Table
CREATE TABLE IF NOT EXISTS `survey_responses` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `survey_id` INT NOT NULL,
    `citizen_id` INT NULL DEFAULT NULL,
    `citizen_name` VARCHAR(150) NOT NULL DEFAULT 'Anonymous Citizen',
    `barangay` VARCHAR(100) NULL DEFAULT NULL,
    `age_group` VARCHAR(50) NULL DEFAULT NULL,
    `gender` VARCHAR(30) NULL DEFAULT NULL,
    `answers_json` JSON NOT NULL,
    `overall_rating` DECIMAL(3,2) NULL DEFAULT NULL,
    `commentary` TEXT NULL DEFAULT NULL,
    `submitted_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`survey_id`) REFERENCES `public_surveys`(`id`) ON DELETE CASCADE,
    INDEX `idx_response_survey` (`survey_id`),
    INDEX `idx_response_date` (`submitted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Civic Consultations Table
CREATE TABLE IF NOT EXISTS `civic_consultations` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `consultation_code` VARCHAR(50) NOT NULL UNIQUE,
    `title` VARCHAR(255) NOT NULL,
    `category` VARCHAR(100) NOT NULL,
    `background_info` TEXT NOT NULL,
    `objective` TEXT NOT NULL,
    `closing_date` DATE NOT NULL,
    `status` ENUM('Open', 'Closing Soon', 'Under Review', 'Closed / Outcome Published') NOT NULL DEFAULT 'Open',
    `created_by` VARCHAR(150) NOT NULL DEFAULT 'City Legal & Policy Board',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_consultation_status` (`status`),
    INDEX `idx_consultation_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Consultation Citizen Feedbacks
CREATE TABLE IF NOT EXISTS `consultation_feedbacks` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `consultation_id` INT NOT NULL,
    `citizen_id` INT NULL DEFAULT NULL,
    `citizen_name` VARCHAR(150) NOT NULL DEFAULT 'Caloocan Resident',
    `barangay` VARCHAR(100) NULL DEFAULT NULL,
    `stance` ENUM('In Favor', 'Neutral', 'Against', 'Suggested Amendments') NOT NULL DEFAULT 'In Favor',
    `commentary` TEXT NOT NULL,
    `submitted_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`consultation_id`) REFERENCES `civic_consultations`(`id`) ON DELETE CASCADE,
    INDEX `idx_feedback_consultation` (`consultation_id`),
    INDEX `idx_feedback_stance` (`stance`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Consultation Policy Outcomes Table
CREATE TABLE IF NOT EXISTS `consultation_outcomes` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `consultation_id` INT NOT NULL UNIQUE,
    `key_findings` TEXT NOT NULL,
    `policy_outcome` TEXT NOT NULL,
    `ordinance_number` VARCHAR(100) NULL DEFAULT NULL,
    `allocated_budget` VARCHAR(100) NULL DEFAULT NULL,
    `transparency_score` VARCHAR(50) NOT NULL DEFAULT '100% Published & Verified',
    `pdf_filename` VARCHAR(255) NULL DEFAULT NULL,
    `published_by` VARCHAR(150) NOT NULL DEFAULT 'City Council Secretariat',
    `published_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`consultation_id`) REFERENCES `civic_consultations`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 7. SEED DATA FOR PUBLIC SURVEYS & CIVIC CONSULTATIONS
-- ------------------------------------------------------------------------------
REPLACE INTO `citizen_verification`.`public_surveys` (
    `id`, `survey_code`, `title`, `short_description`, `category`,
    `estimated_time`, `target_audience`, `open_date`, `close_date`,
    `privacy_setting`, `is_public_results`, `status`
) VALUES 
(
    1,
    'SRV-2026-001',
    'Caloocan E-Government Portal & Digital Services Usability Survey',
    'Help the municipal administration evaluate the speed, accessibility, and ease of use of our unified online citizen services.',
    'Digital Governance',
    '3 mins',
    'All Residents',
    '2026-09-01',
    '2026-10-31',
    'Identified',
    1,
    'Open'
),
(
    2,
    'SRV-2026-002',
    'Community Disaster Preparedness & Flood Early Warning Feedback',
    'Share your experience with recent weather broadcasts, evacuation center readiness, and localized drainage concerns in your barangay.',
    'Disaster Preparedness',
    '4 mins',
    'All Residents',
    '2026-09-15',
    '2026-10-25',
    'Identified',
    1,
    'Open'
);

REPLACE INTO `citizen_verification`.`survey_questions` (
    `id`, `survey_id`, `question_order`, `title`, `question_type`, `options_json`, `is_required`
) VALUES 
(1, 1, 1, 'How satisfied are you with the overall speed and responsiveness of our online services?', 'rating_scale', NULL, 1),
(2, 1, 2, 'Which municipal service do you access most frequently?', 'multiple_choice', '["Barangay Certificates & Clearances", "Citizen & Senior IDs", "Emergency Alerts & Advisories", "Grievance & Concern Reporting"]', 1),
(3, 1, 3, 'Online document verification and QR vouchers are faster than physical walk-in queues.', 'likert_scale', '["Strongly Disagree", "Disagree", "Neutral / Undecided", "Agree", "Strongly Agree"]', 1),
(4, 1, 4, 'What new government services or features would you like to see integrated next?', 'long_answer', NULL, 0),
(5, 2, 1, 'Did you receive the recent Orange Rainfall Emergency Broadcast on your mobile device?', 'yes_no', '["Yes", "No"]', 1),
(6, 2, 2, 'Which notification channels are most reliable for your household during severe weather?', 'multiple_selection', '["In-App Push Notification", "SMS Text Alert", "Barangay Public Address / Siren", "Official City Facebook / Social Media"]', 1),
(7, 2, 3, 'Rate the readiness, hygiene, and adequacy of evacuation centers in your barangay.', 'rating_scale', NULL, 1);

REPLACE INTO `citizen_verification`.`civic_consultations` (
    `id`, `consultation_code`, `title`, `category`, `background_info`,
    `objective`, `closing_date`, `status`
) VALUES 
(
    1,
    'CNS-2026-101',
    'Draft City Ordinance: Residential Quiet Hours & Anti-Noise Regulation',
    'Public Safety & Ordinances',
    'The City Council is deliberating proposed regulations on commercial videoke, street loudspeakers, and construction noise in high-density barangays.',
    'Gather community consensus on establishing mandatory residential quiet hours from 10:00 PM to 6:00 AM on weekdays.',
    '2026-10-20',
    'Open'
),
(
    2,
    'CNS-2026-102',
    'Caloocan Green Corridors & Solar Streetlighting Expansion Program',
    'Urban Planning & Environment',
    'A city-wide environmental transition project targeting high-traffic pedestrian avenues across North and South Caloocan.',
    'Identify priority streets for solar-powered lighting posts, pocket tree parks, and permeable sidewalk paving.',
    '2026-11-15',
    'Open'
);

-- ------------------------------------------------------------------------------
-- 8. DUAL-DATABASE SYNCHRONIZATION (`civentral_certificates`)
-- ------------------------------------------------------------------------------
USE `civentral_certificates`;

CREATE TABLE IF NOT EXISTS `public_surveys` LIKE `citizen_verification`.`public_surveys`;
CREATE TABLE IF NOT EXISTS `survey_questions` LIKE `citizen_verification`.`survey_questions`;
CREATE TABLE IF NOT EXISTS `survey_responses` LIKE `citizen_verification`.`survey_responses`;
CREATE TABLE IF NOT EXISTS `civic_consultations` LIKE `citizen_verification`.`civic_consultations`;
CREATE TABLE IF NOT EXISTS `consultation_feedbacks` LIKE `citizen_verification`.`consultation_feedbacks`;
CREATE TABLE IF NOT EXISTS `consultation_outcomes` LIKE `citizen_verification`.`consultation_outcomes`;

REPLACE INTO `civentral_certificates`.`public_surveys` SELECT * FROM `citizen_verification`.`public_surveys`;
REPLACE INTO `civentral_certificates`.`survey_questions` SELECT * FROM `citizen_verification`.`survey_questions`;
REPLACE INTO `civentral_certificates`.`civic_consultations` SELECT * FROM `citizen_verification`.`civic_consultations`;

SET FOREIGN_KEY_CHECKS = 1;

-- ==============================================================================
-- END OF PUBLIC CONSULTATIONS SUBSYSTEM DATABASE SCHEMA
-- ==============================================================================
