<?php
// Enforce official Philippine Standard Time (PST, UTC+8)
date_default_timezone_set('Asia/Manila');

// Suppress warnings / notices from polluting JSON API output
error_reporting(0);
ini_set('display_errors', '0');
ob_start();

/**
 * POST Submit Survey Response from Citizen Mobile App
 * Path: /citizen-backend/api/citizen/submit-survey-response.php
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

$surveyId = (int)($input['survey_id'] ?? 0);
$answers = $input['answers'] ?? [];

if (!$surveyId || empty($answers)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Survey ID and answers are required.']);
    exit;
}

try {
    $pdo = getDbConnection();

    // Check if survey exists
    $stmt = $pdo->prepare("SELECT id, title FROM `public_surveys` WHERE id = ?");
    $stmt->execute([$surveyId]);
    $srv = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$srv) {
        http_response_code(404);
        echo json_encode(['success' => false, 'error' => 'Survey not found.']);
        exit;
    }

    $citizenId = !empty($input['citizen_id']) ? (int)$input['citizen_id'] : null;
    $citizenName = !empty($input['citizen_name']) ? trim($input['citizen_name']) : 'Verified Citizen';
    $barangay = !empty($input['barangay']) ? trim($input['barangay']) : 'District 1';
    $ageGroup = !empty($input['age_group']) ? trim($input['age_group']) : 'Adults (30 - 49 yrs)';
    $gender = !empty($input['gender']) ? trim($input['gender']) : null;
    $overallRating = !empty($input['overall_rating']) ? (float)$input['overall_rating'] : null;
    $commentary = !empty($input['commentary']) ? trim($input['commentary']) : null;

    $ins = $pdo->prepare("
        INSERT INTO `survey_responses` 
        (`survey_id`, `citizen_id`, `citizen_name`, `barangay`, `age_group`, `gender`, `answers_json`, `overall_rating`, `commentary`, `submitted_at`)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ");
    $currentPst = date('Y-m-d H:i:s');
    $ins->execute([
        $surveyId,
        $citizenId,
        $citizenName,
        $barangay,
        $ageGroup,
        $gender,
        json_encode($answers),
        $overallRating,
        $commentary,
        $currentPst
    ]);

    echo json_encode([
        'success' => true,
        'message' => 'Thank you! Your survey responses have been officially recorded.',
        'response_id' => (int)$pdo->lastInsertId()
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}
