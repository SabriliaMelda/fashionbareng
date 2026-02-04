<?php
include '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $title       = $_POST['title'];
    $event_date  = $_POST['event_date']; // Format: YYYY-MM-DD HH:MM:SS
    $description = $_POST['description'];
    $type        = $_POST['type']; // 'Meeting', 'Deadline', dll

    $query = "INSERT INTO calendar_events (title, event_date, description, type) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ssss", $title, $event_date, $description, $type);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Acara berhasil ditambahkan"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal menambah acara"]);
    }
}
?>