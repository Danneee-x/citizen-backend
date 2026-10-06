-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: citizen_verification
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `citizen_verification`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `citizen_verification` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `citizen_verification`;

--
-- Table structure for table `broadcast_alerts`
--

DROP TABLE IF EXISTS `broadcast_alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `broadcast_alerts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `alert_id` varchar(50) NOT NULL COMMENT 'Unique alert code, e.g. CCN-ALT-2026-0001',
  `title` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `category` varchar(100) NOT NULL DEFAULT 'Broadcast' COMMENT 'Emergency Alert, Domain Update, Broadcast, General Announcement, Health Advisory, Curfew / Ordinance, Event',
  `priority` enum('Normal','High','Urgent') NOT NULL DEFAULT 'Normal',
  `channels` varchar(150) NOT NULL DEFAULT 'In-App, Push',
  `target_audience` varchar(150) NOT NULL DEFAULT 'All Registered Citizens',
  `target_barangay` varchar(150) NOT NULL DEFAULT 'All Barangays',
  `sender_name` varchar(150) NOT NULL DEFAULT 'City Central Command & Public Info Bureau',
  `sender_role` varchar(150) NOT NULL DEFAULT 'Public Information Officer',
  `status` enum('Delivered','Sent','Scheduled','Draft') NOT NULL DEFAULT 'Delivered',
  `recipients_count` int(10) unsigned NOT NULL DEFAULT 0,
  `delivered_count` int(10) unsigned NOT NULL DEFAULT 0,
  `failed_count` int(10) unsigned NOT NULL DEFAULT 0,
  `pending_count` int(10) unsigned NOT NULL DEFAULT 0,
  `attachment_url` varchar(500) DEFAULT NULL,
  `scheduled_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `alert_id` (`alert_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_category` (`category`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `broadcast_alerts`
--

LOCK TABLES `broadcast_alerts` WRITE;
/*!40000 ALTER TABLE `broadcast_alerts` DISABLE KEYS */;
INSERT INTO `broadcast_alerts` VALUES (1,'CCN-ALT-2026-4386','Typhoon Advisory #3 - Heavy Rainfall Alert','PAGASA has issued Orange Rainfall Warning for Caloocan City. Emergency evacuation centers at Barangay 176 are prepared and open.','Emergency','Urgent','In-App / Push, SMS','All Residents','All Barangays','Caloocan Public Information Office','Public Information Officer','Delivered',1420,1399,21,0,NULL,NULL,'2026-09-30 00:54:32','2026-09-30 00:54:32'),(2,'CCN-ALT-2026-1315','Health Advisory: Dengue Prevention & Fogging Schedule','Barangay Health Services will conduct synchronized anti-dengue misting and free larval inspections this Saturday starting 7:00 AM.','Health Advisory','High','In-App / Push, SMS, Email','All Residents','All Barangays','Caloocan Public Information Office','Public Information Officer','Delivered',1420,1399,21,0,NULL,NULL,'2026-09-30 01:00:44','2026-09-30 01:00:44'),(3,'CCN-ALT-2026-1082','baha','magingat sa baha','Emergency','Urgent','In-App / Push','All Residents','All Barangays','Caloocan Public Information Office','Public Information Officer','Delivered',1420,1399,21,0,'assets/uploads/alerts/alert_1790701497_a4a86022.jfif',NULL,'2026-09-30 01:04:57','2026-09-30 01:04:57'),(4,'CCN-ALT-2026-2224','Barilan','<b>Mag ingat sa barilan sa camarin</b>','Emergency','Urgent','In-App / Push','All Residents','All Barangays','Caloocan Public Information Office','Public Information Officer','Delivered',1,1,0,0,NULL,NULL,'2026-09-30 13:19:14','2026-09-30 13:19:14');
/*!40000 ALTER TABLE `broadcast_alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `certificate_payments`
--

DROP TABLE IF EXISTS `certificate_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `certificate_payments` (
  `payment_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `or_number` varchar(50) NOT NULL,
  `reference_no` varchar(50) NOT NULL,
  `citizen_name` varchar(150) NOT NULL,
  `certificate_type` varchar(100) NOT NULL,
  `amount_due` decimal(10,2) NOT NULL DEFAULT 0.00,
  `amount_paid` decimal(10,2) NOT NULL DEFAULT 0.00,
  `payment_status` enum('Pending','Paid','Waived') NOT NULL DEFAULT 'Paid',
  `cashier_name` varchar(100) NOT NULL DEFAULT 'Barangay Treasury Desk',
  `payment_date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`payment_id`),
  KEY `idx_or` (`or_number`),
  KEY `idx_payment_date` (`payment_date`),
  KEY `idx_pstatus` (`payment_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certificate_payments`
--

LOCK TABLES `certificate_payments` WRITE;
/*!40000 ALTER TABLE `certificate_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `certificate_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `certificate_requests`
--

DROP TABLE IF EXISTS `certificate_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `certificate_requests` (
  `request_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `reference_no` varchar(50) NOT NULL,
  `citizen_user_id` int(10) unsigned DEFAULT NULL,
  `citizen_name` varchar(150) NOT NULL,
  `contact_number` varchar(50) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `street_address` varchar(255) NOT NULL,
  `barangay` varchar(100) NOT NULL,
  `district` varchar(50) DEFAULT 'District 1',
  `civil_status` varchar(50) DEFAULT 'Single',
  `resident_since` varchar(50) DEFAULT '2015',
  `certificate_type` varchar(100) NOT NULL,
  `purpose` varchar(255) NOT NULL,
  `purpose_details` text DEFAULT NULL,
  `additional_notes` text DEFAULT NULL,
  `fee_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `payment_status` enum('Pending','Paid','Waived') NOT NULL DEFAULT 'Pending',
  `or_number` varchar(50) DEFAULT NULL,
  `uploaded_documents` text DEFAULT NULL,
  `status` enum('Pending','Under Review','Approved','Ready for Release','Released','Rejected') NOT NULL DEFAULT 'Pending',
  `encoded_by` varchar(100) NOT NULL DEFAULT 'Citizen Mobile App',
  `verification_notes` text DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `approved_by` varchar(100) DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `released_by` varchar(100) DEFAULT NULL,
  `released_at` datetime DEFAULT NULL,
  `reprint_count` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`request_id`),
  UNIQUE KEY `reference_no` (`reference_no`),
  KEY `idx_status` (`status`),
  KEY `idx_cert_type` (`certificate_type`),
  KEY `idx_barangay` (`barangay`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certificate_requests`
--

LOCK TABLES `certificate_requests` WRITE;
/*!40000 ALTER TABLE `certificate_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `certificate_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citizen_concerns`
--

DROP TABLE IF EXISTS `citizen_concerns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citizen_concerns` (
  `concern_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_number` varchar(50) NOT NULL,
  `citizen_user_id` int(10) unsigned DEFAULT NULL,
  `citizen_name` varchar(150) NOT NULL DEFAULT 'Anonymous Resident',
  `citizen_phone` varchar(50) DEFAULT NULL,
  `citizen_email` varchar(150) DEFAULT NULL,
  `is_anonymous` tinyint(1) NOT NULL DEFAULT 0,
  `category` varchar(100) NOT NULL,
  `sub_category` varchar(100) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `location` varchar(255) NOT NULL DEFAULT '',
  `barangay` varchar(100) NOT NULL DEFAULT '',
  `district` varchar(50) DEFAULT 'District 1',
  `gps_coordinates` varchar(100) DEFAULT NULL,
  `status` enum('New','Under Review','Routed','In Progress','Resolved','Closed') NOT NULL DEFAULT 'New',
  `priority` enum('Urgent','High','Medium','Low') NOT NULL DEFAULT 'Medium',
  `assigned_department` varchar(150) DEFAULT NULL,
  `ai_detected_category` varchar(100) DEFAULT NULL,
  `ai_confidence_score` varchar(100) DEFAULT NULL,
  `ai_reason` text DEFAULT NULL,
  `photo_evidence_url` mediumtext DEFAULT NULL,
  `attachments` text DEFAULT NULL,
  `resolution_notes` text DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`concern_id`),
  UNIQUE KEY `ticket_number` (`ticket_number`),
  KEY `idx_status` (`status`),
  KEY `idx_category` (`category`),
  KEY `idx_priority` (`priority`),
  KEY `idx_barangay` (`barangay`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citizen_concerns`
--

LOCK TABLES `citizen_concerns` WRITE;
/*!40000 ALTER TABLE `citizen_concerns` DISABLE KEYS */;
INSERT INTO `citizen_concerns` VALUES (1,'CAL-REP-2026-1607',NULL,'Anonymous Resident',NULL,NULL,0,'Government Service',NULL,'staff was rude','staff was rude during counter inquiry','','Barangay 123','District 1',NULL,'New','Low',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-09-30 12:41:57','2026-09-30 22:05:34'),(2,'CAL-REP-2026-2397',NULL,'Danny Toledano Espelita Jr.',NULL,NULL,0,'Public Safety',NULL,'GUn fight','merong nag babarilan dito sa kanto ng camarin','','Barangay 178','District 1',NULL,'Closed','Urgent',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-09-30 12:47:48','2026-09-30 22:05:34'),(13,'CAL-REP-2026-9045',NULL,'Anonymous Resident',NULL,NULL,0,'Road & Infrastructure',NULL,'sinkhole','may sinkhole dito sa kalsada peligroso sa mga motorista','','Barangay 121','District 1',NULL,'Closed','Urgent',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-09-30 13:51:12','2026-09-30 22:05:34');
/*!40000 ALTER TABLE `citizen_concerns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citizen_users`
--

DROP TABLE IF EXISTS `citizen_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citizen_users` (
  `citizen_user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `has_no_middle_name` tinyint(1) NOT NULL DEFAULT 0,
  `last_name` varchar(100) NOT NULL,
  `suffix` varchar(20) DEFAULT NULL,
  `email` varchar(191) NOT NULL,
  `mobile_number` varchar(30) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `status` enum('Pending','Active','Inactive','Locked','Archived') NOT NULL DEFAULT 'Active',
  `registry_completed` tinyint(1) NOT NULL DEFAULT 0,
  `failed_attempts` int(11) NOT NULL DEFAULT 0,
  `last_login` datetime DEFAULT NULL,
  `biometric_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`citizen_user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=1003 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citizen_users`
--

LOCK TABLES `citizen_users` WRITE;
/*!40000 ALTER TABLE `citizen_users` DISABLE KEYS */;
INSERT INTO `citizen_users` VALUES (35,'Vice','G',0,'Ganda',NULL,'espelitadanny@gmail.com','09630902025',NULL,'Active',1,0,NULL,0,'2026-09-30 14:27:34','2026-09-30 22:06:32',NULL),(1001,'Danny','Toledano',0,'Espelita','Jr.','danny.espelita@civentral.ph','09171234567',NULL,'Active',1,0,NULL,1,'2026-09-30 13:26:00','2026-09-30 22:06:32',NULL),(1002,'Jean',NULL,0,'Gray',NULL,'eanray_1002@citizen.local','09000001002',NULL,'Active',0,0,NULL,0,'2026-09-30 14:00:30','2026-09-30 22:06:32',NULL);
/*!40000 ALTER TABLE `citizen_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citizen_verifications`
--

DROP TABLE IF EXISTS `citizen_verifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citizen_verifications` (
  `verification_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `citizen_user_id` int(10) unsigned NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) NOT NULL,
  `suffix` varchar(20) DEFAULT NULL,
  `sex` enum('Male','Female') NOT NULL,
  `place_of_birth` varchar(255) NOT NULL,
  `birth_date` date NOT NULL,
  `civil_status` enum('Single','Married','Widowed','Separated','Divorced / Annulled','Common-Law / Live-In') NOT NULL,
  `employment_status` varchar(100) NOT NULL,
  `occupation` varchar(150) NOT NULL,
  `educational_attainment` varchar(100) NOT NULL,
  `district` varchar(50) NOT NULL,
  `barangay` varchar(100) NOT NULL,
  `street_address` varchar(255) NOT NULL,
  `years_resident` int(10) unsigned NOT NULL,
  `valid_id_type` varchar(100) NOT NULL,
  `valid_id_number` varchar(100) NOT NULL,
  `id_front_photo_url` mediumtext DEFAULT NULL,
  `selfie_photo_url` mediumtext DEFAULT NULL,
  `verification_status` enum('Pending','Under_Review','Approved','Rejected') NOT NULL DEFAULT 'Pending',
  `rejection_reason` text DEFAULT NULL,
  `reviewed_by_employee_id` int(10) unsigned DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `reviewed_by` varchar(100) DEFAULT NULL,
  `is_duplicate` tinyint(1) NOT NULL DEFAULT 0,
  `duplicate_notes` text DEFAULT NULL,
  PRIMARY KEY (`verification_id`),
  KEY `idx_verif_user_id` (`citizen_user_id`),
  KEY `idx_verif_status` (`verification_status`),
  KEY `idx_verif_barangay` (`barangay`),
  KEY `idx_verif_submitted_at` (`submitted_at`),
  CONSTRAINT `fk_verif_user` FOREIGN KEY (`citizen_user_id`) REFERENCES `citizen_users` (`citizen_user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citizen_verifications`
--

LOCK TABLES `citizen_verifications` WRITE;
/*!40000 ALTER TABLE `citizen_verifications` DISABLE KEYS */;
INSERT INTO `citizen_verifications` VALUES (1,1001,'Danny','Toledano','Espelita','Jr.','Male','Caloocan City','1998-05-15','Single','Employed (Private Sector)','Software Engineer','College Graduate','District 1','Barangay 171 (Bagumbong)','123 Sampaguita St.',15,'Philippine Identification System (PhilSys) National ID','1234-5678-9012-3456',NULL,NULL,'Pending',NULL,NULL,NULL,'2026-09-30 13:26:00','2026-09-30 22:06:32',NULL,0,NULL),(9,1002,'Jean',NULL,'Gray',NULL,'Female','Caloocan City','1995-10-20','Single','Employed (Private Sector)','Designer','College Graduate','District 3','Barangay 178','45 Camarin Rd.',8,'PhilSys National ID','9876-5432-1098-7654',NULL,NULL,'Pending',NULL,NULL,NULL,'2026-09-30 14:00:30','2026-09-30 22:06:32',NULL,0,NULL),(11,35,'Vice','G','Ganda',NULL,'Male','Manila','1976-03-31','Single','Self-Employed / Freelancer','Host & Artist','College Graduate','District 2','Barangay 77','100 Rizal Ave.',20,'PhilSys National ID','4444-5555-6666-7777',NULL,NULL,'Approved',NULL,NULL,NULL,'2026-09-30 14:28:00','2026-09-30 22:06:32',NULL,0,NULL);
/*!40000 ALTER TABLE `citizen_verifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citizens`
--

DROP TABLE IF EXISTS `citizens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citizens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT '',
  `last_name` varchar(100) NOT NULL,
  `suffix` varchar(20) DEFAULT '',
  `birthdate` date DEFAULT NULL,
  `gender` varchar(20) DEFAULT 'Male',
  `civil_status` varchar(50) DEFAULT 'Single',
  `contact_number` varchar(50) DEFAULT '',
  `email` varchar(150) DEFAULT '',
  `address` text DEFAULT NULL,
  `barangay` varchar(100) DEFAULT '',
  `id_type` varchar(100) DEFAULT '',
  `id_number` varchar(100) DEFAULT '',
  `id_photo_url` text DEFAULT NULL,
  `selfie_photo_url` text DEFAULT NULL,
  `verification_status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `rejection_reason` text DEFAULT NULL,
  `submitted_at` datetime DEFAULT current_timestamp(),
  `verified_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_status` (`verification_status`),
  KEY `idx_email` (`email`),
  KEY `idx_barangay` (`barangay`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citizens`
--

LOCK TABLES `citizens` WRITE;
/*!40000 ALTER TABLE `citizens` DISABLE KEYS */;
/*!40000 ALTER TABLE `citizens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `civic_consultations`
--

DROP TABLE IF EXISTS `civic_consultations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `civic_consultations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consultation_code` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `category` varchar(100) NOT NULL,
  `background_info` text NOT NULL,
  `objective` text NOT NULL,
  `closing_date` date NOT NULL,
  `status` enum('Open','Closing Soon','Under Review','Closed / Outcome Published') NOT NULL DEFAULT 'Open',
  `created_by` varchar(150) NOT NULL DEFAULT 'City Legal & Policy Board',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `consultation_code` (`consultation_code`),
  KEY `idx_consultation_status` (`status`),
  KEY `idx_consultation_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `civic_consultations`
--

LOCK TABLES `civic_consultations` WRITE;
/*!40000 ALTER TABLE `civic_consultations` DISABLE KEYS */;
INSERT INTO `civic_consultations` VALUES (1,'CNS-2026-101','Draft City Ordinance: Residential Quiet Hours & Anti-Noise Regulation','Public Safety & Ordinances','The City Council is deliberating proposed regulations on commercial videoke, street loudspeakers, and construction noise in high-density barangays.','Gather community consensus on establishing mandatory residential quiet hours from 10:00 PM to 6:00 AM on weekdays.','2026-10-20','Open','City Legal & Policy Board','2026-09-30 22:08:08','2026-09-30 22:08:08'),(2,'CNS-2026-102','Caloocan Green Corridors & Solar Streetlighting Expansion Program','Urban Planning & Environment','A city-wide environmental transition project targeting high-traffic pedestrian avenues across North and South Caloocan.','Identify priority streets for solar-powered lighting posts, pocket tree parks, and permeable sidewalk paving.','2026-11-15','Open','City Legal & Policy Board','2026-09-30 22:08:08','2026-09-30 22:08:08');
/*!40000 ALTER TABLE `civic_consultations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `community_ratings`
--

DROP TABLE IF EXISTS `community_ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `community_ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `feedback_ref` varchar(50) NOT NULL,
  `citizen_name` varchar(150) DEFAULT 'Anonymous Citizen',
  `citizen_email` varchar(150) DEFAULT NULL,
  `citizen_barangay` varchar(100) DEFAULT 'Barangay Central',
  `service_name` varchar(150) NOT NULL,
  `transaction_ref` varchar(100) DEFAULT NULL,
  `overall_rating` tinyint(4) NOT NULL DEFAULT 5,
  `quality_rating` tinyint(4) NOT NULL DEFAULT 5,
  `staff_rating` tinyint(4) NOT NULL DEFAULT 5,
  `comments` text DEFAULT NULL,
  `sentiment` enum('Positive','Neutral','Negative') DEFAULT 'Positive',
  `status` enum('Published','Reviewed','Pending','Flagged') DEFAULT 'Published',
  `attachment_url` varchar(255) DEFAULT NULL,
  `admin_notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `feedback_ref` (`feedback_ref`),
  KEY `idx_service` (`service_name`),
  KEY `idx_rating` (`overall_rating`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `community_ratings`
--

LOCK TABLES `community_ratings` WRITE;
/*!40000 ALTER TABLE `community_ratings` DISABLE KEYS */;
INSERT INTO `community_ratings` VALUES (1,'CFB-2026-1001','Danny Espelita','danny.espelita@civentral.ph','Barangay 176','Barangay Clearance & Residency Certificate','CAL-BC-2026-0881',5,5,5,'Smooth process at the barangay hall window. Released in less than 15 minutes after online QR scanning.','Positive','Published',NULL,NULL,'2026-09-28 09:30:00','2026-09-30 22:04:44'),(2,'CFB-2026-1002','Maria Santos','maria.santos@gmail.com','Barangay 171','Caloocan City Health Center Consultation','CAL-HC-2026-4412',4,4,5,'The doctor and nurses were very polite and accommodating. The waiting area was clean and well ventilated.','Positive','Published',NULL,NULL,'2026-09-28 14:15:00','2026-09-30 22:04:44'),(3,'CFB-2026-1003','Anonymous Citizen',NULL,'Barangay 178','Road Maintenance & Pothole Repair','CAL-REP-2026-9045',5,5,4,'Engineering department dispatched asphalt repair crew within 48 hours of filing report. Excellent turnaround.','Positive','Published',NULL,NULL,'2026-09-29 11:00:00','2026-09-30 22:04:44'),(4,'CFB-2026-1004','Juan Dela Cruz','juan.delacruz@civentral.ph','Barangay 176','Senior Citizen & OSCA ID Processing','CAL-CIT-2026-4412',5,5,5,'Assisted my grandmother with her senior ID renewal. Very patient staff at Window 6.','Positive','Published',NULL,NULL,'2026-09-30 10:20:00','2026-09-30 22:04:44');
/*!40000 ALTER TABLE `community_ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consultation_feedbacks`
--

DROP TABLE IF EXISTS `consultation_feedbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consultation_feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consultation_id` int(11) NOT NULL,
  `citizen_id` int(11) DEFAULT NULL,
  `citizen_name` varchar(150) NOT NULL DEFAULT 'Caloocan Resident',
  `barangay` varchar(100) DEFAULT NULL,
  `stance` enum('In Favor','Neutral','Against','Suggested Amendments') NOT NULL DEFAULT 'In Favor',
  `commentary` text NOT NULL,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_feedback_consultation` (`consultation_id`),
  KEY `idx_feedback_stance` (`stance`),
  CONSTRAINT `consultation_feedbacks_ibfk_1` FOREIGN KEY (`consultation_id`) REFERENCES `civic_consultations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consultation_feedbacks`
--

LOCK TABLES `consultation_feedbacks` WRITE;
/*!40000 ALTER TABLE `consultation_feedbacks` DISABLE KEYS */;
/*!40000 ALTER TABLE `consultation_feedbacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consultation_outcomes`
--

DROP TABLE IF EXISTS `consultation_outcomes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consultation_outcomes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consultation_id` int(11) NOT NULL,
  `key_findings` text NOT NULL,
  `policy_outcome` text NOT NULL,
  `ordinance_number` varchar(100) DEFAULT NULL,
  `allocated_budget` varchar(100) DEFAULT NULL,
  `transparency_score` varchar(50) NOT NULL DEFAULT '100% Published & Verified',
  `pdf_filename` varchar(255) DEFAULT NULL,
  `published_by` varchar(150) NOT NULL DEFAULT 'City Council Secretariat',
  `published_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `consultation_id` (`consultation_id`),
  CONSTRAINT `consultation_outcomes_ibfk_1` FOREIGN KEY (`consultation_id`) REFERENCES `civic_consultations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consultation_outcomes`
--

LOCK TABLES `consultation_outcomes` WRITE;
/*!40000 ALTER TABLE `consultation_outcomes` DISABLE KEYS */;
/*!40000 ALTER TABLE `consultation_outcomes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `departments` (
  `department_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `department_code` varchar(20) NOT NULL,
  `department_name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `icon` varchar(50) DEFAULT 'fa-solid fa-building',
  `default_priority` enum('Urgent','High','Medium','Low') DEFAULT 'Medium',
  `default_sla` varchar(50) DEFAULT '48 Hours',
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `department_code` (`department_code`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'IT','Information Technology Department','Network infrastructure, portal security, citizen mobile systems, and LGU systems integration.','fa-solid fa-laptop-code','Medium','24 Hours','Active','2026-09-30 13:25:37','2026-09-30 13:25:37'),(4,'ESMS','Education & Scholarship','Municipal scholarship programs, student grants, educational assistance, and academic awards.','fa-solid fa-graduation-cap','Low','72 Hours','Active','2026-09-30 13:25:37','2026-09-30 13:25:37'),(5,'CIE','Citizenship Information  & Engagement','Citizen registry, grievance intake, community feedback, public polls, and civic engagement.','fa-solid fa-comments','Low','72 Hours','Active','2026-09-30 13:25:37','2026-09-30 13:25:37'),(6,'PLM','Permits & Licensing Management','Business licenses, local commercial clearances, special permits, and regulatory compliance.','fa-solid fa-file-contract','Medium','72 Hours','Active','2026-09-30 13:25:37','2026-09-30 13:25:37'),(7,'SSM','Social Services Management','Social welfare, indigent burial aid, senior citizens assistance, and solo parent welfare support.','fa-solid fa-hands-holding-child','Medium','48 Hours','Active','2026-09-30 13:25:37','2026-09-30 13:25:37'),(8,'HSM','Health & Sanitation Management','City health centers, waste collection, public sanitization, vector control, and environmental inspection.','fa-solid fa-recycle','Medium','48 Hours','Active','2026-09-30 13:25:37','2026-09-30 13:25:37'),(9,'DRRM','Disaster Risk Reduction & Emergency Response','Flood warning, emergency rescue, disaster preparedness, drainage clearance, and evacuation hubs.','fa-solid fa-water','Urgent','4 Hours','Active','2026-09-30 13:25:37','2026-09-30 13:25:37'),(10,'UPZH','Urban Planning Zoning & Housing','Zoning permits, land use assessment, urban housing plans, and residential building compliance.','fa-solid fa-city','Medium','72 Hours','Active','2026-09-30 13:25:37','2026-09-30 13:25:37'),(11,'RCTS','Revenue Collection & Treasury Services','Real property tax, assessment payments, municipal fee collections, and treasury disbursements.','fa-solid fa-coins','Low','72 Hours','Active','2026-09-30 13:25:37','2026-09-30 13:25:37'),(12,'TMM','Transport & Mobility Management','Tricycle franchising, traffic control, route regulation, terminal permits, and road safety enforcement.','fa-solid fa-traffic-light','Medium','48 Hours','Active','2026-09-30 13:25:37','2026-09-30 13:25:37'),(13,'PAFM','Public Assets & Facilities Management','City engineering, road repairs, pothole resurfacing, streetlights, bridges, and public grounds.','fa-solid fa-road','High','24 Hours','Active','2026-09-30 13:25:37','2026-09-30 13:25:37');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `duplicate_flags`
--

DROP TABLE IF EXISTS `duplicate_flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `duplicate_flags` (
  `flag_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `flag_code` varchar(30) NOT NULL,
  `verification_id_a` int(10) unsigned NOT NULL,
  `verification_id_b` int(10) unsigned NOT NULL,
  `matching_criteria` varchar(150) NOT NULL,
  `match_confidence` tinyint(3) unsigned NOT NULL DEFAULT 95,
  `status` enum('Pending','Merged','Dismissed') NOT NULL DEFAULT 'Pending',
  `resolution_notes` text DEFAULT NULL,
  `master_record_id` int(10) unsigned DEFAULT NULL,
  `resolved_by` varchar(150) DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `detected_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`flag_id`),
  UNIQUE KEY `flag_code` (`flag_code`),
  KEY `idx_df_status` (`status`),
  KEY `idx_df_vid_a` (`verification_id_a`),
  KEY `idx_df_vid_b` (`verification_id_b`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Stores auto-detected duplicate citizen record pairs and their resolution';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `duplicate_flags`
--

LOCK TABLES `duplicate_flags` WRITE;
/*!40000 ALTER TABLE `duplicate_flags` DISABLE KEYS */;
/*!40000 ALTER TABLE `duplicate_flags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `id_cards_issued`
--

DROP TABLE IF EXISTS `id_cards_issued`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `id_cards_issued` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `card_control_no` varchar(60) NOT NULL COMMENT 'Unique embossed ID serial number',
  `application_id` int(10) unsigned NOT NULL COMMENT 'FK to id_issuance_applications',
  `reference_no` varchar(50) NOT NULL,
  `citizen_name` varchar(150) NOT NULL,
  `id_category` varchar(50) NOT NULL,
  `barangay` varchar(100) NOT NULL,
  `date_issued` datetime NOT NULL DEFAULT current_timestamp(),
  `date_expiry` date DEFAULT NULL,
  `qr_security_hash` varchar(128) NOT NULL COMMENT 'Cryptographic hash for City Hall scanner verification',
  `issued_by` varchar(100) NOT NULL DEFAULT 'ID Production Desk Officer',
  `status` enum('Active','Expired','Revoked','Lost') NOT NULL DEFAULT 'Active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `card_control_no` (`card_control_no`),
  KEY `idx_control_no` (`card_control_no`),
  KEY `idx_card_status` (`status`),
  KEY `fk_issued_application` (`application_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `id_cards_issued`
--

LOCK TABLES `id_cards_issued` WRITE;
/*!40000 ALTER TABLE `id_cards_issued` DISABLE KEYS */;
/*!40000 ALTER TABLE `id_cards_issued` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `id_issuance_applications`
--

DROP TABLE IF EXISTS `id_issuance_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `id_issuance_applications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `reference_no` varchar(50) NOT NULL COMMENT 'Application ref code (e.g. CAL-CIT-2026-4412)',
  `citizen_user_id` int(10) unsigned DEFAULT NULL COMMENT 'FK referencing citizen_users if authenticated',
  `id_category` enum('citizen_id','barangay_id','solo_parent_id','pwd_id','senior_citizen_id') NOT NULL DEFAULT 'citizen_id',
  `id_title` varchar(150) NOT NULL DEFAULT 'Caloocan Citizen Unified ID Card',
  `application_type` enum('New Application','Renewal','Replacement') NOT NULL DEFAULT 'New Application',
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT '',
  `last_name` varchar(100) NOT NULL,
  `suffix` varchar(20) DEFAULT '',
  `gender` varchar(20) NOT NULL DEFAULT 'Male',
  `birthdate` date DEFAULT NULL,
  `civil_status` varchar(50) NOT NULL DEFAULT 'Single',
  `contact_number` varchar(50) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `street_address` varchar(255) NOT NULL,
  `barangay` varchar(100) NOT NULL,
  `district` varchar(50) NOT NULL DEFAULT 'District 1',
  `resident_since` varchar(50) NOT NULL DEFAULT '2015',
  `issuing_bureau` varchar(200) NOT NULL DEFAULT 'Caloocan Civil Registry & Identity Management Bureau',
  `claim_office` varchar(200) NOT NULL DEFAULT 'Caloocan Main City Hall - Window 6',
  `estimated_turnaround` varchar(100) NOT NULL DEFAULT '3 to 5 Business Days',
  `primary_doc_name` varchar(150) DEFAULT 'Valid Identification Document',
  `primary_doc_url` mediumtext DEFAULT NULL,
  `photo_2x2_url` mediumtext DEFAULT NULL,
  `support_doc_name` varchar(150) DEFAULT NULL,
  `support_doc_url` mediumtext DEFAULT NULL,
  `status` enum('Pending Review','Under Review','Approved','Ready for Release','Claimed','Rejected') NOT NULL DEFAULT 'Pending Review',
  `review_notes` text DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `reviewed_by` varchar(100) DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `released_by` varchar(100) DEFAULT NULL,
  `released_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `reference_no` (`reference_no`),
  KEY `idx_id_category` (`id_category`),
  KEY `idx_app_status` (`status`),
  KEY `idx_barangay` (`barangay`),
  KEY `idx_ref_no` (`reference_no`),
  KEY `idx_user_id` (`citizen_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `id_issuance_applications`
--

LOCK TABLES `id_issuance_applications` WRITE;
/*!40000 ALTER TABLE `id_issuance_applications` DISABLE KEYS */;
INSERT INTO `id_issuance_applications` VALUES (1,'TEST-CIT-2026-9999',1,'citizen_id','Caloocan Unified Citizen ID','New Application','Juan','Pedro','Dela Cruz','','Male','1995-05-15','Single','09171234567','juan@example.com','123 Rizal Avenue','Barangay 171','District 1','5 - 10 Years','Caloocan Civil Registry & Citizen Bureau','Caloocan City Hall Main','3 to 5 Business Days','Philippine Passport.pdf',NULL,NULL,NULL,NULL,'Pending Review',NULL,NULL,NULL,NULL,NULL,NULL,'2026-09-30 13:41:11','2026-09-30 13:41:11'),(2,'CAL-BRGY-2026-1879',35,'barangay_id','Barangay Resident Identification Card','New Application','Danny','','Espelita','Jr.','Male','2003-12-07','Single','09630902025','espelitadanny@gmail.com','121','171','District 2','3 - 5 years','Respective Barangay Executive Office & Secretariat','Local Barangay Hall - Administrative Records Desk','1 to 2 Business Days','1.jfif',NULL,NULL,NULL,NULL,'Pending Review',NULL,NULL,NULL,NULL,NULL,NULL,'2026-09-30 15:01:25','2026-09-30 15:01:25');
/*!40000 ALTER TABLE `id_issuance_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `id_issuance_audit_logs`
--

DROP TABLE IF EXISTS `id_issuance_audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `id_issuance_audit_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `application_id` int(10) unsigned NOT NULL,
  `action` varchar(50) NOT NULL COMMENT 'e.g. SUBMITTED, REVIEW_STARTED, APPROVED, REJECTED, CLAIMED',
  `previous_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) NOT NULL,
  `officer_name` varchar(100) NOT NULL,
  `remarks` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_audit_app_id` (`application_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `id_issuance_audit_logs`
--

LOCK TABLES `id_issuance_audit_logs` WRITE;
/*!40000 ALTER TABLE `id_issuance_audit_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `id_issuance_audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issued_certificates`
--

DROP TABLE IF EXISTS `issued_certificates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issued_certificates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `certificate_control_no` varchar(50) NOT NULL,
  `request_id` int(10) unsigned NOT NULL,
  `reference_no` varchar(50) NOT NULL,
  `citizen_id` varchar(50) DEFAULT NULL,
  `citizen_name` varchar(150) NOT NULL,
  `certificate_type` varchar(100) NOT NULL,
  `purpose` varchar(255) DEFAULT NULL,
  `or_number` varchar(50) DEFAULT NULL,
  `fee_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `released_by` varchar(100) NOT NULL DEFAULT 'Admin Staff',
  `date_released` datetime NOT NULL DEFAULT current_timestamp(),
  `reprint_count` int(11) NOT NULL DEFAULT 0,
  `security_seal_hash` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `certificate_control_no` (`certificate_control_no`),
  KEY `idx_control_no` (`certificate_control_no`),
  KEY `idx_ref_no` (`reference_no`),
  KEY `idx_released` (`date_released`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issued_certificates`
--

LOCK TABLES `issued_certificates` WRITE;
/*!40000 ALTER TABLE `issued_certificates` DISABLE KEYS */;
/*!40000 ALTER TABLE `issued_certificates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `public_surveys`
--

DROP TABLE IF EXISTS `public_surveys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `public_surveys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_code` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `short_description` text NOT NULL,
  `category` varchar(100) NOT NULL,
  `estimated_time` varchar(50) NOT NULL DEFAULT '3 mins',
  `target_audience` varchar(100) NOT NULL DEFAULT 'All Residents',
  `sub_target` varchar(150) DEFAULT NULL,
  `open_date` date NOT NULL,
  `close_date` date NOT NULL,
  `privacy_setting` enum('Identified','Anonymous') NOT NULL DEFAULT 'Identified',
  `is_public_results` tinyint(1) NOT NULL DEFAULT 1,
  `status` enum('Draft','Open','Closing Soon','Completed','Closed') NOT NULL DEFAULT 'Open',
  `created_by` varchar(150) NOT NULL DEFAULT 'City Administration',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `survey_code` (`survey_code`),
  KEY `idx_survey_status` (`status`),
  KEY `idx_survey_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `public_surveys`
--

LOCK TABLES `public_surveys` WRITE;
/*!40000 ALTER TABLE `public_surveys` DISABLE KEYS */;
INSERT INTO `public_surveys` VALUES (1,'SRV-2026-001','Caloocan E-Government Portal & Digital Services Usability Survey','Help the municipal administration evaluate the speed, accessibility, and ease of use of our unified online citizen services.','Digital Governance','3 mins','All Residents',NULL,'2026-09-01','2026-10-31','Identified',1,'Open','City Administration','2026-09-30 22:08:08','2026-09-30 22:08:08'),(2,'SRV-2026-002','Community Disaster Preparedness & Flood Early Warning Feedback','Share your experience with recent weather broadcasts, evacuation center readiness, and localized drainage concerns in your barangay.','Disaster Preparedness','4 mins','All Residents',NULL,'2026-09-15','2026-10-25','Identified',1,'Open','City Administration','2026-09-30 22:08:08','2026-09-30 22:08:08');
/*!40000 ALTER TABLE `public_surveys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `survey_questions`
--

DROP TABLE IF EXISTS `survey_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL,
  `question_order` int(11) NOT NULL DEFAULT 1,
  `title` text NOT NULL,
  `question_type` enum('multiple_choice','multiple_selection','yes_no','rating_scale','likert_scale','short_answer','long_answer') NOT NULL DEFAULT 'multiple_choice',
  `options_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`options_json`)),
  `is_required` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_question_survey` (`survey_id`,`question_order`),
  CONSTRAINT `survey_questions_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `public_surveys` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `survey_questions`
--

LOCK TABLES `survey_questions` WRITE;
/*!40000 ALTER TABLE `survey_questions` DISABLE KEYS */;
INSERT INTO `survey_questions` VALUES (1,1,1,'How satisfied are you with the overall speed and responsiveness of our online services?','rating_scale',NULL,1,'2026-09-30 22:08:08'),(2,1,2,'Which municipal service do you access most frequently?','multiple_choice','[\"Barangay Certificates & Clearances\", \"Citizen & Senior IDs\", \"Emergency Alerts & Advisories\", \"Grievance & Concern Reporting\"]',1,'2026-09-30 22:08:08'),(3,1,3,'Online document verification and QR vouchers are faster than physical walk-in queues.','likert_scale','[\"Strongly Disagree\", \"Disagree\", \"Neutral / Undecided\", \"Agree\", \"Strongly Agree\"]',1,'2026-09-30 22:08:08'),(4,1,4,'What new government services or features would you like to see integrated next?','long_answer',NULL,0,'2026-09-30 22:08:08'),(5,2,1,'Did you receive the recent Orange Rainfall Emergency Broadcast on your mobile device?','yes_no','[\"Yes\", \"No\"]',1,'2026-09-30 22:08:08'),(6,2,2,'Which notification channels are most reliable for your household during severe weather?','multiple_selection','[\"In-App Push Notification\", \"SMS Text Alert\", \"Barangay Public Address / Siren\", \"Official City Facebook / Social Media\"]',1,'2026-09-30 22:08:08'),(7,2,3,'Rate the readiness, hygiene, and adequacy of evacuation centers in your barangay.','rating_scale',NULL,1,'2026-09-30 22:08:08');
/*!40000 ALTER TABLE `survey_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `survey_responses`
--

DROP TABLE IF EXISTS `survey_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_responses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL,
  `citizen_id` int(11) DEFAULT NULL,
  `citizen_name` varchar(150) NOT NULL DEFAULT 'Anonymous Citizen',
  `barangay` varchar(100) DEFAULT NULL,
  `age_group` varchar(50) DEFAULT NULL,
  `gender` varchar(30) DEFAULT NULL,
  `answers_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`answers_json`)),
  `overall_rating` decimal(3,2) DEFAULT NULL,
  `commentary` text DEFAULT NULL,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_response_survey` (`survey_id`),
  KEY `idx_response_date` (`submitted_at`),
  CONSTRAINT `survey_responses_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `public_surveys` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `survey_responses`
--

LOCK TABLES `survey_responses` WRITE;
/*!40000 ALTER TABLE `survey_responses` DISABLE KEYS */;
/*!40000 ALTER TABLE `survey_responses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'citizen_verification'
--

--
-- Current Database: `civentral_certificates`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `civentral_certificates` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `civentral_certificates`;

--
-- Table structure for table `broadcast_alerts`
--

DROP TABLE IF EXISTS `broadcast_alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `broadcast_alerts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `alert_id` varchar(50) NOT NULL COMMENT 'Unique alert code, e.g. CCN-ALT-2026-0001',
  `title` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `category` varchar(100) NOT NULL DEFAULT 'Broadcast' COMMENT 'Emergency Alert, Domain Update, Broadcast, General Announcement, Health Advisory, Curfew / Ordinance, Event',
  `priority` enum('Normal','High','Urgent') NOT NULL DEFAULT 'Normal',
  `channels` varchar(150) NOT NULL DEFAULT 'In-App, Push',
  `target_audience` varchar(150) NOT NULL DEFAULT 'All Registered Citizens',
  `target_barangay` varchar(150) NOT NULL DEFAULT 'All Barangays',
  `sender_name` varchar(150) NOT NULL DEFAULT 'City Central Command & Public Info Bureau',
  `sender_role` varchar(150) NOT NULL DEFAULT 'Public Information Officer',
  `status` enum('Delivered','Sent','Scheduled','Draft') NOT NULL DEFAULT 'Delivered',
  `recipients_count` int(10) unsigned NOT NULL DEFAULT 0,
  `delivered_count` int(10) unsigned NOT NULL DEFAULT 0,
  `failed_count` int(10) unsigned NOT NULL DEFAULT 0,
  `pending_count` int(10) unsigned NOT NULL DEFAULT 0,
  `attachment_url` varchar(500) DEFAULT NULL,
  `scheduled_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `alert_id` (`alert_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_category` (`category`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `broadcast_alerts`
--

LOCK TABLES `broadcast_alerts` WRITE;
/*!40000 ALTER TABLE `broadcast_alerts` DISABLE KEYS */;
INSERT INTO `broadcast_alerts` VALUES (1,'CCN-ALT-2026-4386','Typhoon Advisory #3 - Heavy Rainfall Alert','PAGASA has issued Orange Rainfall Warning for Caloocan City. Emergency evacuation centers at Barangay 176 are prepared and open.','Emergency','Urgent','In-App / Push, SMS','All Residents','All Barangays','Caloocan Public Information Office','Public Information Officer','Delivered',1420,1399,21,0,NULL,NULL,'2026-09-30 00:54:32','2026-09-30 00:54:32'),(2,'CCN-ALT-2026-1315','Health Advisory: Dengue Prevention & Fogging Schedule','Barangay Health Services will conduct synchronized anti-dengue misting and free larval inspections this Saturday starting 7:00 AM.','Health Advisory','High','In-App / Push, SMS, Email','All Residents','All Barangays','Caloocan Public Information Office','Public Information Officer','Delivered',1420,1399,21,0,NULL,NULL,'2026-09-30 01:00:44','2026-09-30 01:00:44'),(3,'CCN-ALT-2026-1082','baha','magingat sa baha','Emergency','Urgent','In-App / Push','All Residents','All Barangays','Caloocan Public Information Office','Public Information Officer','Delivered',1420,1399,21,0,'assets/uploads/alerts/alert_1790701497_a4a86022.jfif',NULL,'2026-09-30 01:04:57','2026-09-30 01:04:57'),(4,'CCN-ALT-2026-2224','Barilan','<b>Mag ingat sa barilan sa camarin</b>','Emergency','Urgent','In-App / Push','All Residents','All Barangays','Caloocan Public Information Office','Public Information Officer','Delivered',1,1,0,0,NULL,NULL,'2026-09-30 13:19:14','2026-09-30 13:19:14');
/*!40000 ALTER TABLE `broadcast_alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `certificate_payments`
--

DROP TABLE IF EXISTS `certificate_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `certificate_payments` (
  `payment_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `or_number` varchar(50) NOT NULL,
  `reference_no` varchar(50) NOT NULL,
  `citizen_name` varchar(150) NOT NULL,
  `certificate_type` varchar(100) NOT NULL,
  `amount_due` decimal(10,2) NOT NULL DEFAULT 0.00,
  `amount_paid` decimal(10,2) NOT NULL DEFAULT 0.00,
  `payment_status` enum('Pending','Paid','Waived') NOT NULL DEFAULT 'Paid',
  `cashier_name` varchar(100) NOT NULL DEFAULT 'Barangay Treasury Desk',
  `payment_date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`payment_id`),
  KEY `idx_or` (`or_number`),
  KEY `idx_payment_date` (`payment_date`),
  KEY `idx_pstatus` (`payment_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certificate_payments`
--

LOCK TABLES `certificate_payments` WRITE;
/*!40000 ALTER TABLE `certificate_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `certificate_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `certificate_requests`
--

DROP TABLE IF EXISTS `certificate_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `certificate_requests` (
  `request_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `reference_no` varchar(50) NOT NULL,
  `citizen_user_id` int(10) unsigned DEFAULT NULL,
  `citizen_name` varchar(150) NOT NULL,
  `contact_number` varchar(50) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `street_address` varchar(255) NOT NULL,
  `barangay` varchar(100) NOT NULL,
  `district` varchar(50) DEFAULT 'District 1',
  `civil_status` varchar(50) DEFAULT 'Single',
  `resident_since` varchar(50) DEFAULT '2015',
  `certificate_type` varchar(100) NOT NULL,
  `purpose` varchar(255) NOT NULL,
  `purpose_details` text DEFAULT NULL,
  `additional_notes` text DEFAULT NULL,
  `fee_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `payment_status` enum('Pending','Paid','Waived') NOT NULL DEFAULT 'Pending',
  `or_number` varchar(50) DEFAULT NULL,
  `uploaded_documents` text DEFAULT NULL,
  `status` enum('Pending','Under Review','Approved','Ready for Release','Released','Rejected') NOT NULL DEFAULT 'Pending',
  `encoded_by` varchar(100) NOT NULL DEFAULT 'Citizen Mobile App',
  `verification_notes` text DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `approved_by` varchar(100) DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `released_by` varchar(100) DEFAULT NULL,
  `released_at` datetime DEFAULT NULL,
  `reprint_count` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`request_id`),
  UNIQUE KEY `reference_no` (`reference_no`),
  KEY `idx_status` (`status`),
  KEY `idx_cert_type` (`certificate_type`),
  KEY `idx_barangay` (`barangay`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certificate_requests`
--

LOCK TABLES `certificate_requests` WRITE;
/*!40000 ALTER TABLE `certificate_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `certificate_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citizen_concerns`
--

DROP TABLE IF EXISTS `citizen_concerns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citizen_concerns` (
  `concern_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_number` varchar(50) NOT NULL,
  `citizen_user_id` int(10) unsigned DEFAULT NULL,
  `citizen_name` varchar(150) NOT NULL DEFAULT 'Anonymous Resident',
  `citizen_phone` varchar(50) DEFAULT NULL,
  `citizen_email` varchar(150) DEFAULT NULL,
  `is_anonymous` tinyint(1) NOT NULL DEFAULT 0,
  `category` varchar(100) NOT NULL,
  `sub_category` varchar(100) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `location` varchar(255) NOT NULL DEFAULT '',
  `barangay` varchar(100) NOT NULL DEFAULT '',
  `district` varchar(50) DEFAULT 'District 1',
  `gps_coordinates` varchar(100) DEFAULT NULL,
  `status` enum('New','Under Review','Routed','In Progress','Resolved','Closed') NOT NULL DEFAULT 'New',
  `priority` enum('Urgent','High','Medium','Low') NOT NULL DEFAULT 'Medium',
  `assigned_department` varchar(150) DEFAULT NULL,
  `ai_detected_category` varchar(100) DEFAULT NULL,
  `ai_confidence_score` varchar(100) DEFAULT NULL,
  `ai_reason` text DEFAULT NULL,
  `photo_evidence_url` mediumtext DEFAULT NULL,
  `attachments` text DEFAULT NULL,
  `resolution_notes` text DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`concern_id`),
  UNIQUE KEY `ticket_number` (`ticket_number`),
  KEY `idx_status` (`status`),
  KEY `idx_category` (`category`),
  KEY `idx_priority` (`priority`),
  KEY `idx_barangay` (`barangay`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citizen_concerns`
--

LOCK TABLES `citizen_concerns` WRITE;
/*!40000 ALTER TABLE `citizen_concerns` DISABLE KEYS */;
INSERT INTO `citizen_concerns` VALUES (1,'CAL-REP-2026-1607',NULL,'Anonymous Resident',NULL,NULL,0,'Government Service',NULL,'staff was rude','staff was rude during counter inquiry','','Barangay 123','District 1',NULL,'New','Low',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-09-30 12:41:57','2026-09-30 22:05:34'),(2,'CAL-REP-2026-2397',NULL,'Danny Toledano Espelita Jr.',NULL,NULL,0,'Public Safety',NULL,'GUn fight','merong nag babarilan dito sa kanto ng camarin','','Barangay 178','District 1',NULL,'Closed','Urgent',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-09-30 12:47:48','2026-09-30 22:05:34'),(13,'CAL-REP-2026-9045',NULL,'Anonymous Resident',NULL,NULL,0,'Road & Infrastructure',NULL,'sinkhole','may sinkhole dito sa kalsada peligroso sa mga motorista','','Barangay 121','District 1',NULL,'Closed','Urgent',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-09-30 13:51:12','2026-09-30 22:05:34');
/*!40000 ALTER TABLE `citizen_concerns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citizen_users`
--

DROP TABLE IF EXISTS `citizen_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citizen_users` (
  `citizen_user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `has_no_middle_name` tinyint(1) NOT NULL DEFAULT 0,
  `last_name` varchar(100) NOT NULL,
  `suffix` varchar(20) DEFAULT NULL,
  `email` varchar(191) NOT NULL,
  `mobile_number` varchar(30) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `status` enum('Pending','Active','Inactive','Locked','Archived') NOT NULL DEFAULT 'Active',
  `registry_completed` tinyint(1) NOT NULL DEFAULT 0,
  `failed_attempts` int(11) NOT NULL DEFAULT 0,
  `last_login` datetime DEFAULT NULL,
  `biometric_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`citizen_user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=1003 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citizen_users`
--

LOCK TABLES `citizen_users` WRITE;
/*!40000 ALTER TABLE `citizen_users` DISABLE KEYS */;
INSERT INTO `citizen_users` VALUES (35,'Vice','G',0,'Ganda',NULL,'espelitadanny@gmail.com','09630902025',NULL,'Active',1,0,NULL,0,'2026-09-30 14:27:34','2026-09-30 22:06:32',NULL),(1001,'Danny','Toledano',0,'Espelita','Jr.','danny.espelita@civentral.ph','09171234567',NULL,'Active',1,0,NULL,1,'2026-09-30 13:26:00','2026-09-30 22:06:32',NULL),(1002,'Jean',NULL,0,'Gray',NULL,'eanray_1002@citizen.local','09000001002',NULL,'Active',0,0,NULL,0,'2026-09-30 14:00:30','2026-09-30 22:06:32',NULL);
/*!40000 ALTER TABLE `citizen_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citizen_verifications`
--

DROP TABLE IF EXISTS `citizen_verifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citizen_verifications` (
  `verification_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `citizen_user_id` int(10) unsigned NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) NOT NULL,
  `suffix` varchar(20) DEFAULT NULL,
  `sex` enum('Male','Female') NOT NULL,
  `place_of_birth` varchar(255) NOT NULL,
  `birth_date` date NOT NULL,
  `civil_status` enum('Single','Married','Widowed','Separated','Divorced / Annulled','Common-Law / Live-In') NOT NULL,
  `employment_status` varchar(100) NOT NULL,
  `occupation` varchar(150) NOT NULL,
  `educational_attainment` varchar(100) NOT NULL,
  `district` varchar(50) NOT NULL,
  `barangay` varchar(100) NOT NULL,
  `street_address` varchar(255) NOT NULL,
  `years_resident` int(10) unsigned NOT NULL,
  `valid_id_type` varchar(100) NOT NULL,
  `valid_id_number` varchar(100) NOT NULL,
  `id_front_photo_url` mediumtext DEFAULT NULL,
  `selfie_photo_url` mediumtext DEFAULT NULL,
  `verification_status` enum('Pending','Under_Review','Approved','Rejected') NOT NULL DEFAULT 'Pending',
  `rejection_reason` text DEFAULT NULL,
  `reviewed_by_employee_id` int(10) unsigned DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `reviewed_by` varchar(100) DEFAULT NULL,
  `is_duplicate` tinyint(1) NOT NULL DEFAULT 0,
  `duplicate_notes` text DEFAULT NULL,
  PRIMARY KEY (`verification_id`),
  KEY `idx_verif_user_id` (`citizen_user_id`),
  KEY `idx_verif_status` (`verification_status`),
  KEY `idx_verif_barangay` (`barangay`),
  KEY `idx_verif_submitted_at` (`submitted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citizen_verifications`
--

LOCK TABLES `citizen_verifications` WRITE;
/*!40000 ALTER TABLE `citizen_verifications` DISABLE KEYS */;
INSERT INTO `citizen_verifications` VALUES (1,1001,'Danny','Toledano','Espelita','Jr.','Male','Caloocan City','1998-05-15','Single','Employed (Private Sector)','Software Engineer','College Graduate','District 1','Barangay 171 (Bagumbong)','123 Sampaguita St.',15,'Philippine Identification System (PhilSys) National ID','1234-5678-9012-3456',NULL,NULL,'Pending',NULL,NULL,NULL,'2026-09-30 13:26:00','2026-09-30 22:06:32',NULL,0,NULL),(9,1002,'Jean',NULL,'Gray',NULL,'Female','Caloocan City','1995-10-20','Single','Employed (Private Sector)','Designer','College Graduate','District 3','Barangay 178','45 Camarin Rd.',8,'PhilSys National ID','9876-5432-1098-7654',NULL,NULL,'Pending',NULL,NULL,NULL,'2026-09-30 14:00:30','2026-09-30 22:06:32',NULL,0,NULL),(11,35,'Vice','G','Ganda',NULL,'Male','Manila','1976-03-31','Single','Self-Employed / Freelancer','Host & Artist','College Graduate','District 2','Barangay 77','100 Rizal Ave.',20,'PhilSys National ID','4444-5555-6666-7777',NULL,NULL,'Approved',NULL,NULL,NULL,'2026-09-30 14:28:00','2026-09-30 22:06:32',NULL,0,NULL);
/*!40000 ALTER TABLE `citizen_verifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `civic_consultations`
--

DROP TABLE IF EXISTS `civic_consultations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `civic_consultations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consultation_code` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `category` varchar(100) NOT NULL,
  `background_info` text NOT NULL,
  `objective` text NOT NULL,
  `closing_date` date NOT NULL,
  `status` enum('Open','Closing Soon','Under Review','Closed / Outcome Published') NOT NULL DEFAULT 'Open',
  `created_by` varchar(150) NOT NULL DEFAULT 'City Legal & Policy Board',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `consultation_code` (`consultation_code`),
  KEY `idx_consultation_status` (`status`),
  KEY `idx_consultation_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `civic_consultations`
--

LOCK TABLES `civic_consultations` WRITE;
/*!40000 ALTER TABLE `civic_consultations` DISABLE KEYS */;
INSERT INTO `civic_consultations` VALUES (1,'CNS-2026-101','Draft City Ordinance: Residential Quiet Hours & Anti-Noise Regulation','Public Safety & Ordinances','The City Council is deliberating proposed regulations on commercial videoke, street loudspeakers, and construction noise in high-density barangays.','Gather community consensus on establishing mandatory residential quiet hours from 10:00 PM to 6:00 AM on weekdays.','2026-10-20','Open','City Legal & Policy Board','2026-09-30 22:08:08','2026-09-30 22:08:08'),(2,'CNS-2026-102','Caloocan Green Corridors & Solar Streetlighting Expansion Program','Urban Planning & Environment','A city-wide environmental transition project targeting high-traffic pedestrian avenues across North and South Caloocan.','Identify priority streets for solar-powered lighting posts, pocket tree parks, and permeable sidewalk paving.','2026-11-15','Open','City Legal & Policy Board','2026-09-30 22:08:08','2026-09-30 22:08:08');
/*!40000 ALTER TABLE `civic_consultations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `community_ratings`
--

DROP TABLE IF EXISTS `community_ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `community_ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `feedback_ref` varchar(50) NOT NULL,
  `citizen_name` varchar(150) DEFAULT 'Anonymous Citizen',
  `citizen_email` varchar(150) DEFAULT NULL,
  `citizen_barangay` varchar(100) DEFAULT 'Barangay Central',
  `service_name` varchar(150) NOT NULL,
  `transaction_ref` varchar(100) DEFAULT NULL,
  `overall_rating` tinyint(4) NOT NULL DEFAULT 5,
  `quality_rating` tinyint(4) NOT NULL DEFAULT 5,
  `staff_rating` tinyint(4) NOT NULL DEFAULT 5,
  `comments` text DEFAULT NULL,
  `sentiment` enum('Positive','Neutral','Negative') DEFAULT 'Positive',
  `status` enum('Published','Reviewed','Pending','Flagged') DEFAULT 'Published',
  `attachment_url` varchar(255) DEFAULT NULL,
  `admin_notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `feedback_ref` (`feedback_ref`),
  KEY `idx_service` (`service_name`),
  KEY `idx_rating` (`overall_rating`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `community_ratings`
--

LOCK TABLES `community_ratings` WRITE;
/*!40000 ALTER TABLE `community_ratings` DISABLE KEYS */;
INSERT INTO `community_ratings` VALUES (1,'CFB-2026-1001','Danny Espelita','danny.espelita@civentral.ph','Barangay 176','Barangay Clearance & Residency Certificate','CAL-BC-2026-0881',5,5,5,'Smooth process at the barangay hall window. Released in less than 15 minutes after online QR scanning.','Positive','Published',NULL,NULL,'2026-09-28 09:30:00','2026-09-30 22:04:44'),(2,'CFB-2026-1002','Maria Santos','maria.santos@gmail.com','Barangay 171','Caloocan City Health Center Consultation','CAL-HC-2026-4412',4,4,5,'The doctor and nurses were very polite and accommodating. The waiting area was clean and well ventilated.','Positive','Published',NULL,NULL,'2026-09-28 14:15:00','2026-09-30 22:04:44'),(3,'CFB-2026-1003','Anonymous Citizen',NULL,'Barangay 178','Road Maintenance & Pothole Repair','CAL-REP-2026-9045',5,5,4,'Engineering department dispatched asphalt repair crew within 48 hours of filing report. Excellent turnaround.','Positive','Published',NULL,NULL,'2026-09-29 11:00:00','2026-09-30 22:04:44'),(4,'CFB-2026-1004','Juan Dela Cruz','juan.delacruz@civentral.ph','Barangay 176','Senior Citizen & OSCA ID Processing','CAL-CIT-2026-4412',5,5,5,'Assisted my grandmother with her senior ID renewal. Very patient staff at Window 6.','Positive','Published',NULL,NULL,'2026-09-30 10:20:00','2026-09-30 22:04:44');
/*!40000 ALTER TABLE `community_ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consultation_feedbacks`
--

DROP TABLE IF EXISTS `consultation_feedbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consultation_feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consultation_id` int(11) NOT NULL,
  `citizen_id` int(11) DEFAULT NULL,
  `citizen_name` varchar(150) NOT NULL DEFAULT 'Caloocan Resident',
  `barangay` varchar(100) DEFAULT NULL,
  `stance` enum('In Favor','Neutral','Against','Suggested Amendments') NOT NULL DEFAULT 'In Favor',
  `commentary` text NOT NULL,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_feedback_consultation` (`consultation_id`),
  KEY `idx_feedback_stance` (`stance`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consultation_feedbacks`
--

LOCK TABLES `consultation_feedbacks` WRITE;
/*!40000 ALTER TABLE `consultation_feedbacks` DISABLE KEYS */;
/*!40000 ALTER TABLE `consultation_feedbacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consultation_outcomes`
--

DROP TABLE IF EXISTS `consultation_outcomes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consultation_outcomes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consultation_id` int(11) NOT NULL,
  `key_findings` text NOT NULL,
  `policy_outcome` text NOT NULL,
  `ordinance_number` varchar(100) DEFAULT NULL,
  `allocated_budget` varchar(100) DEFAULT NULL,
  `transparency_score` varchar(50) NOT NULL DEFAULT '100% Published & Verified',
  `pdf_filename` varchar(255) DEFAULT NULL,
  `published_by` varchar(150) NOT NULL DEFAULT 'City Council Secretariat',
  `published_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `consultation_id` (`consultation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consultation_outcomes`
--

LOCK TABLES `consultation_outcomes` WRITE;
/*!40000 ALTER TABLE `consultation_outcomes` DISABLE KEYS */;
/*!40000 ALTER TABLE `consultation_outcomes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `id_cards_issued`
--

DROP TABLE IF EXISTS `id_cards_issued`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `id_cards_issued` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `card_control_no` varchar(60) NOT NULL COMMENT 'Unique embossed ID serial number',
  `application_id` int(10) unsigned NOT NULL COMMENT 'FK to id_issuance_applications',
  `reference_no` varchar(50) NOT NULL,
  `citizen_name` varchar(150) NOT NULL,
  `id_category` varchar(50) NOT NULL,
  `barangay` varchar(100) NOT NULL,
  `date_issued` datetime NOT NULL DEFAULT current_timestamp(),
  `date_expiry` date DEFAULT NULL,
  `qr_security_hash` varchar(128) NOT NULL COMMENT 'Cryptographic hash for City Hall scanner verification',
  `issued_by` varchar(100) NOT NULL DEFAULT 'ID Production Desk Officer',
  `status` enum('Active','Expired','Revoked','Lost') NOT NULL DEFAULT 'Active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `card_control_no` (`card_control_no`),
  KEY `idx_control_no` (`card_control_no`),
  KEY `idx_card_status` (`status`),
  KEY `fk_issued_application` (`application_id`),
  CONSTRAINT `fk_issued_application` FOREIGN KEY (`application_id`) REFERENCES `id_issuance_applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `id_cards_issued`
--

LOCK TABLES `id_cards_issued` WRITE;
/*!40000 ALTER TABLE `id_cards_issued` DISABLE KEYS */;
/*!40000 ALTER TABLE `id_cards_issued` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `id_issuance_applications`
--

DROP TABLE IF EXISTS `id_issuance_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `id_issuance_applications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `reference_no` varchar(50) NOT NULL COMMENT 'Application ref code (e.g. CAL-CIT-2026-4412)',
  `citizen_user_id` int(10) unsigned DEFAULT NULL COMMENT 'FK referencing citizen_users if authenticated',
  `id_category` enum('citizen_id','barangay_id','solo_parent_id','pwd_id','senior_citizen_id') NOT NULL DEFAULT 'citizen_id',
  `id_title` varchar(150) NOT NULL DEFAULT 'Caloocan Citizen Unified ID Card',
  `application_type` enum('New Application','Renewal','Replacement') NOT NULL DEFAULT 'New Application',
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT '',
  `last_name` varchar(100) NOT NULL,
  `suffix` varchar(20) DEFAULT '',
  `gender` varchar(20) NOT NULL DEFAULT 'Male',
  `birthdate` date DEFAULT NULL,
  `civil_status` varchar(50) NOT NULL DEFAULT 'Single',
  `contact_number` varchar(50) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `street_address` varchar(255) NOT NULL,
  `barangay` varchar(100) NOT NULL,
  `district` varchar(50) NOT NULL DEFAULT 'District 1',
  `resident_since` varchar(50) NOT NULL DEFAULT '2015',
  `issuing_bureau` varchar(200) NOT NULL DEFAULT 'Caloocan Civil Registry & Identity Management Bureau',
  `claim_office` varchar(200) NOT NULL DEFAULT 'Caloocan Main City Hall - Window 6',
  `estimated_turnaround` varchar(100) NOT NULL DEFAULT '3 to 5 Business Days',
  `primary_doc_name` varchar(150) DEFAULT 'Valid Identification Document',
  `primary_doc_url` mediumtext DEFAULT NULL,
  `photo_2x2_url` mediumtext DEFAULT NULL,
  `support_doc_name` varchar(150) DEFAULT NULL,
  `support_doc_url` mediumtext DEFAULT NULL,
  `status` enum('Pending Review','Under Review','Approved','Ready for Release','Claimed','Rejected') NOT NULL DEFAULT 'Pending Review',
  `review_notes` text DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `reviewed_by` varchar(100) DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `released_by` varchar(100) DEFAULT NULL,
  `released_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `reference_no` (`reference_no`),
  KEY `idx_id_category` (`id_category`),
  KEY `idx_app_status` (`status`),
  KEY `idx_barangay` (`barangay`),
  KEY `idx_ref_no` (`reference_no`),
  KEY `idx_user_id` (`citizen_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `id_issuance_applications`
--

LOCK TABLES `id_issuance_applications` WRITE;
/*!40000 ALTER TABLE `id_issuance_applications` DISABLE KEYS */;
INSERT INTO `id_issuance_applications` VALUES (1,'TEST-CIT-2026-9999',1,'citizen_id','Caloocan Unified Citizen ID','New Application','Juan','Pedro','Dela Cruz','','Male','1995-05-15','Single','09171234567','juan@example.com','123 Rizal Avenue','Barangay 171','District 1','5 - 10 Years','Caloocan Civil Registry & Citizen Bureau','Caloocan City Hall Main','3 to 5 Business Days','Philippine Passport.pdf',NULL,NULL,NULL,NULL,'Pending Review',NULL,NULL,NULL,NULL,NULL,NULL,'2026-09-30 13:41:11','2026-09-30 13:41:11'),(2,'CAL-BRGY-2026-1879',35,'barangay_id','Barangay Resident Identification Card','New Application','Danny','','Espelita','Jr.','Male','2003-12-07','Single','09630902025','espelitadanny@gmail.com','121','171','District 2','3 - 5 years','Respective Barangay Executive Office & Secretariat','Local Barangay Hall - Administrative Records Desk','1 to 2 Business Days','1.jfif',NULL,NULL,NULL,NULL,'Pending Review',NULL,NULL,NULL,NULL,NULL,NULL,'2026-09-30 15:01:25','2026-09-30 15:01:25');
/*!40000 ALTER TABLE `id_issuance_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `id_issuance_audit_logs`
--

DROP TABLE IF EXISTS `id_issuance_audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `id_issuance_audit_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `application_id` int(10) unsigned NOT NULL,
  `action` varchar(50) NOT NULL COMMENT 'e.g. SUBMITTED, REVIEW_STARTED, APPROVED, REJECTED, CLAIMED',
  `previous_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) NOT NULL,
  `officer_name` varchar(100) NOT NULL,
  `remarks` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_audit_app_id` (`application_id`),
  CONSTRAINT `fk_audit_application` FOREIGN KEY (`application_id`) REFERENCES `id_issuance_applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `id_issuance_audit_logs`
--

LOCK TABLES `id_issuance_audit_logs` WRITE;
/*!40000 ALTER TABLE `id_issuance_audit_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `id_issuance_audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issued_certificates`
--

DROP TABLE IF EXISTS `issued_certificates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issued_certificates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `certificate_control_no` varchar(50) NOT NULL,
  `request_id` int(10) unsigned NOT NULL,
  `reference_no` varchar(50) NOT NULL,
  `citizen_id` varchar(50) DEFAULT NULL,
  `citizen_name` varchar(150) NOT NULL,
  `certificate_type` varchar(100) NOT NULL,
  `purpose` varchar(255) DEFAULT NULL,
  `or_number` varchar(50) DEFAULT NULL,
  `fee_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `released_by` varchar(100) NOT NULL DEFAULT 'Admin Staff',
  `date_released` datetime NOT NULL DEFAULT current_timestamp(),
  `reprint_count` int(11) NOT NULL DEFAULT 0,
  `security_seal_hash` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `certificate_control_no` (`certificate_control_no`),
  KEY `idx_control_no` (`certificate_control_no`),
  KEY `idx_ref_no` (`reference_no`),
  KEY `idx_released` (`date_released`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issued_certificates`
--

LOCK TABLES `issued_certificates` WRITE;
/*!40000 ALTER TABLE `issued_certificates` DISABLE KEYS */;
/*!40000 ALTER TABLE `issued_certificates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `public_surveys`
--

DROP TABLE IF EXISTS `public_surveys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `public_surveys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_code` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `short_description` text NOT NULL,
  `category` varchar(100) NOT NULL,
  `estimated_time` varchar(50) NOT NULL DEFAULT '3 mins',
  `target_audience` varchar(100) NOT NULL DEFAULT 'All Residents',
  `sub_target` varchar(150) DEFAULT NULL,
  `open_date` date NOT NULL,
  `close_date` date NOT NULL,
  `privacy_setting` enum('Identified','Anonymous') NOT NULL DEFAULT 'Identified',
  `is_public_results` tinyint(1) NOT NULL DEFAULT 1,
  `status` enum('Draft','Open','Closing Soon','Completed','Closed') NOT NULL DEFAULT 'Open',
  `created_by` varchar(150) NOT NULL DEFAULT 'City Administration',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `survey_code` (`survey_code`),
  KEY `idx_survey_status` (`status`),
  KEY `idx_survey_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `public_surveys`
--

LOCK TABLES `public_surveys` WRITE;
/*!40000 ALTER TABLE `public_surveys` DISABLE KEYS */;
INSERT INTO `public_surveys` VALUES (1,'SRV-2026-001','Caloocan E-Government Portal & Digital Services Usability Survey','Help the municipal administration evaluate the speed, accessibility, and ease of use of our unified online citizen services.','Digital Governance','3 mins','All Residents',NULL,'2026-09-01','2026-10-31','Identified',1,'Open','City Administration','2026-09-30 22:08:08','2026-09-30 22:08:08'),(2,'SRV-2026-002','Community Disaster Preparedness & Flood Early Warning Feedback','Share your experience with recent weather broadcasts, evacuation center readiness, and localized drainage concerns in your barangay.','Disaster Preparedness','4 mins','All Residents',NULL,'2026-09-15','2026-10-25','Identified',1,'Open','City Administration','2026-09-30 22:08:08','2026-09-30 22:08:08');
/*!40000 ALTER TABLE `public_surveys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `survey_questions`
--

DROP TABLE IF EXISTS `survey_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL,
  `question_order` int(11) NOT NULL DEFAULT 1,
  `title` text NOT NULL,
  `question_type` enum('multiple_choice','multiple_selection','yes_no','rating_scale','likert_scale','short_answer','long_answer') NOT NULL DEFAULT 'multiple_choice',
  `options_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`options_json`)),
  `is_required` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_question_survey` (`survey_id`,`question_order`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `survey_questions`
--

LOCK TABLES `survey_questions` WRITE;
/*!40000 ALTER TABLE `survey_questions` DISABLE KEYS */;
INSERT INTO `survey_questions` VALUES (1,1,1,'How satisfied are you with the overall speed and responsiveness of our online services?','rating_scale',NULL,1,'2026-09-30 22:08:08'),(2,1,2,'Which municipal service do you access most frequently?','multiple_choice','[\"Barangay Certificates & Clearances\", \"Citizen & Senior IDs\", \"Emergency Alerts & Advisories\", \"Grievance & Concern Reporting\"]',1,'2026-09-30 22:08:08'),(3,1,3,'Online document verification and QR vouchers are faster than physical walk-in queues.','likert_scale','[\"Strongly Disagree\", \"Disagree\", \"Neutral / Undecided\", \"Agree\", \"Strongly Agree\"]',1,'2026-09-30 22:08:08'),(4,1,4,'What new government services or features would you like to see integrated next?','long_answer',NULL,0,'2026-09-30 22:08:08'),(5,2,1,'Did you receive the recent Orange Rainfall Emergency Broadcast on your mobile device?','yes_no','[\"Yes\", \"No\"]',1,'2026-09-30 22:08:08'),(6,2,2,'Which notification channels are most reliable for your household during severe weather?','multiple_selection','[\"In-App Push Notification\", \"SMS Text Alert\", \"Barangay Public Address / Siren\", \"Official City Facebook / Social Media\"]',1,'2026-09-30 22:08:08'),(7,2,3,'Rate the readiness, hygiene, and adequacy of evacuation centers in your barangay.','rating_scale',NULL,1,'2026-09-30 22:08:08');
/*!40000 ALTER TABLE `survey_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `survey_responses`
--

DROP TABLE IF EXISTS `survey_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_responses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL,
  `citizen_id` int(11) DEFAULT NULL,
  `citizen_name` varchar(150) NOT NULL DEFAULT 'Anonymous Citizen',
  `barangay` varchar(100) DEFAULT NULL,
  `age_group` varchar(50) DEFAULT NULL,
  `gender` varchar(30) DEFAULT NULL,
  `answers_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`answers_json`)),
  `overall_rating` decimal(3,2) DEFAULT NULL,
  `commentary` text DEFAULT NULL,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_response_survey` (`survey_id`),
  KEY `idx_response_date` (`submitted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `survey_responses`
--

LOCK TABLES `survey_responses` WRITE;
/*!40000 ALTER TABLE `survey_responses` DISABLE KEYS */;
/*!40000 ALTER TABLE `survey_responses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'civentral_certificates'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-30 22:08:30
