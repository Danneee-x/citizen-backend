<?php
// Suppress warnings / notices from polluting JSON API output
error_reporting(0);
ini_set('display_errors', '0');
ob_start();

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
header('Content-Type: application/json; charset=utf-8');

$origin = $_SERVER['HTTP_ORIGIN'] ?? '*';
header("Access-Control-Allow-Origin: {$origin}");
header('Access-Control-Allow-Credentials: true');
header('Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, Accept');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

require_once __DIR__ . '/../../config/proxy.php';

function respond(array $payload, int $statusCode = 200): void {
    http_response_code($statusCode);
    echo json_encode($payload);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];
$apiBaseUrl = rtrim(getenv('API_BASE_URL_CITIZEN') ?: 'https://civentral.tech/api/citizen', '/');
$queryString = !empty($_SERVER['QUERY_STRING']) ? '?' . $_SERVER['QUERY_STRING'] : '';

// Documented upstream endpoint with automatic fallback
$targets = [
    $apiBaseUrl . '/auth/verify.php' . $queryString,
    $apiBaseUrl . '/auth/verify' . $queryString,
    $apiBaseUrl . '/verify.php' . $queryString
];

$body = null;
if (in_array($method, ['POST', 'PUT', 'PATCH', 'DELETE'])) {
    $body = file_get_contents('php://input');
}

$result = proxyRequest($targets, $method, $body);
respond($result['body'], $result['code']);
