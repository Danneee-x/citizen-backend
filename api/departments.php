<?php
/**
 * CIVENTRAL Official Municipal Departments Directory API
 * Returns list of 11 official departments from database / master directory
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'OPTIONS') {
    http_response_code(204);
    exit;
}

$officialDepartments = [
    [
        'department_id' => 13,
        'department_code' => 'PAFM',
        'department_name' => 'Public Assets & Facilities Management (PAFM)',
        'short_name' => 'Public Assets & Facilities',
        'description' => 'City engineering, road repairs, pothole resurfacing, streetlights, bridges, and public grounds.',
        'icon' => 'fa-solid fa-road',
        'default_priority' => 'High',
        'default_sla' => '24 Hours',
        'status' => 'Active'
    ],
    [
        'department_id' => 8,
        'department_code' => 'HSM',
        'department_name' => 'Health & Sanitation Management (HSM)',
        'short_name' => 'Health & Sanitation',
        'description' => 'City health centers, waste collection, public sanitization, vector control, and environmental inspection.',
        'icon' => 'fa-solid fa-recycle',
        'default_priority' => 'Medium',
        'default_sla' => '48 Hours',
        'status' => 'Active'
    ],
    [
        'department_id' => 9,
        'department_code' => 'DRRM',
        'department_name' => 'Disaster Risk Reduction & Emergency Response (DRRM)',
        'short_name' => 'Disaster & Emergency',
        'description' => 'Flood warning, emergency rescue, disaster preparedness, drainage clearance, and evacuation hubs.',
        'icon' => 'fa-solid fa-water',
        'default_priority' => 'Urgent',
        'default_sla' => '4 Hours',
        'status' => 'Active'
    ],
    [
        'department_id' => 12,
        'department_code' => 'TMM',
        'department_name' => 'Transport & Mobility Management (TMM)',
        'short_name' => 'Transport & Mobility',
        'description' => 'Tricycle franchising, traffic control, route regulation, terminal permits, and road safety enforcement.',
        'icon' => 'fa-solid fa-traffic-light',
        'default_priority' => 'Medium',
        'default_sla' => '48 Hours',
        'status' => 'Active'
    ],
    [
        'department_id' => 5,
        'department_code' => 'CIE',
        'department_name' => 'Citizenship Information & Engagement (CIE)',
        'short_name' => 'Citizenship & Engagement',
        'description' => 'Citizen registry, grievance intake, community feedback, public polls, and civic engagement.',
        'icon' => 'fa-solid fa-comments',
        'default_priority' => 'Low',
        'default_sla' => '72 Hours',
        'status' => 'Active'
    ],
    [
        'department_id' => 7,
        'department_code' => 'SSM',
        'department_name' => 'Social Services Management (SSM)',
        'short_name' => 'Social Services',
        'description' => 'Social welfare, indigent burial aid, senior citizens assistance, and solo parent welfare support.',
        'icon' => 'fa-solid fa-hands-holding-child',
        'default_priority' => 'Medium',
        'default_sla' => '48 Hours',
        'status' => 'Active'
    ],
    [
        'department_id' => 6,
        'department_code' => 'PLM',
        'department_name' => 'Permits & Licensing Management (PLM)',
        'short_name' => 'Permits & Licensing',
        'description' => 'Business licenses, local commercial clearances, special permits, and regulatory compliance.',
        'icon' => 'fa-solid fa-file-contract',
        'default_priority' => 'Medium',
        'default_sla' => '72 Hours',
        'status' => 'Active'
    ],
    [
        'department_id' => 10,
        'department_code' => 'UPZH',
        'department_name' => 'Urban Planning Zoning & Housing (UPZH)',
        'short_name' => 'Urban Planning & Housing',
        'description' => 'Zoning permits, land use assessment, urban housing plans, and residential building compliance.',
        'icon' => 'fa-solid fa-city',
        'default_priority' => 'Medium',
        'default_sla' => '72 Hours',
        'status' => 'Active'
    ],
    [
        'department_id' => 11,
        'department_code' => 'RCTS',
        'department_name' => 'Revenue Collection & Treasury Services (RCTS)',
        'short_name' => 'Revenue & Treasury',
        'description' => 'Real property tax, assessment payments, municipal fee collections, and treasury disbursements.',
        'icon' => 'fa-solid fa-coins',
        'default_priority' => 'Low',
        'default_sla' => '72 Hours',
        'status' => 'Active'
    ],
    [
        'department_id' => 4,
        'department_code' => 'ESMS',
        'department_name' => 'Education & Scholarship (ESMS)',
        'short_name' => 'Education & Scholarship',
        'description' => 'Municipal scholarship programs, student grants, educational assistance, and academic awards.',
        'icon' => 'fa-solid fa-graduation-cap',
        'default_priority' => 'Low',
        'default_sla' => '72 Hours',
        'status' => 'Active'
    ],
    [
        'department_id' => 1,
        'department_code' => 'IT',
        'department_name' => 'Information Technology Department (IT)',
        'short_name' => 'Information Technology',
        'description' => 'Network infrastructure, portal security, citizen mobile systems, and LGU systems integration.',
        'icon' => 'fa-solid fa-laptop-code',
        'default_priority' => 'Medium',
        'default_sla' => '24 Hours',
        'status' => 'Active'
    ]
];

try {
    $pdo = new PDO('mysql:host=127.0.0.1;dbname=citizen_verification;charset=utf8mb4', 'root', '', [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
    ]);
    $stmt = $pdo->query("SELECT * FROM `departments` WHERE `status` = 'Active' ORDER BY `department_id` ASC");
    $dbDepts = $stmt->fetchAll();
    if (!empty($dbDepts)) {
        echo json_encode([
            'status' => 'success',
            'source' => 'database',
            'data' => $dbDepts
        ]);
        exit;
    }
} catch (Exception $e) {
    // Fallback to static master list
}

echo json_encode([
    'status' => 'success',
    'source' => 'master_directory',
    'data' => $officialDepartments
]);
