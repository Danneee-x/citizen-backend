<?php
/**
 * Endpoint: GET /api/citizen/profile.php
 * Fetches citizen profile, registry status, and verification state.
 */

require_once __DIR__ . '/../../config/cors.php';
require_once __DIR__ . '/../../config/database.php';

$userId = intval($_GET['citizen_user_id'] ?? ($_GET['id'] ?? 0));
$email  = trim($_GET['email'] ?? '');

if ($userId <= 0 && empty($email)) {
    http_response_code(400);
    echo json_encode(["status" => "error", "message" => "Please provide citizen_user_id or email."]);
    exit;
}

$pdo = getDbConnection();

try {
    if ($userId > 0) {
        $stmt = $pdo->prepare("SELECT * FROM citizen_users WHERE citizen_user_id = ? LIMIT 1");
        $stmt->execute([$userId]);
    } else {
        $stmt = $pdo->prepare("SELECT * FROM citizen_users WHERE email = ? LIMIT 1");
        $stmt->execute([$email]);
    }

    $user = $stmt->fetch();
    if (!$user) {
        http_response_code(404);
        echo json_encode(["status" => "error", "message" => "Citizen profile not found."]);
        exit;
    }

    // Fetch latest verification record
    $vStmt = $pdo->prepare("SELECT * FROM citizen_verifications WHERE citizen_user_id = ? ORDER BY submitted_at DESC LIMIT 1");
    $vStmt->execute([$user['citizen_user_id']]);
    $verif = $vStmt->fetch();

    http_response_code(200);
    echo json_encode([
        "status" => "success",
        "data"   => [
            "citizen_user_id"     => (int)$user['citizen_user_id'],
            "first_name"          => $user['first_name'],
            "middle_name"         => $user['middle_name'] ?? '',
            "last_name"           => $user['last_name'],
            "suffix"              => $user['suffix'] ?? '',
            "email"               => $user['email'],
            "mobile_number"       => $user['mobile_number'] ?? '',
            "status"              => $user['status'],
            "registry_completed"  => (int)$user['registry_completed'],
            "verification_status" => $verif['verification_status'] ?? 'Not_Submitted',
            "verification_details" => $verif ? [
                "verification_id" => (int)$verif['verification_id'],
                "district"        => $verif['district'],
                "barangay"        => $verif['barangay'],
                "street_address"  => $verif['street_address'],
                "valid_id_type"   => $verif['valid_id_type'],
                "valid_id_number" => $verif['valid_id_number'],
                "submitted_at"    => $verif['submitted_at'],
                "reviewed_at"     => $verif['reviewed_at'],
            ] : null
        ]
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
