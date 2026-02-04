<?php
include '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $project_name  = $_POST['project_name'];
    $category      = $_POST['category'];      // 'Kemeja', 'Kaos', dll
    $urgency_level = $_POST['urgency_level']; // 'Low', 'High', 'Critical'
    $deadline      = $_POST['deadline'];      // Format: YYYY-MM-DD
    $assigned_to   = $_POST['assigned_to'];   // ID user pekerja

    $query = "INSERT INTO projects (project_name, category, urgency_level, status, deadline, assigned_to) VALUES (?, ?, ?, 'Pending', ?, ?)";
    
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ssssi", $project_name, $category, $urgency_level, $deadline, $assigned_to);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Projek baru berhasil dibuat"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal membuat projek"]);
    }
}
?>