-- ==============================================================================
-- CIVentral Unified Database Schema
-- Compatible with MySQL 8.x / MariaDB (Dokploy & XAMPP)
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS `citizen_verification`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `citizen_verification`;

-- ------------------------------------------------------------------------------
-- 1. CITIZEN USERS
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
-- 2. CITIZEN VERIFICATIONS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `citizen_verifications` (
  `verification_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `citizen_user_id` INT UNSIGNED NOT NULL,

  -- Personal Information
  `first_name` VARCHAR(100) NOT NULL,
  `middle_name` VARCHAR(100) NULL DEFAULT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `suffix` VARCHAR(20) NULL DEFAULT NULL,
  `sex` ENUM('Male', 'Female') NOT NULL,
  `place_of_birth` VARCHAR(255) NOT NULL,
  `birth_date` DATE NOT NULL,
  `civil_status` VARCHAR(100) NOT NULL,
  `employment_status` VARCHAR(100) NOT NULL,
  `occupation` VARCHAR(150) NOT NULL,
  `educational_attainment` VARCHAR(100) NOT NULL,

  -- Residency & Location
  `district` VARCHAR(50) NOT NULL,
  `barangay` VARCHAR(100) NOT NULL,
  `street_address` VARCHAR(255) NOT NULL,
  `years_resident` INT UNSIGNED NOT NULL DEFAULT 1,

  -- Identification & Biometrics
  `valid_id_type` VARCHAR(100) NOT NULL,
  `valid_id_number` VARCHAR(100) NOT NULL,
  `id_front_photo_url` LONGTEXT NULL DEFAULT NULL,
  `selfie_photo_url` LONGTEXT NULL DEFAULT NULL,

  -- Verification Workflow
  `verification_status` ENUM('Pending', 'Under_Review', 'Approved', 'Rejected') NOT NULL DEFAULT 'Pending',
  `rejection_reason` TEXT NULL DEFAULT NULL,
  `reviewed_by` VARCHAR(100) NULL DEFAULT NULL,
  `reviewed_at` DATETIME NULL DEFAULT NULL,
  `submitted_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX `idx_verif_user_id` (`citizen_user_id`),
  INDEX `idx_verif_status` (`verification_status`),
  INDEX `idx_verif_barangay` (`barangay`),
  INDEX `idx_verif_submitted_at` (`submitted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 3. SEED DATA (For Testing)
-- ------------------------------------------------------------------------------
INSERT IGNORE INTO `citizen_users` (
  `citizen_user_id`, `first_name`, `middle_name`, `last_name`, `suffix`,
  `email`, `mobile_number`, `status`, `registry_completed`, `biometric_enabled`
) VALUES (
  1001, 'Danny', 'Toledano', 'Espelita', 'Jr.',
  'danny.espelita@civentral.ph', '09171234567', 'Active', 1, 1
);
