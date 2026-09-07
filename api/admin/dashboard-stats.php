<?php
/**
 * Endpoint: GET /api/admin/dashboard-stats.php
 * Returns high-level metrics for the City Hall Admin Dashboard.
 */

require_once __DIR__ . '/../../config/cors.php';
require_once __DIR__ . '/../../config/database.php';

$pdo = getDbConnection();

try {
    $citizenCount = $pdo->query("SELECT COUNT(*) FROM citizen_users")->fetchColumn();
    $verifiedCount = $pdo->query("SELECT COUNT(*) FROM citizen_users WHERE registry_completed = 1")->fetchColumn();
    
    $vStats = $pdo->query("SELECT 
        COUNT(*) as total_verifications,
        SUM(CASE WHEN verification_status = 'Pending' THEN 1 ELSE 0 END) as pending_reviews,
        SUM(CASE WHEN verification_status = 'Approved' THEN 1 ELSE 0 END) as approved_reviews,
        SUM(CASE WHEN verification_status = 'Rejected' THEN 1 ELSE 0 END) as rejected_reviews
        FROM citizen_verifications")->fetch();

    $recentPending = $pdo->query("SELECT verification_id, citizen_user_id, first_name, last_name, district, barangay, valid_id_type, submitted_at 
        FROM citizen_verifications 
        WHERE verification_status = 'Pending' 
        ORDER BY submitted_at DESC 
        LIMIT 5")->fetchAll();

    http_response_code(200);
    echo json_encode([
        "status" => "success",
        "stats" => [
            "total_registered_citizens" => (int)$citizenCount,
            "total_verified_citizens"   => (int)$verifiedCount,
            "pending_verifications"     => (int)($vStats['pending_reviews'] ?? 0),
            "approved_verifications"    => (int)($vStats['approved_reviews'] ?? 0),
            "rejected_verifications"    => (int)($vStats['rejected_reviews'] ?? 0),
        ],
        "recent_pending" => $recentPending,
        "server_time"    => date('Y-m-d H:i:s')
    ], JSON_PRETTY_PRINT);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
