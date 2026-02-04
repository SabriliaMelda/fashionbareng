<?php
include '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id             = $_POST['id'];
    $full_name      = $_POST['full_name'];
    $email          = $_POST['email'];
    $phone_number   = $_POST['phone_number'];

    $query = "UPDATE users SET full_name=?, email=?, phone_number=? WHERE id=?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ssssi", $full_name, $email, $phone_number, $id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Profil berhasil diperbarui"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal update profil"]);
    }
}
?>