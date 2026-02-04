<?php
include '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id           = $_POST['id'];
    $old_password = $_POST['old_password'];
    $new_password = $_POST['new_password'];

    // 1. Ambil password lama (hash) dari database
    $query = "SELECT password FROM users WHERE id = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        $db_password = $row['password'];

        // 2. Cek apakah password lama yang diinput USER cocok dengan DATABASE
        if (password_verify($old_password, $db_password)) {
            
            // 3. Kalau cocok, hash password baru dan simpan
            $new_hash = password_hash($new_password, PASSWORD_DEFAULT);
            
            $updateQuery = "UPDATE users SET password = ? WHERE id = ?";
            $updateStmt = $conn->prepare($updateQuery);
            $updateStmt->bind_param("si", $new_hash, $id);
            
            if ($updateStmt->execute()) {
                echo json_encode(["status" => "success", "message" => "Password berhasil diubah"]);
            } else {
                echo json_encode(["status" => "error", "message" => "Gagal update password"]);
            }
            
        } else {
            // Password lama salah
            echo json_encode(["status" => "error", "message" => "Password lama salah!"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "User tidak ditemukan"]);
    }
}
?>