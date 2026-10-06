-- ==============================================================================
-- CIVENTRAL CITIZEN ENGAGEMENT PLATFORM - COMMUNITY FEEDBACK & RATINGS SUBSYSTEM
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
-- 1. TABLE STRUCTURE: community_ratings (`citizen_verification`)
-- ------------------------------------------------------------------------------
USE `citizen_verification`;

CREATE TABLE IF NOT EXISTS `community_ratings` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `feedback_ref` VARCHAR(50) NOT NULL UNIQUE COMMENT 'Unique feedback reference code, e.g. CFB-2026-0001',
  `citizen_name` VARCHAR(150) NOT NULL DEFAULT 'Anonymous Citizen',
  `citizen_email` VARCHAR(150) NULL DEFAULT NULL,
  `citizen_barangay` VARCHAR(100) NOT NULL DEFAULT 'Barangay Central',
  `service_name` VARCHAR(150) NOT NULL,
  `transaction_ref` VARCHAR(100) NULL DEFAULT NULL,
  `overall_rating` TINYINT UNSIGNED NOT NULL DEFAULT 5,
  `quality_rating` TINYINT UNSIGNED NOT NULL DEFAULT 5,
  `staff_rating` TINYINT UNSIGNED NOT NULL DEFAULT 5,
  `comments` TEXT NULL DEFAULT NULL,
  `sentiment` ENUM('Positive', 'Neutral', 'Negative') NOT NULL DEFAULT 'Positive',
  `status` ENUM('Published', 'Reviewed', 'Pending', 'Flagged') NOT NULL DEFAULT 'Published',
  `attachment_url` VARCHAR(255) NULL DEFAULT NULL,
  `admin_notes` TEXT NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_service` (`service_name`),
  INDEX `idx_rating` (`overall_rating`),
  INDEX `idx_status` (`status`),
  INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 2. SEED RECORDS: REALISTIC CITIZEN FEEDBACK & SERVICE RATINGS
-- ------------------------------------------------------------------------------
REPLACE INTO `citizen_verification`.`community_ratings` (
  `id`, `feedback_ref`, `citizen_name`, `citizen_email`, `citizen_barangay`,
  `service_name`, `transaction_ref`, `overall_rating`, `quality_rating`, `staff_rating`,
  `comments`, `sentiment`, `status`, `created_at`
) VALUES 
(
  1,
  'CFB-2026-1001',
  'Danny Espelita',
  'danny.espelita@civentral.ph',
  'Barangay 176',
  'Barangay Clearance & Residency Certificate',
  'CAL-BC-2026-0881',
  5, 5, 5,
  'Smooth process at the barangay hall window. Released in less than 15 minutes after online QR scanning.',
  'Positive',
  'Published',
  '2026-09-28 09:30:00'
),
(
  2,
  'CFB-2026-1002',
  'Maria Santos',
  'maria.santos@gmail.com',
  'Barangay 171',
  'Caloocan City Health Center Consultation',
  'CAL-HC-2026-4412',
  4, 4, 5,
  'The doctor and nurses were very polite and accommodating. The waiting area was clean and well ventilated.',
  'Positive',
  'Published',
  '2026-09-28 14:15:00'
),
(
  3,
  'CFB-2026-1003',
  'Anonymous Citizen',
  NULL,
  'Barangay 178',
  'Road Maintenance & Pothole Repair',
  'CAL-REP-2026-9045',
  5, 5, 4,
  'Engineering department dispatched asphalt repair crew within 48 hours of filing report. Excellent turnaround.',
  'Positive',
  'Published',
  '2026-09-29 11:00:00'
),
(
  4,
  'CFB-2026-1004',
  'Juan Dela Cruz',
  'juan.delacruz@civentral.ph',
  'Barangay 176',
  'Senior Citizen & OSCA ID Processing',
  'CAL-CIT-2026-4412',
  5, 5, 5,
  'Assisted my grandmother with her senior ID renewal. Very patient staff at Window 6.',
  'Positive',
  'Published',
  '2026-09-30 10:20:00'
);

-- ------------------------------------------------------------------------------
-- 3. DUAL-DATABASE SYNCHRONIZATION (`civentral_certificates`)
-- ------------------------------------------------------------------------------
USE `civentral_certificates`;

CREATE TABLE IF NOT EXISTS `community_ratings` LIKE `citizen_verification`.`community_ratings`;

REPLACE INTO `civentral_certificates`.`community_ratings` 
SELECT * FROM `citizen_verification`.`community_ratings`;

SET FOREIGN_KEY_CHECKS = 1;

-- ==============================================================================
-- END OF COMMUNITY FEEDBACK & RATINGS SUBSYSTEM DATABASE SCHEMA
-- ==============================================================================
