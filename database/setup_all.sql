-- ==============================================================================
-- CIVENTRAL MASTER CONSOLIDATED DATABASE SETUP SCRIPT
-- Sets up both `citizen_verification` and `civentral_certificates` databases
-- Safe for repeated runs: idempotency guaranteed (CREATE IF NOT EXISTS / ON DUPLICATE)
-- ==============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ------------------------------------------------------------------------------
-- DATABASE PROVISIONING
-- ------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS `citizen_verification` 
  DEFAULT CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS `civentral_certificates` 
  DEFAULT CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

-- ==============================================================================
-- SECTION 1: citizen_verification (Core Registry, Grievances, Consultations)
-- ==============================================================================
USE `citizen_verification`;

-- 1. citizen_users
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

-- 2. citizen_verifications
CREATE TABLE IF NOT EXISTS `citizen_verifications` (
  `verification_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `citizen_user_id` INT UNSIGNED NOT NULL,
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
  `district` VARCHAR(50) NOT NULL,
  `barangay` VARCHAR(100) NOT NULL,
  `street_address` VARCHAR(255) NOT NULL,
  `years_resident` INT UNSIGNED NOT NULL,
  `valid_id_type` VARCHAR(100) NOT NULL,
  `valid_id_number` VARCHAR(100) NOT NULL,
  `id_front_photo_url` VARCHAR(500) NULL DEFAULT NULL,
  `selfie_photo_url` VARCHAR(500) NULL DEFAULT NULL,
  `verification_status` ENUM('Pending', 'Under_Review', 'Approved', 'Rejected') NOT NULL DEFAULT 'Pending',
  `rejection_reason` TEXT NULL DEFAULT NULL,
  `reviewed_by_employee_id` INT UNSIGNED NULL DEFAULT NULL,
  `reviewed_at` DATETIME NULL DEFAULT NULL,
  `submitted_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_verif_user_id` (`citizen_user_id`),
  INDEX `idx_verif_status` (`verification_status`),
  INDEX `idx_verif_barangay` (`barangay`),
  INDEX `idx_verif_submitted_at` (`submitted_at`),
  CONSTRAINT `fk_verif_user` FOREIGN KEY (`citizen_user_id`)
    REFERENCES `citizen_users` (`citizen_user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. citizens
CREATE TABLE IF NOT EXISTS `citizens` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `first_name` VARCHAR(100) NOT NULL,
  `middle_name` VARCHAR(100) DEFAULT '',
  `last_name` VARCHAR(100) NOT NULL,
  `suffix` VARCHAR(20) DEFAULT '',
  `birthdate` DATE DEFAULT NULL,
  `gender` VARCHAR(20) DEFAULT 'Male',
  `civil_status` VARCHAR(50) DEFAULT 'Single',
  `contact_number` VARCHAR(50) DEFAULT '',
  `email` VARCHAR(150) DEFAULT '',
  `address` TEXT DEFAULT NULL,
  `barangay` VARCHAR(100) DEFAULT '',
  `id_type` VARCHAR(100) DEFAULT '',
  `id_number` VARCHAR(100) DEFAULT '',
  `id_photo_url` TEXT DEFAULT NULL,
  `selfie_photo_url` TEXT DEFAULT NULL,
  `verification_status` ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
  `rejection_reason` TEXT DEFAULT NULL,
  `submitted_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `verified_at` DATETIME DEFAULT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_status` (`verification_status`),
  INDEX `idx_email` (`email`),
  INDEX `idx_barangay` (`barangay`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. citizen_concerns (with AI Triage attributes)
CREATE TABLE IF NOT EXISTS `citizen_concerns` (
  `concern_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `ticket_number` VARCHAR(50) UNIQUE NOT NULL,
  `reference_no` VARCHAR(50) NULL,
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
  `status` ENUM('New', 'Under Review', 'Routed', 'In Progress', 'Resolved', 'Closed', 'Dismissed') NOT NULL DEFAULT 'New',
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

-- 5. departments
CREATE TABLE IF NOT EXISTS `departments` (
  `department_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `department_code` VARCHAR(20) NOT NULL UNIQUE,
  `department_name` VARCHAR(150) NOT NULL,
  `description` TEXT NULL,
  `icon` VARCHAR(50) DEFAULT 'fa-solid fa-building',
  `default_priority` ENUM('Urgent', 'High', 'Medium', 'Low') DEFAULT 'Medium',
  `default_sla` VARCHAR(50) DEFAULT '48 Hours',
  `status` ENUM('Active', 'Inactive') DEFAULT 'Active',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. duplicate_flags
CREATE TABLE IF NOT EXISTS `duplicate_flags` (
  `flag_id`           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `flag_code`         VARCHAR(30) NOT NULL UNIQUE,
  `verification_id_a` INT UNSIGNED NOT NULL,
  `verification_id_b` INT UNSIGNED NOT NULL,
  `matching_criteria` VARCHAR(150) NOT NULL,
  `match_confidence`  TINYINT UNSIGNED NOT NULL DEFAULT 95,
  `status`            ENUM('Pending','Merged','Dismissed') NOT NULL DEFAULT 'Pending',
  `resolution_notes`  TEXT NULL DEFAULT NULL,
  `master_record_id`  INT UNSIGNED NULL DEFAULT NULL,
  `resolved_by`       VARCHAR(150) NULL DEFAULT NULL,
  `resolved_at`       DATETIME NULL DEFAULT NULL,
  `detected_at`       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_df_status` (`status`),
  INDEX `idx_df_vid_a`  (`verification_id_a`),
  INDEX `idx_df_vid_b`  (`verification_id_b`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. certificate_requests
CREATE TABLE IF NOT EXISTS `certificate_requests` (
  `request_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `reference_no` VARCHAR(50) NOT NULL UNIQUE,
  `citizen_user_id` INT UNSIGNED NULL,
  `citizen_name` VARCHAR(150) NOT NULL,
  `contact_number` VARCHAR(50) NULL,
  `email` VARCHAR(150) NULL,
  `street_address` VARCHAR(255) NOT NULL,
  `barangay` VARCHAR(100) NOT NULL,
  `district` VARCHAR(50) NULL DEFAULT 'District 1',
  `civil_status` VARCHAR(50) NULL DEFAULT 'Single',
  `resident_since` VARCHAR(50) NULL DEFAULT '2015',
  `certificate_type` VARCHAR(100) NOT NULL,
  `purpose` VARCHAR(255) NOT NULL,
  `purpose_details` TEXT NULL,
  `additional_notes` TEXT NULL,
  `fee_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `payment_status` ENUM('Pending', 'Paid', 'Waived') NOT NULL DEFAULT 'Pending',
  `or_number` VARCHAR(50) NULL,
  `uploaded_documents` TEXT NULL,
  `status` ENUM('Pending', 'Under Review', 'Approved', 'Ready for Release', 'Released', 'Rejected') NOT NULL DEFAULT 'Pending',
  `encoded_by` VARCHAR(100) NOT NULL DEFAULT 'Citizen Mobile App',
  `verification_notes` TEXT NULL,
  `rejection_reason` TEXT NULL,
  `approved_by` VARCHAR(100) NULL,
  `approved_at` DATETIME NULL,
  `released_by` VARCHAR(100) NULL,
  `released_at` DATETIME NULL,
  `reprint_count` INT NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_status` (`status`),
  INDEX `idx_cert_type` (`certificate_type`),
  INDEX `idx_barangay` (`barangay`),
  INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. issued_certificates
CREATE TABLE IF NOT EXISTS `issued_certificates` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `certificate_control_no` VARCHAR(50) NOT NULL UNIQUE,
  `request_id` INT UNSIGNED NOT NULL,
  `reference_no` VARCHAR(50) NOT NULL,
  `citizen_id` VARCHAR(50) NULL,
  `citizen_name` VARCHAR(150) NOT NULL,
  `certificate_type` VARCHAR(100) NOT NULL,
  `purpose` VARCHAR(255) NULL,
  `or_number` VARCHAR(50) NULL,
  `fee_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `released_by` VARCHAR(100) NOT NULL DEFAULT 'Admin Staff',
  `date_released` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reprint_count` INT NOT NULL DEFAULT 0,
  `security_seal_hash` VARCHAR(100) NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_control_no` (`certificate_control_no`),
  INDEX `idx_ref_no` (`reference_no`),
  INDEX `idx_released` (`date_released`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9. certificate_payments
CREATE TABLE IF NOT EXISTS `certificate_payments` (
  `payment_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `or_number` VARCHAR(50) NOT NULL,
  `reference_no` VARCHAR(50) NOT NULL,
  `citizen_name` VARCHAR(150) NOT NULL,
  `certificate_type` VARCHAR(100) NOT NULL,
  `amount_due` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `amount_paid` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `payment_status` ENUM('Pending', 'Paid', 'Waived') NOT NULL DEFAULT 'Paid',
  `cashier_name` VARCHAR(100) NOT NULL DEFAULT 'Barangay Treasury Desk',
  `payment_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_or` (`or_number`),
  INDEX `idx_payment_date` (`payment_date`),
  INDEX `idx_pstatus` (`payment_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 10. id_issuance_applications
CREATE TABLE IF NOT EXISTS `id_issuance_applications` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `reference_no` VARCHAR(50) NOT NULL UNIQUE,
  `citizen_user_id` INT UNSIGNED NULL DEFAULT NULL,
  `id_category` VARCHAR(50) NOT NULL DEFAULT 'citizen_id',
  `id_title` VARCHAR(150) NOT NULL DEFAULT 'Caloocan Citizen Unified ID Card',
  `application_type` ENUM('New Application', 'Renewal', 'Replacement') NOT NULL DEFAULT 'New Application',
  `first_name` VARCHAR(100) NOT NULL,
  `middle_name` VARCHAR(100) NULL DEFAULT '',
  `last_name` VARCHAR(100) NOT NULL,
  `suffix` VARCHAR(20) NULL DEFAULT '',
  `gender` VARCHAR(20) NOT NULL DEFAULT 'Male',
  `birthdate` DATE NULL DEFAULT NULL,
  `civil_status` VARCHAR(50) NOT NULL DEFAULT 'Single',
  `contact_number` VARCHAR(50) NOT NULL,
  `email` VARCHAR(150) NULL DEFAULT NULL,
  `street_address` VARCHAR(255) NOT NULL,
  `barangay` VARCHAR(100) NOT NULL,
  `district` VARCHAR(50) NOT NULL DEFAULT 'District 1',
  `resident_since` VARCHAR(50) NOT NULL DEFAULT '2015',
  `issuing_bureau` VARCHAR(200) NOT NULL DEFAULT 'Caloocan Civil Registry & Identity Management Bureau',
  `claim_office` VARCHAR(200) NOT NULL DEFAULT 'Caloocan Main City Hall - Window 6',
  `estimated_turnaround` VARCHAR(100) NOT NULL DEFAULT '3 to 5 Business Days',
  `primary_doc_name` VARCHAR(150) NULL DEFAULT 'Valid Identification Document',
  `primary_doc_url` MEDIUMTEXT NULL DEFAULT NULL,
  `photo_2x2_url` MEDIUMTEXT NULL DEFAULT NULL,
  `support_doc_name` VARCHAR(150) NULL DEFAULT NULL,
  `support_doc_url` MEDIUMTEXT NULL DEFAULT NULL,
  `status` ENUM(
    'Pending Review',
    'Under Review',
    'Approved',
    'Ready for Release',
    'Claimed',
    'Rejected'
  ) NOT NULL DEFAULT 'Pending Review',
  `review_notes` TEXT NULL DEFAULT NULL,
  `rejection_reason` TEXT NULL DEFAULT NULL,
  `reviewed_by` VARCHAR(100) NULL DEFAULT NULL,
  `reviewed_at` DATETIME NULL DEFAULT NULL,
  `released_by` VARCHAR(100) NULL DEFAULT NULL,
  `released_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_id_category` (`id_category`),
  INDEX `idx_app_status` (`status`),
  INDEX `idx_barangay` (`barangay`),
  INDEX `idx_ref_no` (`reference_no`),
  INDEX `idx_user_id` (`citizen_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 11. id_cards_issued
CREATE TABLE IF NOT EXISTS `id_cards_issued` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `card_control_no` VARCHAR(60) NOT NULL UNIQUE,
  `application_id` INT UNSIGNED NOT NULL,
  `reference_no` VARCHAR(50) NOT NULL,
  `citizen_name` VARCHAR(150) NOT NULL,
  `id_category` VARCHAR(50) NOT NULL,
  `barangay` VARCHAR(100) NOT NULL,
  `date_issued` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_expiry` DATE NULL DEFAULT NULL,
  `qr_security_hash` VARCHAR(128) NOT NULL,
  `issued_by` VARCHAR(100) NOT NULL DEFAULT 'ID Production Desk Officer',
  `status` ENUM('Active', 'Expired', 'Revoked', 'Lost') NOT NULL DEFAULT 'Active',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_control_no` (`card_control_no`),
  INDEX `idx_card_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 12. id_issuance_audit_logs
CREATE TABLE IF NOT EXISTS `id_issuance_audit_logs` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `application_id` INT UNSIGNED NOT NULL,
  `action` VARCHAR(50) NOT NULL,
  `previous_status` VARCHAR(50) NULL DEFAULT NULL,
  `new_status` VARCHAR(50) NOT NULL,
  `officer_name` VARCHAR(100) NOT NULL,
  `remarks` TEXT NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_audit_app_id` (`application_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 13. broadcast_alerts
CREATE TABLE IF NOT EXISTS `broadcast_alerts` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `alert_id` VARCHAR(50) NOT NULL UNIQUE,
  `title` VARCHAR(255) NOT NULL,
  `body` TEXT NOT NULL,
  `category` VARCHAR(100) NOT NULL DEFAULT 'Broadcast',
  `priority` ENUM('Normal', 'High', 'Urgent') NOT NULL DEFAULT 'Normal',
  `channels` VARCHAR(150) NOT NULL DEFAULT 'In-App, Push',
  `target_audience` VARCHAR(150) NOT NULL DEFAULT 'All Registered Citizens',
  `target_barangay` VARCHAR(150) NOT NULL DEFAULT 'All Barangays',
  `sender_name` VARCHAR(150) NOT NULL DEFAULT 'City Central Command & Public Info Bureau',
  `sender_role` VARCHAR(150) NOT NULL DEFAULT 'Public Information Officer',
  `status` ENUM('Delivered', 'Sent', 'Scheduled', 'Draft') NOT NULL DEFAULT 'Delivered',
  `recipients_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `delivered_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `failed_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `pending_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `attachment_url` VARCHAR(500) NULL,
  `scheduled_at` DATETIME NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_created_at` (`created_at`),
  INDEX `idx_category` (`category`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 14. public_surveys
CREATE TABLE IF NOT EXISTS `public_surveys` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `survey_code` VARCHAR(50) NOT NULL UNIQUE,
  `title` VARCHAR(255) NOT NULL,
  `short_description` TEXT NOT NULL,
  `category` VARCHAR(100) NOT NULL,
  `estimated_time` VARCHAR(50) NOT NULL DEFAULT '3 mins',
  `target_audience` VARCHAR(100) NOT NULL DEFAULT 'All Residents',
  `sub_target` VARCHAR(150) NULL,
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

-- 15. survey_questions
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
  INDEX `idx_question_survey` (`survey_id`, `question_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 16. survey_responses
CREATE TABLE IF NOT EXISTS `survey_responses` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `survey_id` INT NOT NULL,
  `citizen_id` INT NULL,
  `citizen_name` VARCHAR(150) NOT NULL DEFAULT 'Anonymous Citizen',
  `barangay` VARCHAR(100) NULL,
  `age_group` VARCHAR(50) NULL,
  `gender` VARCHAR(30) NULL,
  `answers_json` JSON NOT NULL,
  `overall_rating` DECIMAL(3,2) NULL,
  `commentary` TEXT NULL,
  `submitted_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_response_survey` (`survey_id`),
  INDEX `idx_response_date` (`submitted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 17. civic_consultations
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

-- 18. consultation_feedbacks
CREATE TABLE IF NOT EXISTS `consultation_feedbacks` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `consultation_id` INT NOT NULL,
  `citizen_id` INT NULL,
  `citizen_name` VARCHAR(150) NOT NULL DEFAULT 'Caloocan Resident',
  `barangay` VARCHAR(100) NULL,
  `stance` ENUM('In Favor', 'Neutral', 'Against', 'Suggested Amendments') NOT NULL DEFAULT 'In Favor',
  `commentary` TEXT NOT NULL,
  `submitted_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_feedback_consultation` (`consultation_id`),
  INDEX `idx_feedback_stance` (`stance`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 19. consultation_outcomes
CREATE TABLE IF NOT EXISTS `consultation_outcomes` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `consultation_id` INT NOT NULL UNIQUE,
  `key_findings` TEXT NOT NULL,
  `policy_outcome` TEXT NOT NULL,
  `ordinance_number` VARCHAR(100) NULL,
  `allocated_budget` VARCHAR(100) NULL,
  `transparency_score` VARCHAR(50) NOT NULL DEFAULT '100% Published & Verified',
  `pdf_filename` VARCHAR(255) NULL,
  `published_by` VARCHAR(150) NOT NULL DEFAULT 'City Council Secretariat',
  `published_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 20. community_ratings (Civic Ratings & Feedback)
CREATE TABLE IF NOT EXISTS `community_ratings` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `feedback_ref` VARCHAR(50) NOT NULL UNIQUE,
  `citizen_name` VARCHAR(150) NOT NULL DEFAULT 'Anonymous Citizen',
  `citizen_email` VARCHAR(150) NULL,
  `citizen_barangay` VARCHAR(100) NOT NULL DEFAULT 'Barangay Central',
  `service_name` VARCHAR(150) NOT NULL,
  `transaction_ref` VARCHAR(100) NULL,
  `overall_rating` TINYINT UNSIGNED NOT NULL DEFAULT 5,
  `quality_rating` TINYINT UNSIGNED NOT NULL DEFAULT 5,
  `staff_rating` TINYINT UNSIGNED NOT NULL DEFAULT 5,
  `comments` TEXT NULL,
  `sentiment` ENUM('Positive', 'Neutral', 'Negative') NOT NULL DEFAULT 'Positive',
  `status` ENUM('Published', 'Pending', 'Archived') NOT NULL DEFAULT 'Published',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_sentiment` (`sentiment`),
  INDEX `idx_service` (`service_name`),
  INDEX `idx_overall_rating` (`overall_rating`),
  INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- SEED DATA: citizen_verification
-- ------------------------------------------------------------------------------

-- Seed 11 Municipal Departments
INSERT INTO `departments` (`department_id`, `department_code`, `department_name`, `description`, `icon`, `default_priority`, `default_sla`, `status`) VALUES
(1, 'IT', 'Information Technology Department', 'Network infrastructure, portal security, citizen mobile systems, and LGU systems integration.', 'fa-solid fa-laptop-code', 'Medium', '24 Hours', 'Active'),
(4, 'ESMS', 'Education & Scholarship', 'Municipal scholarship programs, student grants, educational assistance, and academic awards.', 'fa-solid fa-graduation-cap', 'Low', '72 Hours', 'Active'),
(5, 'CIE', 'Citizenship Information  & Engagement', 'Citizen registry, grievance intake, community feedback, public polls, and civic engagement.', 'fa-solid fa-comments', 'Low', '72 Hours', 'Active'),
(6, 'PLM', 'Permits & Licensing Management', 'Business licenses, local commercial clearances, special permits, and regulatory compliance.', 'fa-solid fa-file-contract', 'Medium', '72 Hours', 'Active'),
(7, 'SSM', 'Social Services Management', 'Social welfare, indigent burial aid, senior citizens assistance, and solo parent welfare support.', 'fa-solid fa-hands-holding-child', 'Medium', '48 Hours', 'Active'),
(8, 'HSM', 'Health & Sanitation Management', 'City health centers, waste collection, public sanitization, vector control, and environmental inspection.', 'fa-solid fa-recycle', 'Medium', '48 Hours', 'Active'),
(9, 'DRRM', 'Disaster Risk Reduction & Emergency Response', 'Flood warning, emergency rescue, disaster preparedness, drainage clearance, and evacuation hubs.', 'fa-solid fa-water', 'Urgent', '4 Hours', 'Active'),
(10, 'UPZH', 'Urban Planning Zoning & Housing', 'Zoning permits, land use assessment, urban housing plans, and residential building compliance.', 'fa-solid fa-city', 'Medium', '72 Hours', 'Active'),
(11, 'RCTS', 'Revenue Collection & Treasury Services', 'Real property tax, assessment payments, municipal fee collections, and treasury disbursements.', 'fa-solid fa-coins', 'Low', '72 Hours', 'Active'),
(12, 'TMM', 'Transport & Mobility Management', 'Tricycle franchising, traffic control, route regulation, terminal permits, and road safety enforcement.', 'fa-solid fa-traffic-light', 'Medium', '48 Hours', 'Active'),
(13, 'PAFM', 'Public Assets & Facilities Management', 'City engineering, road repairs, pothole resurfacing, streetlights, bridges, and public grounds.', 'fa-solid fa-road', 'High', '24 Hours', 'Active')
ON DUPLICATE KEY UPDATE 
    `department_name` = VALUES(`department_name`),
    `description` = VALUES(`description`),
    `icon` = VALUES(`icon`),
    `default_priority` = VALUES(`default_priority`),
    `default_sla` = VALUES(`default_sla`);

-- Seed Default Test Citizen User
INSERT INTO `citizen_users` (
  `citizen_user_id`,
  `first_name`,
  `middle_name`,
  `last_name`,
  `suffix`,
  `email`,
  `mobile_number`,
  `status`,
  `registry_completed`,
  `biometric_enabled`
) VALUES (
  1001,
  'Danny',
  'Toledano',
  'Espelita',
  'Jr.',
  'danny.espelita@civentral.ph',
  '09171234567',
  'Active',
  1,
  1
) ON DUPLICATE KEY UPDATE
  `first_name` = VALUES(`first_name`),
  `last_name` = VALUES(`last_name`),
  `mobile_number` = VALUES(`mobile_number`);

-- Seed Default Test Citizen Verification
INSERT INTO `citizen_verifications` (
  `verification_id`,
  `citizen_user_id`,
  `first_name`,
  `middle_name`,
  `last_name`,
  `suffix`,
  `sex`,
  `place_of_birth`,
  `birth_date`,
  `civil_status`,
  `employment_status`,
  `occupation`,
  `educational_attainment`,
  `district`,
  `barangay`,
  `street_address`,
  `years_resident`,
  `valid_id_type`,
  `valid_id_number`,
  `id_front_photo_url`,
  `selfie_photo_url`,
  `verification_status`
) VALUES (
  1,
  1001,
  'Danny',
  'Toledano',
  'Espelita',
  'Jr.',
  'Male',
  'Caloocan City',
  '1998-05-15',
  'Single',
  'Employed (Private Sector)',
  'Corporate / Office Employee',
  'College / Bachelor Degree Graduate',
  'District 1',
  'Barangay 171 (Bagumbong)',
  'Block 12 Lot 5, Sampaguita St.',
  12,
  'Philippine Identification System (PhilSys) National ID',
  '1234-5678-9012-3456',
  '/uploads/id_cards/id_1001_sample.jpg',
  '/uploads/selfies/selfie_1001_sample.jpg',
  'Pending'
) ON DUPLICATE KEY UPDATE
  `verification_status` = VALUES(`verification_status`);


-- ==============================================================================
-- SECTION 2: civentral_certificates (Certificate & ID Subsystem)
-- ==============================================================================
USE `civentral_certificates`;

-- 1. certificate_requests
CREATE TABLE IF NOT EXISTS `certificate_requests` (
  `request_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `reference_no` VARCHAR(50) NOT NULL UNIQUE,
  `citizen_user_id` INT UNSIGNED NULL,
  `citizen_name` VARCHAR(150) NOT NULL,
  `contact_number` VARCHAR(50) NULL,
  `email` VARCHAR(150) NULL,
  `street_address` VARCHAR(255) NOT NULL,
  `barangay` VARCHAR(100) NOT NULL,
  `district` VARCHAR(50) NULL DEFAULT 'District 1',
  `civil_status` VARCHAR(50) NULL DEFAULT 'Single',
  `resident_since` VARCHAR(50) NULL DEFAULT '2015',
  `certificate_type` VARCHAR(100) NOT NULL,
  `purpose` VARCHAR(255) NOT NULL,
  `purpose_details` TEXT NULL,
  `additional_notes` TEXT NULL,
  `fee_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `payment_status` ENUM('Pending', 'Paid', 'Waived') NOT NULL DEFAULT 'Pending',
  `or_number` VARCHAR(50) NULL,
  `uploaded_documents` TEXT NULL,
  `status` ENUM('Pending', 'Under Review', 'Approved', 'Ready for Release', 'Released', 'Rejected') NOT NULL DEFAULT 'Pending',
  `encoded_by` VARCHAR(100) NOT NULL DEFAULT 'Citizen Mobile App',
  `verification_notes` TEXT NULL,
  `rejection_reason` TEXT NULL,
  `approved_by` VARCHAR(100) NULL,
  `approved_at` DATETIME NULL,
  `released_by` VARCHAR(100) NULL,
  `released_at` DATETIME NULL,
  `reprint_count` INT NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_status` (`status`),
  INDEX `idx_cert_type` (`certificate_type`),
  INDEX `idx_barangay` (`barangay`),
  INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. issued_certificates
CREATE TABLE IF NOT EXISTS `issued_certificates` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `certificate_control_no` VARCHAR(50) NOT NULL UNIQUE,
  `request_id` INT UNSIGNED NOT NULL,
  `reference_no` VARCHAR(50) NOT NULL,
  `citizen_id` VARCHAR(50) NULL,
  `citizen_name` VARCHAR(150) NOT NULL,
  `certificate_type` VARCHAR(100) NOT NULL,
  `purpose` VARCHAR(255) NULL,
  `or_number` VARCHAR(50) NULL,
  `fee_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `released_by` VARCHAR(100) NOT NULL DEFAULT 'Admin Staff',
  `date_released` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reprint_count` INT NOT NULL DEFAULT 0,
  `security_seal_hash` VARCHAR(100) NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_control_no` (`certificate_control_no`),
  INDEX `idx_ref_no` (`reference_no`),
  INDEX `idx_released` (`date_released`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. certificate_payments
CREATE TABLE IF NOT EXISTS `certificate_payments` (
  `payment_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `or_number` VARCHAR(50) NOT NULL,
  `reference_no` VARCHAR(50) NOT NULL,
  `citizen_name` VARCHAR(150) NOT NULL,
  `certificate_type` VARCHAR(100) NOT NULL,
  `amount_due` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `amount_paid` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `payment_status` ENUM('Pending', 'Paid', 'Waived') NOT NULL DEFAULT 'Paid',
  `cashier_name` VARCHAR(100) NOT NULL DEFAULT 'Barangay Treasury Desk',
  `payment_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_or` (`or_number`),
  INDEX `idx_payment_date` (`payment_date`),
  INDEX `idx_pstatus` (`payment_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. id_issuance_applications
CREATE TABLE IF NOT EXISTS `id_issuance_applications` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `reference_no` VARCHAR(50) NOT NULL UNIQUE,
  `citizen_user_id` INT UNSIGNED NULL DEFAULT NULL,
  `id_category` VARCHAR(50) NOT NULL DEFAULT 'citizen_id',
  `id_title` VARCHAR(150) NOT NULL DEFAULT 'Caloocan Citizen Unified ID Card',
  `application_type` ENUM('New Application', 'Renewal', 'Replacement') NOT NULL DEFAULT 'New Application',
  `first_name` VARCHAR(100) NOT NULL,
  `middle_name` VARCHAR(100) NULL DEFAULT '',
  `last_name` VARCHAR(100) NOT NULL,
  `suffix` VARCHAR(20) NULL DEFAULT '',
  `gender` VARCHAR(20) NOT NULL DEFAULT 'Male',
  `birthdate` DATE NULL DEFAULT NULL,
  `civil_status` VARCHAR(50) NOT NULL DEFAULT 'Single',
  `contact_number` VARCHAR(50) NOT NULL,
  `email` VARCHAR(150) NULL DEFAULT NULL,
  `street_address` VARCHAR(255) NOT NULL,
  `barangay` VARCHAR(100) NOT NULL,
  `district` VARCHAR(50) NOT NULL DEFAULT 'District 1',
  `resident_since` VARCHAR(50) NOT NULL DEFAULT '2015',
  `issuing_bureau` VARCHAR(200) NOT NULL DEFAULT 'Caloocan Civil Registry & Identity Management Bureau',
  `claim_office` VARCHAR(200) NOT NULL DEFAULT 'Caloocan Main City Hall - Window 6',
  `estimated_turnaround` VARCHAR(100) NOT NULL DEFAULT '3 to 5 Business Days',
  `primary_doc_name` VARCHAR(150) NULL DEFAULT 'Valid Identification Document',
  `primary_doc_url` MEDIUMTEXT NULL DEFAULT NULL,
  `photo_2x2_url` MEDIUMTEXT NULL DEFAULT NULL,
  `support_doc_name` VARCHAR(150) NULL DEFAULT NULL,
  `support_doc_url` MEDIUMTEXT NULL DEFAULT NULL,
  `status` ENUM(
    'Pending Review',
    'Under Review',
    'Approved',
    'Ready for Release',
    'Claimed',
    'Rejected'
  ) NOT NULL DEFAULT 'Pending Review',
  `review_notes` TEXT NULL DEFAULT NULL,
  `rejection_reason` TEXT NULL DEFAULT NULL,
  `reviewed_by` VARCHAR(100) NULL DEFAULT NULL,
  `reviewed_at` DATETIME NULL DEFAULT NULL,
  `released_by` VARCHAR(100) NULL DEFAULT NULL,
  `released_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_id_category` (`id_category`),
  INDEX `idx_app_status` (`status`),
  INDEX `idx_barangay` (`barangay`),
  INDEX `idx_ref_no` (`reference_no`),
  INDEX `idx_user_id` (`citizen_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. id_cards_issued
CREATE TABLE IF NOT EXISTS `id_cards_issued` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `card_control_no` VARCHAR(60) NOT NULL UNIQUE,
  `application_id` INT UNSIGNED NOT NULL,
  `reference_no` VARCHAR(50) NOT NULL,
  `citizen_name` VARCHAR(150) NOT NULL,
  `id_category` VARCHAR(50) NOT NULL,
  `barangay` VARCHAR(100) NOT NULL,
  `date_issued` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_expiry` DATE NULL DEFAULT NULL,
  `qr_security_hash` VARCHAR(128) NOT NULL,
  `issued_by` VARCHAR(100) NOT NULL DEFAULT 'ID Production Desk Officer',
  `status` ENUM('Active', 'Expired', 'Revoked', 'Lost') NOT NULL DEFAULT 'Active',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_control_no` (`card_control_no`),
  INDEX `idx_card_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. id_issuance_audit_logs
CREATE TABLE IF NOT EXISTS `id_issuance_audit_logs` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `application_id` INT UNSIGNED NOT NULL,
  `action` VARCHAR(50) NOT NULL,
  `previous_status` VARCHAR(50) NULL DEFAULT NULL,
  `new_status` VARCHAR(50) NOT NULL,
  `officer_name` VARCHAR(100) NOT NULL,
  `remarks` TEXT NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_audit_app_id` (`application_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. broadcast_alerts (Mirror)
CREATE TABLE IF NOT EXISTS `broadcast_alerts` LIKE `citizen_verification`.`broadcast_alerts`;

-- 8. public_surveys (Mirror)
CREATE TABLE IF NOT EXISTS `public_surveys` LIKE `citizen_verification`.`public_surveys`;

-- 9. survey_questions (Mirror)
CREATE TABLE IF NOT EXISTS `survey_questions` LIKE `citizen_verification`.`survey_questions`;

-- 10. survey_responses (Mirror)
CREATE TABLE IF NOT EXISTS `survey_responses` LIKE `citizen_verification`.`survey_responses`;

-- 11. civic_consultations (Mirror)
CREATE TABLE IF NOT EXISTS `civic_consultations` LIKE `citizen_verification`.`civic_consultations`;

-- 12. consultation_feedbacks (Mirror)
CREATE TABLE IF NOT EXISTS `consultation_feedbacks` LIKE `citizen_verification`.`consultation_feedbacks`;

-- 13. consultation_outcomes (Mirror)
CREATE TABLE IF NOT EXISTS `consultation_outcomes` LIKE `citizen_verification`.`consultation_outcomes`;

-- 14. community_ratings (Mirror)
CREATE TABLE IF NOT EXISTS `community_ratings` LIKE `citizen_verification`.`community_ratings`;

-- ------------------------------------------------------------------------------
-- CLEANUP & RESTORE FLAGS
-- ------------------------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 1;
