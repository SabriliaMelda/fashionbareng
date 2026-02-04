<?php
include '../config/database.php';

// Query menggabungkan tabel projects dan users (untuk ambil nama pekerja)
$query = "SELECT p.id, p.project_name, p.category, p.urgency_level, p.status, p.deadline, u.full_name as worker_name 
          FROM projects p 
          LEFT JOIN users u ON p.assigned_to = u.id 
          ORDER BY p.deadline ASC";

$result = $conn->query($query);
$projects = array();

while ($row = $result->fetch_assoc()) {
    $projects[] = $row;
}

echo json_encode([
    "status" => "success",
    "data" => $projects
]);
?>