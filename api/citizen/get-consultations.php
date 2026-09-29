<?php
/**
 * GET Active Civic Consultations for Citizen App
 * Path: /citizen-backend/api/citizen/get-consultations.php
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once __DIR__ . '/../../config/database.php';

try {
    $pdo = getDbConnection();

    $tableCheck = $pdo->query("SHOW TABLES LIKE 'civic_consultations'")->fetch();
    if (!$tableCheck) {
        echo json_encode(['success' => true, 'data' => []]);
        exit;
    }

    $stmt = $pdo->query("
        SELECT c.*, 
               COUNT(f.id) AS participantsCount
        FROM `civic_consultations` c
        LEFT JOIN `consultation_feedbacks` f ON f.consultation_id = c.id
        WHERE c.status IN ('Open', 'Closing Soon', 'Under Review')
        GROUP BY c.id
        ORDER BY c.created_at DESC
    ");
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $formatted = [];
    foreach ($rows as $r) {
        $formatted[] = [
            'id' => (string)$r['id'],
            'consultationCode' => $r['consultation_code'],
            'title' => $r['title'],
            'category' => $r['category'],
            'backgroundInfo' => $r['background_info'],
            'objective' => $r['objective'],
            'closingDate' => date('F d, Y', strtotime($r['closing_date'])),
            'status' => $r['status'],
            'participantsCount' => (int)($r['participantsCount'] ?? 0)
        ];
    }

    echo json_encode([
        'success' => true,
        'count' => count($formatted),
        'data' => $formatted
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}
