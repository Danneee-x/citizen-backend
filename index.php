<?php
/**
 * CIVentral Citizen Verification Subsystem API Gateway
 */

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=utf-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

echo json_encode([
    "subsystem"   => "CIVentral Citizen Identity & Verification Subsystem",
    "status"      => "online",
    "version"     => "1.0.0",
    "endpoints"   => [
        "Mobile App (Citizen Verification)" => [
            "POST /api/citizen/verify-citizen.php"      => "Submits citizen verification details, ID, and photos",
            "GET  /api/citizen/verification-status.php" => "Checks if citizen is pending, approved, or rejected"
        ],
        "Web Admin Side (Review & Approval)" => [
            "GET  /api/admin/verifications.php"   => "Lists all verification submissions for Admin review",
            "POST /api/admin/review-citizen.php"  => "Approves or Rejects a verification submission",
            "GET  /api/admin/dashboard-stats.php" => "Dashboard counters for verified and pending citizens"
        ],
        "Inter-Subsystem Shared API (For Other Groups)" => [
            "GET  /api/external/check-verification.php" => "Allows other CIVentral subsystems to verify a citizen by ID"
        ]
    ],
    "timestamp"   => date('Y-m-d H:i:s')
], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
