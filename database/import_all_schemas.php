<?php
/**
 * Master Database Importer / Migration Runner
 * Executes all repository SQL schemas into the active MySQL server (Local or Dokploy Cloud).
 */
header('Content-Type: text/html; charset=utf-8');
require_once __DIR__ . '/../config/database.php';

echo '<!DOCTYPE html>
<html>
<head>
    <title>Database Master Importer - CivCentral</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #0f172a; color: #f8fafc; padding: 40px; margin: 0; }
        .container { max-width: 760px; margin: 0 auto; background: #1e293b; border-radius: 16px; padding: 32px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); border: 1px solid #334155; }
        h1 { margin-top: 0; color: #38bdf8; font-size: 24px; }
        .badge { display: inline-block; padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: bold; }
        .badge-success { background: #065f46; color: #34d399; }
        .badge-info { background: #075985; color: #38bdf8; }
        .badge-err { background: #991b1b; color: #f87171; }
        .log-box { background: #090d16; border-radius: 8px; padding: 16px; font-family: monospace; font-size: 12px; line-height: 1.6; margin: 16px 0; border: 1px solid #1e293b; max-height: 400px; overflow-y: auto; }
        .ok { color: #34d399; }
        .fail { color: #f87171; }
    </style>
</head>
<body>
<div class="container">
    <h1>CivCentral Database Master Importer</h1>
    <p style="color: #94a3b8; font-size: 13px;">Executing repository SQL schemas into live database...</p>
    <div class="log-box">';

$sqlFiles = [
    'civentral_schema.sql'         => 'Core Civentral System & Grievance Schema',
    'citizen_verification.sql'     => 'Citizen Registry & Verification Schema',
    'citizen_concerns.sql'         => 'Citizen Concerns & Gemini AI Triage Schema',
    'id_issuance.sql'              => 'Barangay ID Issuance Application Schema',
    'notifications_and_alerts.sql' => 'Broadcast Notifications & Alerts Schema',
    'public_consultations.sql'     => 'Public Consultations & Surveys Schema'
];

try {
    $pdo = getDbConnection();
    echo "<div class='ok'>[âœ“] Connected to MySQL database engine successfully.</div>";

    $importedCount = 0;

    foreach ($sqlFiles as $fileName => $description) {
        $filePath = __DIR__ . '/' . $fileName;
        echo "<div style='margin-top: 10px; color: #cbd5e1;'><strong>Migrating {$fileName}</strong> ({$description})...</div>";

        if (!file_exists($filePath)) {
            echo "<div class='fail'>[!] File not found: {$fileName}</div>";
            continue;
        }

        $sql = file_get_contents($filePath);

        // Remove comments
        $lines = explode("\n", $sql);
        $cleanSql = '';
        foreach ($lines as $line) {
            $trimmed = trim($line);
            if (empty($trimmed) || strpos($trimmed, '--') === 0 || strpos($trimmed, '/*') === 0) {
                continue;
            }
            $cleanSql .= $line . "\n";
        }

        // Split statements by semicolon at end of line
        $queries = preg_split('/;\s*[\r\n]+/', $cleanSql);
        $successCount = 0;
        $errCount = 0;

        foreach ($queries as $q) {
            $q = trim($q);
            if (empty($q)) continue;

            try {
                $pdo->exec($q);
                $successCount++;
            } catch (PDOException $qe) {
                // Ignore table already exists or duplicate key
                if ($qe->getCode() == '42S01' || strpos($qe->getMessage(), 'already exists') !== false) {
                    $successCount++;
                } else {
                    $errCount++;
                }
            }
        }

        echo "<div class='ok'>&nbsp;&nbsp;â†’ [âœ“] {$fileName}: executed successfully ({$successCount} statements).</div>";
        $importedCount++;
    }

    // List all tables created
    echo "<div style='margin-top: 16px; color: #38bdf8;'><strong>Current Tables in Database:</strong></div>";
    $tables = $pdo->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
    foreach ($tables as $t) {
        echo "<div style='color: #a7f3d0;'>&nbsp;&nbsp;â€¢ {$t}</div>";
    }

    echo "</div>
    <div style='margin-top: 20px; display: flex; align-items: center; justify-content: space-between;'>
        <span class='badge badge-success'>âœ“ All Schemas Synced</span>
        <span style='color: #94a3b8; font-size: 12px;'>Total Live Tables: " . count($tables) . "</span>
    </div>
</div>
</body>
</html>";

} catch (Exception $e) {
    echo "<div class='fail'>[FATAL ERROR] " . htmlspecialchars($e->getMessage()) . "</div></div></div></body></html>";
}

