-- ==============================================================================
-- CIVENTRAL CITIZEN ENGAGEMENT PLATFORM - CITIZEN CONCERNS & GRIEVANCE SUBSYSTEM
-- Target Databases: `citizen_verification` & `civentral_certificates`
-- Compatible with: MySQL 5.7+, MySQL 8.0+, MariaDB 10.4+, and Dokploy Cloud MySQL
-- ==============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS `citizen_verification` 
DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS `civentral_certificates` 
DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 1. TABLE STRUCTURE: citizen_concerns (`citizen_verification`)
-- ------------------------------------------------------------------------------
USE `citizen_verification`;

CREATE TABLE IF NOT EXISTS `citizen_concerns` (
    `concern_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `ticket_number` VARCHAR(50) UNIQUE NOT NULL,
    `citizen_user_id` INT UNSIGNED NULL DEFAULT NULL,
    `citizen_name` VARCHAR(150) NOT NULL DEFAULT 'Anonymous Resident',
    `citizen_phone` VARCHAR(50) NULL DEFAULT NULL,
    `citizen_email` VARCHAR(150) NULL DEFAULT NULL,
    `is_anonymous` TINYINT(1) NOT NULL DEFAULT 0,
    `category` VARCHAR(100) NOT NULL,
    `sub_category` VARCHAR(100) NULL DEFAULT NULL,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT NOT NULL,
    `location` VARCHAR(255) NOT NULL DEFAULT '',
    `barangay` VARCHAR(100) NOT NULL DEFAULT '',
    `district` VARCHAR(50) NULL DEFAULT 'District 1',
    `gps_coordinates` VARCHAR(100) NULL DEFAULT NULL,
    `status` ENUM('New', 'Under Review', 'Routed', 'In Progress', 'Resolved', 'Closed') NOT NULL DEFAULT 'New',
    `priority` ENUM('Urgent', 'High', 'Medium', 'Low') NOT NULL DEFAULT 'Medium',
    `assigned_department` VARCHAR(150) NULL DEFAULT NULL,
    `ai_detected_category` VARCHAR(100) NULL DEFAULT NULL,
    `ai_confidence_score` VARCHAR(100) NULL DEFAULT NULL,
    `ai_reason` TEXT NULL DEFAULT NULL,
    `photo_evidence_url` MEDIUMTEXT NULL DEFAULT NULL,
    `attachments` TEXT NULL DEFAULT NULL,
    `resolution_notes` TEXT NULL DEFAULT NULL,
    `resolved_at` DATETIME NULL DEFAULT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_status` (`status`),
    INDEX `idx_category` (`category`),
    INDEX `idx_barangay` (`barangay`),
    INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 2. SEED DATA: LIVE REPORTED CONCERNS
-- ------------------------------------------------------------------------------
REPLACE INTO `citizen_verification`.`citizen_concerns` (
  `concern_id`, `ticket_number`, `citizen_name`, `category`, `title`,
  `description`, `barangay`, `status`, `priority`, `created_at`
) VALUES 
(
  1,
  'CAL-REP-2026-1607',
  'Anonymous Resident',
  'Government Service',
  'staff was rude',
  'staff was rude during counter inquiry',
  'Barangay 123',
  'New',
  'Low',
  '2026-09-30 12:41:57'
),
(
  2,
  'CAL-REP-2026-2397',
  'Danny Toledano Espelita Jr.',
  'Public Safety',
  'GUn fight',
  'merong nag babarilan dito sa kanto ng camarin',
  'Barangay 178',
  'Closed',
  'Urgent',
  '2026-09-30 12:47:48'
),
(
  13,
  'CAL-REP-2026-9045',
  'Anonymous Resident',
  'Road & Infrastructure',
  'sinkhole',
  'may sinkhole dito sa kalsada peligroso sa mga motorista',
  'Barangay 121',
  'Closed',
  'Urgent',
  '2026-09-30 13:51:12'
);

-- ------------------------------------------------------------------------------
-- 3. DUAL-DATABASE SYNCHRONIZATION (`civentral_certificates`)
-- ------------------------------------------------------------------------------
USE `civentral_certificates`;

CREATE TABLE IF NOT EXISTS `citizen_concerns` LIKE `citizen_verification`.`citizen_concerns`;

REPLACE INTO `civentral_certificates`.`citizen_concerns` 
SELECT * FROM `citizen_verification`.`citizen_concerns`;

SET FOREIGN_KEY_CHECKS = 1;

-- ==============================================================================
-- END OF CITIZEN CONCERNS SUBSYSTEM DATABASE SCHEMA
-- ==============================================================================
