<?php
include '../config/database.php';

$id = $_GET['id'];

$query = "SELECT id, full_name, email, phone_number, role FROM users WHERE id = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode(["status" => "success", "data" => $row]);
} else {
    echo json_encode(["status" => "error", "message" => "User tidak ditemukan"]);
}
?>