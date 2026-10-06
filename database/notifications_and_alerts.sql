-- ==============================================================================
-- CIVENTRAL CITIZEN ENGAGEMENT PLATFORM - NOTIFICATIONS & ALERTS SUBSYSTEM
-- Target Databases: `citizen_verification` & `civentral_certificates`
-- Compatible with: MySQL 5.7+, MySQL 8.0+, MariaDB 10.4+, and Dokploy Cloud MySQL
-- ==============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ------------------------------------------------------------------------------
-- 1. DATABASE INITIALIZATION
-- ------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS `citizen_verification` 
DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS `civentral_certificates` 
DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 2. TABLE STRUCTURE: broadcast_alerts (PRIMARY REPOSITORY)
-- ------------------------------------------------------------------------------
USE `citizen_verification`;

CREATE TABLE IF NOT EXISTS `broadcast_alerts` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `alert_id` VARCHAR(50) NOT NULL UNIQUE COMMENT 'Unique alert code, e.g. CCN-ALT-2026-0001',
  `title` VARCHAR(255) NOT NULL,
  `body` TEXT NOT NULL,
  `category` VARCHAR(100) NOT NULL DEFAULT 'Broadcast' COMMENT 'Emergency, Health Advisory, Broadcast, General Announcement, Curfew / Ordinance, Event',
  `priority` ENUM('Normal', 'High', 'Urgent') NOT NULL DEFAULT 'Normal',
  `channels` VARCHAR(150) NOT NULL DEFAULT 'In-App, Push',
  `target_audience` VARCHAR(150) NOT NULL DEFAULT 'All Registered Citizens',
  `target_barangay` VARCHAR(150) NOT NULL DEFAULT 'All Barangays',
  `sender_name` VARCHAR(150) NOT NULL DEFAULT 'Caloocan Public Information Office',
  `sender_role` VARCHAR(150) NOT NULL DEFAULT 'Public Information Officer',
  `status` ENUM('Delivered', 'Sent', 'Scheduled', 'Draft') NOT NULL DEFAULT 'Delivered',
  `recipients_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `delivered_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `failed_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `pending_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `attachment_url` VARCHAR(500) NULL DEFAULT NULL,
  `scheduled_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_created_at` (`created_at`),
  INDEX `idx_category` (`category`),
  INDEX `idx_status` (`status`),
  INDEX `idx_priority` (`priority`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 3. SEED RECORDS: REAL HISTORICAL BROADCAST ALERTS
-- ------------------------------------------------------------------------------
REPLACE INTO `citizen_verification`.`broadcast_alerts` (
  `id`, `alert_id`, `title`, `body`, `category`, `priority`,
  `channels`, `target_audience`, `target_barangay`,
  `sender_name`, `sender_role`, `status`,
  `recipients_count`, `delivered_count`, `failed_count`, `pending_count`,
  `attachment_url`, `scheduled_at`, `created_at`, `updated_at`
) VALUES 
(
  1,
  'CCN-ALT-2026-4386',
  'Typhoon Advisory #3 - Heavy Rainfall Alert',
  'PAGASA has issued Orange Rainfall Warning for Caloocan City. Emergency evacuation centers at Barangay 176 are prepared and open.',
  'Emergency',
  'Urgent',
  'In-App / Push, SMS',
  'All Residents',
  'All Barangays',
  'Caloocan Public Information Office',
  'Public Information Officer',
  'Delivered',
  1420,
  1399,
  21,
  0,
  NULL,
  NULL,
  '2026-09-30 00:54:32',
  '2026-09-30 00:54:32'
),
(
  2,
  'CCN-ALT-2026-1315',
  'Health Advisory: Dengue Prevention & Fogging Schedule',
  'Barangay Health Services will conduct synchronized anti-dengue misting and free larval inspections this Saturday starting 7:00 AM.',
  'Health Advisory',
  'High',
  'In-App / Push, SMS, Email',
  'All Residents',
  'All Barangays',
  'Caloocan Public Information Office',
  'Public Information Officer',
  'Delivered',
  1420,
  1399,
  21,
  0,
  NULL,
  NULL,
  '2026-09-30 01:00:44',
  '2026-09-30 01:00:44'
),
(
  3,
  'CCN-ALT-2026-1082',
  'baha',
  'magingat sa baha',
  'Emergency',
  'Urgent',
  'In-App / Push',
  'All Residents',
  'All Barangays',
  'Caloocan Public Information Office',
  'Public Information Officer',
  'Delivered',
  1420,
  1399,
  21,
  0,
  'assets/uploads/alerts/alert_1790701497_a4a86022.jfif',
  NULL,
  '2026-09-30 01:04:57',
  '2026-09-30 01:04:57'
),
(
  4,
  'CCN-ALT-2026-2224',
  'Barilan',
  '<b>Mag ingat sa barilan sa camarin</b>',
  'Emergency',
  'Urgent',
  'In-App / Push',
  'All Residents',
  'All Barangays',
  'Caloocan Public Information Office',
  'Public Information Officer',
  'Delivered',
  1,
  1,
  0,
  0,
  NULL,
  NULL,
  '2026-09-30 13:19:14',
  '2026-09-30 13:19:14'
);

-- ------------------------------------------------------------------------------
-- 4. DUAL-DATABASE REPLICATION & SYNCHRONIZATION
-- Replicate full structure & seed rows into `civentral_certificates`
-- ------------------------------------------------------------------------------
USE `civentral_certificates`;

CREATE TABLE IF NOT EXISTS `broadcast_alerts` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `alert_id` VARCHAR(50) NOT NULL UNIQUE COMMENT 'Unique alert code, e.g. CCN-ALT-2026-0001',
  `title` VARCHAR(255) NOT NULL,
  `body` TEXT NOT NULL,
  `category` VARCHAR(100) NOT NULL DEFAULT 'Broadcast' COMMENT 'Emergency, Health Advisory, Broadcast, General Announcement, Curfew / Ordinance, Event',
  `priority` ENUM('Normal', 'High', 'Urgent') NOT NULL DEFAULT 'Normal',
  `channels` VARCHAR(150) NOT NULL DEFAULT 'In-App, Push',
  `target_audience` VARCHAR(150) NOT NULL DEFAULT 'All Registered Citizens',
  `target_barangay` VARCHAR(150) NOT NULL DEFAULT 'All Barangays',
  `sender_name` VARCHAR(150) NOT NULL DEFAULT 'Caloocan Public Information Office',
  `sender_role` VARCHAR(150) NOT NULL DEFAULT 'Public Information Officer',
  `status` ENUM('Delivered', 'Sent', 'Scheduled', 'Draft') NOT NULL DEFAULT 'Delivered',
  `recipients_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `delivered_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `failed_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `pending_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `attachment_url` VARCHAR(500) NULL DEFAULT NULL,
  `scheduled_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_created_at` (`created_at`),
  INDEX `idx_category` (`category`),
  INDEX `idx_status` (`status`),
  INDEX `idx_priority` (`priority`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Complete bidirectional mirror of records
REPLACE INTO `civentral_certificates`.`broadcast_alerts`
SELECT * FROM `citizen_verification`.`broadcast_alerts`;

SET FOREIGN_KEY_CHECKS = 1;

-- ==============================================================================
-- END OF NOTIFICATIONS & ALERTS SUBSYSTEM DATABASE SCHEMA
-- ==============================================================================
