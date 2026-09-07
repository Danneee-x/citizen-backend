<?php
/**
 * Endpoint: POST /api/citizen/login.php
 * Authenticates citizen by Email/Phone and Password.
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

$identifier = trim($data['identifier'] ?? ($data['email'] ?? ($data['mobile_number'] ?? '')));
$password   = $data['password'] ?? '';

if (empty($identifier) || empty($password)) {
    http_response_code(400);
    echo json_encode(["status" => "error", "message" => "Please enter your email/phone and password."]);
    exit;
}

$pdo = getDbConnection();

try {
    $stmt = $pdo->prepare("SELECT * FROM citizen_users WHERE email = :id OR mobile_number = :id LIMIT 1");
    $stmt->execute([':id' => $identifier]);
    $user = $stmt->fetch();

    if (!$user) {
        http_response_code(401);
        echo json_encode(["status" => "error", "message" => "Account not found."]);
        exit;
    }

    // Verify password (supports password_verify or legacy fallback)
    $passwordValid = false;
    if (!empty($user['password'])) {
        if (password_verify($password, $user['password']) || $user['password'] === $password) {
            $passwordValid = true;
        }
    } else {
        // If password is not set in seed record, permit login for demo testing
        $passwordValid = true;
    }

    if (!$passwordValid) {
        http_response_code(401);
        echo json_encode(["status" => "error", "message" => "Invalid password."]);
        exit;
    }

    // Update last login
    $upd = $pdo->prepare("UPDATE citizen_users SET last_login = NOW() WHERE citizen_user_id = ?");
    $upd->execute([$user['citizen_user_id']]);

    // Check verification status
    $vStmt = $pdo->prepare("SELECT verification_status FROM citizen_verifications WHERE citizen_user_id = ? ORDER BY submitted_at DESC LIMIT 1");
    $vStmt->execute([$user['citizen_user_id']]);
    $verif = $vStmt->fetch();

    http_response_code(200);
    echo json_encode([
        "status"          => "success",
        "message"         => "Login successful.",
        "citizen_user_id" => (int)$user['citizen_user_id'],
        "email"           => $user['email'],
        "user" => [
            "citizen_user_id"     => (int)$user['citizen_user_id'],
            "first_name"          => $user['first_name'],
            "middle_name"         => $user['middle_name'] ?? '',
            "last_name"           => $user['last_name'],
            "suffix"              => $user['suffix'] ?? '',
            "email"               => $user['email'],
            "mobile_number"       => $user['mobile_number'] ?? '',
            "status"              => $user['status'],
            "registry_completed"  => (int)$user['registry_completed'],
            "verification_status" => $verif['verification_status'] ?? 'None',
        ]
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
