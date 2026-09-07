<?php
/**
 * Database Connection using PDO
 * Supports both Dokploy (Docker container) and Local XAMPP environments.
 */

function getDbConnection(): PDO {
    static $pdo = null;

    if ($pdo !== null) {
        return $pdo;
    }

    // 1. Host resolution (Dokploy envs, Docker service names, or localhost)
    $host = getenv('DB_HOST') ?: (getenv('MYSQL_HOST') ?: '127.0.0.1');
    $port = getenv('DB_PORT') ?: (getenv('MYSQL_PORT') ?: '3306');
    $db   = getenv('DB_NAME') ?: (getenv('MYSQL_DATABASE') ?: 'citizen_verification');
    $user = getenv('DB_USER') ?: (getenv('MYSQL_USER') ?: 'root');
    $pass = getenv('DB_PASSWORD') !== false ? getenv('DB_PASSWORD') : (getenv('MYSQL_PASSWORD') !== false ? getenv('MYSQL_PASSWORD') : (getenv('MYSQL_ROOT_PASSWORD') ?: ''));

    // If running in local XAMPP and database civentral doesn't exist yet, try citizen_verification or civentral
    $dsn = "mysql:host={$host};port={$port};dbname={$db};charset=utf8mb4";

    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ];

    try {
        $pdo = new PDO($dsn, $user, $pass, $options);
        return $pdo;
    } catch (PDOException $e) {
        // Fallback: If connecting to specific db failed, attempt connection without db to allow dynamic creation
        try {
            $fallbackDsn = "mysql:host={$host};port={$port};charset=utf8mb4";
            $tempPdo = new PDO($fallbackDsn, $user, $pass, $options);
            $tempPdo->exec("CREATE DATABASE IF NOT EXISTS `{$db}` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            $pdo = new PDO($dsn, $user, $pass, $options);
            return $pdo;
        } catch (PDOException $e2) {
            http_response_code(500);
            echo json_encode([
                "status"  => "error",
                "message" => "Database connection error: " . $e2->getMessage()
            ]);
            exit;
        }
    }
}
