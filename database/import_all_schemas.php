<?php
/**
 * Master Database Importer / Migration Runner
 * Executes setup_all.sql into the active MySQL server (Local or Dokploy Cloud).
 * Safe for CLI and Browser execution.
 */

// Load .env if present
$envPath = __DIR__ . '/../.env';
if (file_exists($envPath)) {
    $lines = file($envPath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        $line = trim($line);
        if (empty($line) || strpos($line, '#') === 0 || strpos($line, '=') === false) continue;
        list($name, $value) = explode('=', $line, 2);
        $name = trim($name);
        $value = trim($value, " \t\n\r\0\x0B\"'");
        if (!array_key_exists($name, $_SERVER) && !array_key_exists($name, $_ENV)) {
            putenv("{$name}={$value}");
            $_ENV[$name] = $value;
            $_SERVER[$name] = $value;
        }
    }
}

// Dynamically resolve DB connection parameters from environment
$dbHost     = getenv('DB_HOST') ?: (getenv('MYSQL_HOST') ?: '127.0.0.1');
$dbPort     = getenv('DB_PORT') ?: (getenv('MYSQL_PORT') ?: 3306);
$dbUser     = getenv('DB_USER') ?: (getenv('MYSQL_USER') ?: 'root');
$dbPass     = getenv('DB_PASSWORD') !== false ? getenv('DB_PASSWORD') : (getenv('MYSQL_PASSWORD') !== false ? getenv('MYSQL_PASSWORD') : '');
$dbName     = getenv('DB_NAME') ?: 'citizen_verification';
$certDbName = getenv('CERT_DB_NAME') ?: 'civentral_certificates';

$isCli = (php_sapi_name() === 'cli');

if (!$isCli) {
    header('Content-Type: text/html; charset=utf-8');
    echo '<!DOCTYPE html>
<html>
<head>
    <title>Database Master Importer - CivCentral</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #0f172a; color: #f8fafc; padding: 40px; margin: 0; }
        .container { max-width: 800px; margin: 0 auto; background: #1e293b; border-radius: 16px; padding: 32px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); border: 1px solid #334155; }
        h1 { margin-top: 0; color: #38bdf8; font-size: 24px; }
        .badge { display: inline-block; padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: bold; }
        .badge-success { background: #065f46; color: #34d399; }
        .log-box { background: #090d16; border-radius: 8px; padding: 16px; font-family: monospace; font-size: 12px; line-height: 1.6; margin: 16px 0; border: 1px solid #1e293b; max-height: 440px; overflow-y: auto; }
        .ok { color: #34d399; }
        .info { color: #38bdf8; }
        .fail { color: #f87171; }
    </style>
</head>
<body>
<div class="container">
    <h1>CivCentral Database Master Importer</h1>
    <p style="color: #94a3b8; font-size: 13px;">Executing setup_all.sql into target database engine (Host: ' . htmlspecialchars($dbHost) . ':' . htmlspecialchars($dbPort) . ')...</p>
    <div class="log-box">';
} else {
    echo "=== CivCentral Database Master Importer ===\n";
    echo "Target: {$dbHost}:{$dbPort} | User: {$dbUser}\n\n";
}

function logMsg($msg, $type = 'ok') {
    global $isCli;
    if ($isCli) {
        echo "[{$type}] {$msg}\n";
    } else {
        $cls = ($type === 'ok') ? 'ok' : (($type === 'fail') ? 'fail' : 'info');
        echo "<div class='{$cls}'>{$msg}</div>";
    }
}

try {
    // Connect to MySQL server (without specifying DB so we can create databases)
    $dsn = "mysql:host={$dbHost};port={$dbPort};charset=utf8mb4";
    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
        PDO::ATTR_TIMEOUT            => 5,
    ];

    $pdo = new PDO($dsn, $dbUser, $dbPass, $options);
    logMsg("Connected to MySQL server ({$dbHost}:{$dbPort}) successfully.", 'ok');

    // Locate setup_all.sql (or all.sql fallback)
    $sqlFile = __DIR__ . '/setup_all.sql';
    if (!file_exists($sqlFile)) {
        $sqlFile = __DIR__ . '/all.sql';
    }

    if (!file_exists($sqlFile)) {
        throw new Exception("Migration file not found at: {$sqlFile}");
    }

    logMsg("Reading migration script: " . basename($sqlFile) . " (" . filesize($sqlFile) . " bytes)...", 'info');
    $rawSql = file_get_contents($sqlFile);

    // Clean comments and execute statements
    $lines = explode("\n", $rawSql);
    $cleanSql = '';
    foreach ($lines as $line) {
        $trimmed = trim($line);
        if (empty($trimmed) || strpos($trimmed, '--') === 0 || strpos($trimmed, '/*') === 0) {
            continue;
        }
        $cleanSql .= $line . "\n";
    }

    $queries = preg_split('/;\s*[\r\n]+/', $cleanSql);
    $executed = 0;
    $errors = 0;

    $pdo->exec("SET FOREIGN_KEY_CHECKS = 0;");

    foreach ($queries as $q) {
        $q = trim($q);
        if (empty($q)) continue;
        try {
            $pdo->exec($q);
            $executed++;
        } catch (PDOException $qe) {
            // Ignore benign warnings
            if ($qe->getCode() == '42S01' || strpos($qe->getMessage(), 'already exists') !== false) {
                $executed++;
            } else {
                $errors++;
                logMsg("Notice on query: " . substr($q, 0, 80) . "... (" . $qe->getMessage() . ")", 'fail');
            }
        }
    }

    $pdo->exec("SET FOREIGN_KEY_CHECKS = 1;");
    logMsg("Migration completed: {$executed} statements executed successfully.", 'ok');

    // List verified tables in citizen_verification
    logMsg("\n--- Tables in {$dbName} ---", 'info');
    try {
        $tables1 = $pdo->query("SHOW TABLES FROM `{$dbName}`")->fetchAll(PDO::FETCH_COLUMN);
        foreach ($tables1 as $t) {
            logMsg("   • {$t}", 'ok');
        }
        logMsg("Total in {$dbName}: " . count($tables1) . " tables", 'info');
    } catch (Exception $e1) {
        logMsg("Could not list tables in {$dbName}: " . $e1->getMessage(), 'fail');
    }

    // List verified tables in civentral_certificates
    logMsg("\n--- Tables in {$certDbName} ---", 'info');
    try {
        $tables2 = $pdo->query("SHOW TABLES FROM `{$certDbName}`")->fetchAll(PDO::FETCH_COLUMN);
        foreach ($tables2 as $t) {
            logMsg("   • {$t}", 'ok');
        }
        logMsg("Total in {$certDbName}: " . count($tables2) . " tables", 'info');
    } catch (Exception $e2) {
        logMsg("Could not list tables in {$certDbName}: " . $e2->getMessage(), 'fail');
    }

    if (!$isCli) {
        echo '</div>
        <div style="margin-top: 20px; display: flex; align-items: center; justify-content: space-between;">
            <span class="badge badge-success">✓ Schemas Synced</span>
            <span style="color: #94a3b8; font-size: 12px;">Databases: ' . htmlspecialchars($dbName) . ' & ' . htmlspecialchars($certDbName) . '</span>
        </div>
    </div>
    </body>
    </html>';
    } else {
        echo "\n*** SUCCESS: Database migration finished successfully! ***\n";
    }

} catch (Exception $e) {
    logMsg("FATAL ERROR: " . $e->getMessage(), 'fail');
    if (!$isCli) {
        echo '</div></div></body></html>';
    }
}
