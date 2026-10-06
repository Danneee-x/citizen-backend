-- ==============================================================================
-- DATABASE: citizen_verification & civentral_certificates
-- Target System: Civentral Citizen Portal / Verification Module
-- Generated for: Local MySQL / phpMyAdmin / Dokploy Cloud
-- Source Component: src/features/identity/screens/VerifyCitizenScreen.tsx
-- ==============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. DATABASE CREATION
CREATE DATABASE IF NOT EXISTS `citizen_verification`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS `civentral_certificates`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `citizen_verification`;

-- ------------------------------------------------------------------------------
-- 2. TABLE STRUCTURE: citizen_users
-- Core Citizen Account & Authentication Entity
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `citizen_users` (
  `citizen_user_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `first_name` VARCHAR(100) NOT NULL,
  `middle_name` VARCHAR(100) NULL DEFAULT NULL,
  `has_no_middle_name` TINYINT(1) NOT NULL DEFAULT 0,
  `last_name` VARCHAR(100) NOT NULL,
  `suffix` VARCHAR(20) NULL DEFAULT NULL,
  `email` VARCHAR(191) NOT NULL UNIQUE,
  `mobile_number` VARCHAR(30) NULL DEFAULT NULL,
  `password` VARCHAR(255) NULL DEFAULT NULL,
  `status` ENUM('Pending', 'Active', 'Inactive', 'Locked', 'Archived') NOT NULL DEFAULT 'Active',
  `registry_completed` TINYINT(1) NOT NULL DEFAULT 0,
  `failed_attempts` INT NOT NULL DEFAULT 0,
  `last_login` DATETIME NULL DEFAULT NULL,
  `biometric_enabled` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 3. TABLE STRUCTURE: citizen_verifications
-- Dedicated Multi-Step Citizen Verification Form & Civil Registry Data
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `citizen_verifications` (
  `verification_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `citizen_user_id` INT UNSIGNED NOT NULL,

  -- STEP 1: Personal Information
  `first_name` VARCHAR(100) NOT NULL,
  `middle_name` VARCHAR(100) NULL DEFAULT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `suffix` VARCHAR(20) NULL DEFAULT NULL,
  `sex` ENUM('Male', 'Female') NOT NULL,
  `place_of_birth` VARCHAR(255) NOT NULL,
  `birth_date` DATE NOT NULL,
  `civil_status` ENUM(
    'Single',
    'Married',
    'Widowed',
    'Separated',
    'Divorced / Annulled',
    'Common-Law / Live-In'
  ) NOT NULL,
  `employment_status` VARCHAR(100) NOT NULL,
  `occupation` VARCHAR(150) NOT NULL,
  `educational_attainment` VARCHAR(100) NOT NULL,

  -- STEP 2: Residency & District Details
  `district` VARCHAR(50) NOT NULL,
  `barangay` VARCHAR(100) NOT NULL,
  `street_address` VARCHAR(255) NOT NULL,
  `years_resident` INT UNSIGNED NOT NULL,

  -- STEP 3: Valid ID & Biometrics (Liveness Check)
  `valid_id_type` VARCHAR(100) NOT NULL,
  `valid_id_number` VARCHAR(100) NOT NULL,
  `id_front_photo_url` MEDIUMTEXT NULL DEFAULT NULL,
  `selfie_photo_url` MEDIUMTEXT NULL DEFAULT NULL,

  -- Administration & Review Workflow
  `verification_status` ENUM('Pending', 'Under_Review', 'Approved', 'Rejected') NOT NULL DEFAULT 'Pending',
  `rejection_reason` TEXT NULL DEFAULT NULL,
  `reviewed_by_employee_id` INT UNSIGNED NULL DEFAULT NULL,
  `reviewed_by` VARCHAR(100) NULL DEFAULT NULL,
  `reviewed_at` DATETIME NULL DEFAULT NULL,
  `is_duplicate` TINYINT(1) NOT NULL DEFAULT 0,
  `duplicate_notes` TEXT NULL DEFAULT NULL,
  `submitted_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX `idx_verif_user_id` (`citizen_user_id`),
  INDEX `idx_verif_status` (`verification_status`),
  INDEX `idx_verif_barangay` (`barangay`),
  INDEX `idx_verif_submitted_at` (`submitted_at`),
  CONSTRAINT `fk_verif_user` FOREIGN KEY (`citizen_user_id`)
    REFERENCES `citizen_users` (`citizen_user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 4. SEED DATA FOR TESTING & LOCAL ENVIRONMENT
-- ------------------------------------------------------------------------------
REPLACE INTO `citizen_users` (
  `citizen_user_id`, `first_name`, `middle_name`, `last_name`, `suffix`,
  `email`, `mobile_number`, `status`, `registry_completed`, `biometric_enabled`, `created_at`
) VALUES 
(
  35, 'Vice', 'G', 'Ganda', NULL,
  'espelitadanny@gmail.com', '09630902025', 'Active', 1, 0, '2026-09-30 14:27:34'
),
(
  1001, 'Danny', 'Toledano', 'Espelita', 'Jr.',
  'danny.espelita@civentral.ph', '09171234567', 'Active', 1, 1, '2026-09-30 13:26:00'
),
(
  1002, 'Jean', NULL, 'Gray', NULL,
  'eanray_1002@citizen.local', '09000001002', 'Active', 0, 0, '2026-09-30 14:00:30'
);

REPLACE INTO `citizen_verifications` (
  `verification_id`, `citizen_user_id`, `first_name`, `middle_name`, `last_name`, `suffix`,
  `sex`, `place_of_birth`, `birth_date`, `civil_status`, `employment_status`, `occupation`,
  `educational_attainment`, `district`, `barangay`, `street_address`, `years_resident`,
  `valid_id_type`, `valid_id_number`, `verification_status`, `submitted_at`
) VALUES 
(
  1, 1001, 'Danny', 'Toledano', 'Espelita', 'Jr.',
  'Male', 'Caloocan City', '1998-05-15', 'Single', 'Employed (Private Sector)', 'Software Engineer',
  'College Graduate', 'District 1', 'Barangay 171 (Bagumbong)', '123 Sampaguita St.', 15,
  'Philippine Identification System (PhilSys) National ID', '1234-5678-9012-3456', 'Pending', '2026-09-30 13:26:00'
),
(
  9, 1002, 'Jean', NULL, 'Gray', NULL,
  'Female', 'Caloocan City', '1995-10-20', 'Single', 'Employed (Private Sector)', 'Designer',
  'College Graduate', 'District 3', 'Barangay 178', '45 Camarin Rd.', 8,
  'PhilSys National ID', '9876-5432-1098-7654', 'Pending', '2026-09-30 14:00:30'
),
(
  11, 35, 'Vice', 'G', 'Ganda', NULL,
  'Male', 'Manila', '1976-03-31', 'Single', 'Self-Employed / Freelancer', 'Host & Artist',
  'College Graduate', 'District 2', 'Barangay 77', '100 Rizal Ave.', 20,
  'PhilSys National ID', '4444-5555-6666-7777', 'Approved', '2026-09-30 14:28:00'
);

-- ------------------------------------------------------------------------------
-- 5. DUAL-DATABASE SYNCHRONIZATION (`civentral_certificates`)
-- ------------------------------------------------------------------------------
USE `civentral_certificates`;

CREATE TABLE IF NOT EXISTS `citizen_users` LIKE `citizen_verification`.`citizen_users`;
CREATE TABLE IF NOT EXISTS `citizen_verifications` LIKE `citizen_verification`.`citizen_verifications`;

REPLACE INTO `civentral_certificates`.`citizen_users` 
SELECT * FROM `citizen_verification`.`citizen_users`;

REPLACE INTO `civentral_certificates`.`citizen_verifications` 
SELECT * FROM `citizen_verification`.`citizen_verifications`;

SET FOREIGN_KEY_CHECKS = 1;

-- ==============================================================================
-- END OF CITIZEN VERIFICATION SUBSYSTEM DATABASE SCHEMA
-- ==============================================================================
