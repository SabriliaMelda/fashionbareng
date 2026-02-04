<?php
include '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Kita sebut inputannya 'identifier' (bisa berupa email atau no hp)
    $identifier = $_POST['email']; // Di Flutter kita kirim pakai key 'email' biar gak ubah banyak kodingan
    $password   = $_POST['password'];

    // Query Cek Email ATAU No HP
    $query = "SELECT id, full_name, password, role, specialization, phone_number 
              FROM users 
              WHERE email = ? OR phone_number = ?";
              
    $stmt = $conn->prepare($query);
    // Bind parameter dua kali (untuk email dan untuk phone_number)
    $stmt->bind_param("ss", $identifier, $identifier);
    
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        if (password_verify($password, $row['password'])) {
            echo json_encode([
                "status" => "success",
                "message" => "Login berhasil",
                "data" => $row
            ]);
        } else {
            echo json_encode(["status" => "error", "message" => "Password salah"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Email atau Nomor HP tidak ditemukan"]);
    }
}
?>