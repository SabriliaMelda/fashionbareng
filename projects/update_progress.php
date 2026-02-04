<?php
include '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $project_id = $_POST['project_id'];
    $status     = $_POST['status']; // 'Cutting', 'Sewing', 'Finishing', 'Completed'

    $query = "UPDATE projects SET status = ? WHERE id = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("si", $status, $project_id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Status projek diperbarui"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal update status"]);
    }
}
?>