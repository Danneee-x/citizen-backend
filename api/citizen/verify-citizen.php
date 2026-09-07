<?php
/**
 * Endpoint: POST /api/citizen/verify-citizen.php
 * Handles multi-step Citizen Verification Form submission from the mobile app.
 */

require_once __DIR__ . '/../../config/cors.php';
require_once __DIR__ . '/../../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["status" => "error", "message" => "Method Not Allowed. Must use POST."]);
    exit;
}

$raw = file_get_contents('php://input');
$data = json_decode($raw, true);

if (!$data) {
    http_response_code(400);
    echo json_encode(["status" => "error", "message" => "Invalid JSON payload."]);
    exit;
}

// Extract & validate required fields
$firstName     = trim($data['first_name'] ?? '');
$lastName      = trim($data['last_name'] ?? '');
$middleName    = trim($data['middle_name'] ?? '') ?: null;
$suffix        = trim($data['suffix'] ?? '') ?: null;
$sex           = $data['sex'] ?? 'Male';
$placeOfBirth  = trim($data['place_of_birth'] ?? '');
$birthDate     = $data['birth_date'] ?? null;
$civilStatus   = $data['civil_status'] ?? 'Single';
$employment    = $data['employment_status'] ?? '';
$occupation    = $data['occupation'] ?? '';
$education     = $data['educational_attainment'] ?? '';
$district      = $data['district'] ?? '';
$barangay      = $data['barangay'] ?? '';
$streetAddress = trim($data['street_address'] ?? '');
$yearsResident = intval($data['years_resident'] ?? 1);
$validIdType   = $data['valid_id_type'] ?? '';
$validIdNumber = trim($data['valid_id_number'] ?? '');
$idFrontPhoto  = $data['id_front_photo_url'] ?? null;
$selfiePhoto   = $data['selfie_photo_url'] ?? null;
$citizenUserId = intval($data['citizen_user_id'] ?? 1001);

if (empty($firstName) || empty($lastName) || empty($birthDate) || empty($barangay) || empty($validIdNumber)) {
    http_response_code(422);
    echo json_encode([
        "status"  => "error",
        "message" => "Required fields missing: First Name, Last Name, Birth Date, Barangay, and Valid ID Number are required."
    ]);
    exit;
}

$pdo = getDbConnection();

try {
    // 1. Ensure citizen_verifications table exists
    $pdo->exec("CREATE TABLE IF NOT EXISTS `citizen_verifications` (
        `verification_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        `citizen_user_id` INT UNSIGNED NOT NULL,
        `first_name` VARCHAR(100) NOT NULL,
        `middle_name` VARCHAR(100) NULL,
        `last_name` VARCHAR(100) NOT NULL,
        `suffix` VARCHAR(20) NULL,
        `sex` ENUM('Male', 'Female') NOT NULL,
        `place_of_birth` VARCHAR(255) NOT NULL,
        `birth_date` DATE NOT NULL,
        `civil_status` VARCHAR(100) NOT NULL,
        `employment_status` VARCHAR(100) NOT NULL,
        `occupation` VARCHAR(150) NOT NULL,
        `educational_attainment` VARCHAR(100) NOT NULL,
        `district` VARCHAR(50) NOT NULL,
        `barangay` VARCHAR(100) NOT NULL,
        `street_address` VARCHAR(255) NOT NULL,
        `years_resident` INT UNSIGNED NOT NULL DEFAULT 1,
        `valid_id_type` VARCHAR(100) NOT NULL,
        `valid_id_number` VARCHAR(100) NOT NULL,
        `id_front_photo_url` LONGTEXT NULL,
        `selfie_photo_url` LONGTEXT NULL,
        `verification_status` ENUM('Pending', 'Under_Review', 'Approved', 'Rejected') NOT NULL DEFAULT 'Pending',
        `rejection_reason` TEXT NULL,
        `reviewed_by` VARCHAR(100) NULL,
        `reviewed_at` DATETIME NULL,
        `submitted_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX (`citizen_user_id`),
        INDEX (`verification_status`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");

    // 2. Insert the verification entry
    $stmt = $pdo->prepare("INSERT INTO citizen_verifications (
        citizen_user_id, first_name, middle_name, last_name, suffix, sex,
        place_of_birth, birth_date, civil_status, employment_status, occupation,
        educational_attainment, district, barangay, street_address, years_resident,
        valid_id_type, valid_id_number, id_front_photo_url, selfie_photo_url, verification_status
    ) VALUES (
        :citizen_user_id, :first_name, :middle_name, :last_name, :suffix, :sex,
        :place_of_birth, :birth_date, :civil_status, :employment_status, :occupation,
        :educational_attainment, :district, :barangay, :street_address, :years_resident,
        :valid_id_type, :valid_id_number, :id_front_photo_url, :selfie_photo_url, 'Pending'
    )");

    $stmt->execute([
        ':citizen_user_id'         => $citizenUserId,
        ':first_name'              => $firstName,
        ':middle_name'             => $middleName,
        ':last_name'               => $lastName,
        ':suffix'                  => $suffix,
        ':sex'                     => $sex,
        ':place_of_birth'          => $placeOfBirth,
        ':birth_date'              => $birthDate,
        ':civil_status'            => $civilStatus,
        ':employment_status'       => $employment,
        ':occupation'              => $occupation,
        ':educational_attainment'  => $education,
        ':district'                => $district,
        ':barangay'                => $barangay,
        ':street_address'          => $streetAddress,
        ':years_resident'          => $yearsResident,
        ':valid_id_type'           => $validIdType,
        ':valid_id_number'         => $validIdNumber,
        ':id_front_photo_url'      => $idFrontPhoto,
        ':selfie_photo_url'        => $selfiePhoto,
    ]);

    $verificationId = $pdo->lastInsertId();

    http_response_code(200);
    echo json_encode([
        "status"          => "success",
        "message"         => "Citizen verification submitted successfully and is under review.",
        "verification_id" => (int)$verificationId,
        "verification_status" => "Pending"
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        "status"  => "error",
        "message" => "Database insertion error: " . $e->getMessage()
    ]);
}
