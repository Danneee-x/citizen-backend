<?php
/**
 * CIVentral Backend API Gateway
 * Health Check & Service Status
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
    "status"  => "online",
    "service" => "CIVentral Central REST API Gateway",
    "version" => "1.0.0",
    "endpoints" => [
        "Citizen Auth" => [
            "POST /api/citizen/check-account.php" => "Check account existence",
            "POST /api/citizen/login.php"         => "Citizen login",
            "POST /api/citizen/register.php"      => "Citizen registration",
            "POST /api/citizen/verify-otp.php"    => "Verify email OTP",
            "GET  /api/citizen/profile.php"       => "Get citizen profile"
        ],
        "Citizen Verification" => [
            "POST /api/citizen/verify-citizen.php" => "Submit citizen ID & residency verification"
        ],
        "Admin Management" => [
            "GET  /api/admin/verifications.php"   => "List citizen verification submissions",
            "POST /api/admin/review-citizen.php"  => "Approve or Reject verification",
            "GET  /api/admin/dashboard-stats.php" => "Summary statistics for Admin Dashboard"
        ]
    ],
    "timestamp" => date('Y-m-d H:i:s')
], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
