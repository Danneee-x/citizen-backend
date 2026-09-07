<?php
/**
 * Endpoint: POST /api/citizen/check-account.php
 * Checks if a citizen account exists by email or mobile number.
 */

require_once __DIR__ . '/../../config/cors.php';
require_once __DIR__ . '/../../config/database.php';

$raw = file_get_contents('php://input');
$data = json_decode($raw, true);

// Accept identifier from JSON or form-urlencoded POST
$identifier = trim($data['identifier'] ?? ($data['email'] ?? ($data['mobile_number'] ?? ($_POST['identifier'] ?? ($_POST['email'] ?? '')))));

if (empty($identifier)) {
    http_response_code(400);
    echo json_encode(["status" => "error", "message" => "Please enter an email address or phone number."]);
    exit;
}

$pdo = getDbConnection();

try {
    // Ensure citizen_users table exists
    $pdo->exec("CREATE TABLE IF NOT EXISTS `citizen_users` (
        `citizen_user_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        `first_name` VARCHAR(100) NOT NULL,
        `middle_name` VARCHAR(100) NULL,
        `has_no_middle_name` TINYINT(1) NOT NULL DEFAULT 0,
        `last_name` VARCHAR(100) NOT NULL,
        `suffix` VARCHAR(20) NULL,
        `email` VARCHAR(191) NOT NULL UNIQUE,
        `mobile_number` VARCHAR(30) NULL,
        `password` VARCHAR(255) NULL,
        `status` ENUM('Pending', 'Active', 'Inactive', 'Locked', 'Archived') NOT NULL DEFAULT 'Active',
        `registry_completed` TINYINT(1) NOT NULL DEFAULT 0,
        `failed_attempts` INT NOT NULL DEFAULT 0,
        `last_login` DATETIME NULL,
        `biometric_enabled` TINYINT(1) NOT NULL DEFAULT 0,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");

    $stmt = $pdo->prepare("SELECT citizen_user_id, first_name, last_name, email, mobile_number, status, registry_completed FROM citizen_users WHERE email = :id OR mobile_number = :id LIMIT 1");
    $stmt->execute([':id' => $identifier]);
    $user = $stmt->fetch();

    if ($user) {
        http_response_code(200);
        echo json_encode([
            "status"             => "exists",
            "exists"             => true,
            "message"            => "Account exists.",
            "citizen_user_id"    => (int)$user['citizen_user_id'],
            "user_status"        => $user['status'],
            "registry_completed" => (int)$user['registry_completed']
        ]);
    } else {
        http_response_code(200);
        echo json_encode([
            "status"  => "not_found",
            "exists"  => false,
            "message" => "Account does not exist."
        ]);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
