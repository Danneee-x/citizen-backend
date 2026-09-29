<?php
/**
 * POST Submit Civic Consultation Feedback & Stance from Citizen App
 * Path: /citizen-backend/api/citizen/submit-consultation-feedback.php
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Method not allowed']);
    exit;
}

require_once __DIR__ . '/../../config/database.php';

$raw = file_get_contents('php://input');
$input = json_decode($raw, true) ?: $_POST;

$consultationId = (int)($input['consultation_id'] ?? 0);
$stance = trim($input['stance'] ?? 'In Favor');
$commentary = trim($input['commentary'] ?? '');

if (!$consultationId || empty($commentary)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Consultation ID and written commentary are required.']);
    exit;
}

$validStances = ['In Favor', 'Neutral', 'Against', 'Suggested Amendments'];
if (!in_array($stance, $validStances)) {
    $stance = 'In Favor';
}

try {
    $pdo = getDbConnection();

    $stmt = $pdo->prepare("SELECT id, title FROM `civic_consultations` WHERE id = ?");
    $stmt->execute([$consultationId]);
    $c = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$c) {
        http_response_code(404);
        echo json_encode(['success' => false, 'error' => 'Consultation not found.']);
        exit;
    }

    $citizenId = !empty($input['citizen_id']) ? (int)$input['citizen_id'] : null;
    $citizenName = !empty($input['citizen_name']) ? trim($input['citizen_name']) : 'Caloocan Resident';
    $barangay = !empty($input['barangay']) ? trim($input['barangay']) : 'District 1';

    $ins = $pdo->prepare("
        INSERT INTO `consultation_feedbacks`
        (`consultation_id`, `citizen_id`, `citizen_name`, `barangay`, `stance`, `commentary`, `submitted_at`)
        VALUES (?, ?, ?, ?, ?, ?, NOW())
    ");
    $ins->execute([
        $consultationId,
        $citizenId,
        $citizenName,
        $barangay,
        $stance,
        $commentary
    ]);

    echo json_encode([
        'success' => true,
        'message' => 'Your stance and comments have been formally logged for City Legislative Review.',
        'feedback_id' => (int)$pdo->lastInsertId()
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}
