-- ========================================================
-- CivCentral Citizen Concerns & Gemini AI Triage Schema
-- Database: `citizen_verification`
-- Target Table: `citizen_concerns`
-- ========================================================

CREATE DATABASE IF NOT EXISTS `citizen_verification` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `citizen_verification`;

CREATE TABLE IF NOT EXISTS `citizen_concerns` (
    `concern_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `ticket_number` VARCHAR(50) UNIQUE NOT NULL,
    `citizen_user_id` INT UNSIGNED NULL,
    `citizen_name` VARCHAR(150) NOT NULL DEFAULT 'Anonymous Resident',
    `citizen_phone` VARCHAR(50) NULL,
    `citizen_email` VARCHAR(150) NULL,
    `is_anonymous` TINYINT(1) NOT NULL DEFAULT 0,
    `category` VARCHAR(100) NOT NULL,
    `sub_category` VARCHAR(100) NULL,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT NOT NULL,
    `location` VARCHAR(255) NOT NULL DEFAULT '',
    `barangay` VARCHAR(100) NOT NULL DEFAULT '',
    `district` VARCHAR(50) NULL DEFAULT 'District 1',
    `gps_coordinates` VARCHAR(100) NULL,
    `status` ENUM('New', 'Under Review', 'Routed', 'In Progress', 'Resolved', 'Closed') NOT NULL DEFAULT 'New',
    `priority` ENUM('Urgent', 'High', 'Medium', 'Low') NOT NULL DEFAULT 'Medium',
    `assigned_department` VARCHAR(150) NULL,
    `ai_detected_category` VARCHAR(100) NULL,
    `ai_confidence_score` VARCHAR(100) NULL,
    `ai_reason` TEXT NULL,
    `photo_evidence_url` MEDIUMTEXT NULL,
    `attachments` TEXT NULL,
    `resolution_notes` TEXT NULL,
    `resolved_at` DATETIME NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_status` (`status`),
    INDEX `idx_category` (`category`),
    INDEX `idx_barangay` (`barangay`),
    INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sample Seed Data for AI Analysis Results & Triage Hub
INSERT INTO `citizen_concerns` 
(`ticket_number`, `citizen_name`, `citizen_phone`, `citizen_email`, `is_anonymous`, `category`, `sub_category`, `title`, `description`, `location`, `barangay`, `district`, `status`, `priority`, `assigned_department`, `ai_detected_category`, `ai_confidence_score`, `ai_reason`)
VALUES
('CAL-REP-2026-4821', 'Juan Dela Cruz', '09171234567', 'juan@example.com', 0, 'Road & Infrastructure', 'Pothole Hazard', 'Deep pothole along 10th Avenue causing motor accidents', 'There is a severe crater-like pothole near the corner of 10th Ave and Rizal Ave extension. Motorcyclists swerve into incoming traffic to avoid it, causing multiple close calls during evening rush hours.', 'Corner 10th Ave & Rizal Ave Ext', 'Barangay 64', 'District 1', 'New', 'High', 'City Engineering & Public Works Office (DPWH/CEPO)', 'Road & Infrastructure', '98% - Gemini 3.8 Flash', 'Urgent structural road hazard identified near busy transit intersection requiring expedited cold-mix or asphalt overlay dispatch.'),

('CAL-REP-2026-3190', 'Maria Santos', '09289876543', 'maria.santos@email.com', 0, 'Flooding & Drainage', 'Clogged Drainage Canal', 'Uncleaned canal overflow flooding residential sidewalk', 'Canal along Samson Road has not been dredged for 3 months. Stagnant black water with foul odor is overflowing onto the pedestrian pathway and entering residential gates.', 'Samson Road near Monumento Circle', 'Barangay 77', 'District 1', 'New', 'High', 'Caloocan Flood Control & Drainage Bureau', 'Flooding & Drainage', '96% - Gemini 3.8 Flash', 'Blockage in stormwater drainage runoff posing neighborhood sanitation risk and flooding potential during heavy rainfall.'),

('CAL-REP-2026-5522', 'Anonymous Resident', NULL, NULL, 1, 'Streetlights', 'Non-functioning Lampposts', 'Dark alleyway with three consecutive broken lampposts', 'The entire stretch of Zapote Street from alley 2 to 4 is completely dark because the LED light bulbs have been busted since last week. Residents feel unsafe walking home late at night.', 'Zapote St Alley 3', 'Barangay 171', 'District 2', 'New', 'Medium', 'Public Safety Electrical Division', 'Streetlights', '94% - Gemini 3.8 Flash', 'Electrical infrastructure failure creating nocturnal public security vulnerability for pedestrians.')
ON DUPLICATE KEY UPDATE `ticket_number` = `ticket_number`;
