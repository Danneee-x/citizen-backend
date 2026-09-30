-- ==============================================================================
-- CIVENTRAL MUNICIPAL DEPARTMENTS MASTER DIRECTORY
-- Database: `citizen_verification`
-- Target Table: `departments`
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS `citizen_verification` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `citizen_verification`;

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
