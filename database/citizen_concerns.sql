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
