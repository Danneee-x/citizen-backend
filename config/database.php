<?php
/**
 * Database Connection using PDO
 * Connects directly to Dokploy MySQL (citizen-information-and-engagement)
 * with automatic fallback for local XAMPP environments.
 */

function getDbConnection(): PDO {
    static $pdo = null;

    if ($pdo !== null) {
        return $pdo;
    }

    $db = getenv('DB_NAME') ?: (getenv('MYSQL_DATABASE') ?: 'citizen_verification');

    // Priority connection candidates
    $candidates = [
        // 1. Dokploy Environment Variables (if configured in Dokploy UI)
        [
            'host' => getenv('DB_HOST') ?: getenv('MYSQL_HOST'),
            'port' => getenv('DB_PORT') ?: getenv('MYSQL_PORT') ?: 3306,
            'user' => getenv('DB_USER') ?: getenv('MYSQL_USER'),
            'pass' => getenv('DB_PASSWORD') !== false ? getenv('DB_PASSWORD') : (getenv('MYSQL_PASSWORD') !== false ? getenv('MYSQL_PASSWORD') : getenv('MYSQL_ROOT_PASSWORD')),
        ],
        // 2. Dokploy Internal Docker Mesh (citizen-information-and-engagement service)
        [
            'host' => 'citizeninformationandengagement-citizenregistry-ffbtjn',
            'port' => 3306,
            'user' => 'civentral_user',
            'pass' => 'Civentral2026!',
        ],
        // 3. Dokploy Internal Docker Mesh (mysql user)
        [
            'host' => 'citizeninformationandengagement-citizenregistry-ffbtjn',
            'port' => 3306,
            'user' => 'mysql',
            'pass' => 'm68xnwxsqv3urvon',
        ],
        // 4. Localhost / XAMPP (civentral_user)
        [
            'host' => '127.0.0.1',
            'port' => 3306,
            'user' => 'civentral_user',
            'pass' => 'Civentral2026!',
        ],
        // 5. Localhost / XAMPP Default root
        [
            'host' => '127.0.0.1',
            'port' => 3306,
            'user' => 'root',
            'pass' => '',
        ],
    ];

    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
        PDO::ATTR_TIMEOUT            => 3,
    ];

    $lastError = '';

    foreach ($candidates as $cand) {
        if (empty($cand['host']) || empty($cand['user'])) {
            continue;
        }

        $dsn = "mysql:host={$cand['host']};port={$cand['port']};dbname={$db};charset=utf8mb4";

        try {
            $pdo = new PDO($dsn, $cand['user'], $cand['pass'], $options);
            return $pdo;
        } catch (PDOException $e) {
            // Attempt to connect without db to create it if it doesn't exist
            try {
                $noDbDsn = "mysql:host={$cand['host']};port={$cand['port']};charset=utf8mb4";
                $tmpPdo = new PDO($noDbDsn, $cand['user'], $cand['pass'], $options);
                $tmpPdo->exec("CREATE DATABASE IF NOT EXISTS `{$db}` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;");
                $pdo = new PDO($dsn, $cand['user'], $cand['pass'], $options);
                return $pdo;
            } catch (PDOException $e2) {
                $lastError = $e2->getMessage();
            }
        }
    }

    http_response_code(500);
    echo json_encode([
        "status"  => "error",
        "message" => "Database connection error: Unable to connect to citizen-information-and-engagement database. " . $lastError
    ]);
    exit;
}
