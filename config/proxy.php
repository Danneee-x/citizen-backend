<?php
// Prevent session lock issues during long requests
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

/**
 * Retrieve incoming Authorization header (Bearer token)
 */
function getIncomingAuthorization(): ?string {
    if (!empty($_SERVER['HTTP_AUTHORIZATION'])) {
        return $_SERVER['HTTP_AUTHORIZATION'];
    }
    if (!empty($_SERVER['REDIRECT_HTTP_AUTHORIZATION'])) {
        return $_SERVER['REDIRECT_HTTP_AUTHORIZATION'];
    }
    if (function_exists('apache_request_headers')) {
        $headers = apache_request_headers();
        foreach ($headers as $k => $v) {
            if (strtolower($k) === 'authorization') {
                return $v;
            }
        }
    }
    return null;
}

/**
 * Robust Reverse Proxy for Core Civentral API Services
 * Handles single URL or candidate URL fallbacks with header & cookie preservation
 *
 * @param string|array $urls Single target URL or array of fallback candidate URLs
 * @param string $method HTTP method (POST, GET, etc.)
 * @param mixed $body Payload (string or array)
 * @param bool $sendCookie Whether to forward session cookies
 * @param array $extraHeaders Custom headers to append
 * @return array ['code' => int, 'body' => mixed]
 */
function proxyRequest($urls, $method = 'POST', $body = null, $sendCookie = true, array $extraHeaders = []): array {
    $targetList = is_array($urls) ? $urls : [$urls];
    $lastResult = [
        'code' => 500,
        'body' => ['status' => 'error', 'message' => 'No proxy targets specified.']
    ];

    foreach ($targetList as $url) {
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
        curl_setopt($ch, CURLOPT_HEADER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 15);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);

        $headers = [
            'Content-Type: application/json',
            'Accept: application/json'
        ];

        // 1. Forward incoming Authorization (Bearer tokens)
        $auth = getIncomingAuthorization();
        if ($auth) {
            $headers[] = 'Authorization: ' . $auth;
        }

        // 2. Forward X-Requested-With if present
        if (!empty($_SERVER['HTTP_X_REQUESTED_WITH'])) {
            $headers[] = 'X-Requested-With: ' . $_SERVER['HTTP_X_REQUESTED_WITH'];
        }

        // 3. Forward session cookies
        $remoteSessId = $_SESSION['remote_phpsessid'] ?? $_COOKIE['remote_phpsessid'] ?? $_COOKIE['PHPSESSID'] ?? null;
        if ($sendCookie && !empty($remoteSessId)) {
            $headers[] = 'Cookie: PHPSESSID=' . $remoteSessId;
        }

        // 4. Merge extra headers
        foreach ($extraHeaders as $h) {
            $headers[] = $h;
        }

        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

        if ($body !== null) {
            curl_setopt($ch, CURLOPT_POSTFIELDS, is_string($body) ? $body : json_encode($body));
        }

        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);

        $response = curl_exec($ch);

        if ($response === false) {
            $lastResult = [
                'code' => 502,
                'body' => [
                    'status' => 'error',
                    'message' => 'Proxy upstream connection error: ' . curl_error($ch)
                ]
            ];
            curl_close($ch);
            continue;
        }

        $headerSize = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        $headerStr = substr($response, 0, $headerSize);
        $bodyStr = substr($response, $headerSize);

        // Parse cookies from response headers
        preg_match_all('/^Set-Cookie:\s*([^;]*)/mi', $headerStr, $matches);
        if (!empty($matches[1])) {
            foreach ($matches[1] as $cookie) {
                $parts = explode('=', $cookie, 2);
                if (count($parts) === 2 && trim($parts[0]) === 'PHPSESSID') {
                    $_SESSION['remote_phpsessid'] = trim($parts[1]);
                }
            }
        }

        $parsedBody = json_decode($bodyStr, true);
        $lastResult = [
            'code' => $httpCode,
            'body' => $parsedBody !== null ? $parsedBody : $bodyStr
        ];

        // If upstream returned 404 and we have another candidate URL, try next candidate
        if ($httpCode === 404 && count($targetList) > 1 && $url !== end($targetList)) {
            continue;
        }

        return $lastResult;
    }

    return $lastResult;
}
