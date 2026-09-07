<?php
/**
 * Endpoint: POST /api/citizen/register.php
 * Creates a new citizen account in citizen_users.
 */

require_once __DIR__ . '/../../config/cors.php';
require_once __DIR__ . '/../../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["status" => "error", "message" => "Method Not Allowed"]);
    exit;
}

$raw = file_get_contents('php://input');
$data = json_decode($raw, true);

$firstName     = trim($data['first_name'] ?? '');
$middleName    = trim($data['middle_name'] ?? '') ?: null;
$hasNoMiddle   = !empty($data['has_no_middle_name']) ? 1 : 0;
$lastName      = trim($data['last_name'] ?? '');
$suffix        = trim($data['suffix'] ?? '') ?: null;
$email         = trim(strtolower($data['email'] ?? ''));
$mobileNumber  = trim($data['mobile_number'] ?? '') ?: null;
$password      = $data['password'] ?? '';

if (empty($firstName) || empty($lastName) || empty($email) || empty($password)) {
    http_response_code(422);
    echo json_encode(["status" => "error", "message" => "All required fields must be provided."]);
    exit;
}

$pdo = getDbConnection();

try {
    // Check if email already registered
    $check = $pdo->prepare("SELECT citizen_user_id FROM citizen_users WHERE email = ? LIMIT 1");
    $check->execute([$email]);
    if ($check->fetch()) {
        http_response_code(409);
        echo json_encode(["status" => "error", "message" => "An account with this email address already exists."]);
        exit;
    }

    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    $stmt = $pdo->prepare("INSERT INTO citizen_users (
        first_name, middle_name, has_no_middle_name, last_name, suffix, email, mobile_number, password, status, registry_completed
    ) VALUES (
        :first_name, :middle_name, :has_no_middle, :last_name, :suffix, :email, :mobile_number, :password, 'Active', 0
    )");

    $stmt->execute([
        ':first_name'     => $firstName,
        ':middle_name'    => $middleName,
        ':has_no_middle'  => $hasNoMiddle,
        ':last_name'      => $lastName,
        ':suffix'         => $suffix,
        ':email'          => $email,
        ':mobile_number'  => $mobileNumber,
        ':password'       => $hashedPassword,
    ]);

    $newId = $pdo->lastInsertId();

    http_response_code(201);
    echo json_encode([
        "status"          => "success",
        "message"         => "Account created successfully.",
        "citizen_user_id" => (int)$newId,
        "email"           => $email,
        "user" => [
            "citizen_user_id"    => (int)$newId,
            "first_name"         => $firstName,
            "middle_name"        => $middleName ?? '',
            "last_name"          => $lastName,
            "suffix"             => $suffix ?? '',
            "email"              => $email,
            "mobile_number"      => $mobileNumber ?? '',
            "registry_completed" => 0,
        ]
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
