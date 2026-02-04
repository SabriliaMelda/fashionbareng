<?php
include '../config/database.php';

// Pastikan method adalah POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    
    // Ambil data dari Body Request
    // ... (Bagian atas sama) ...

    $full_name      = $_POST['full_name'];
    $email          = $_POST['email'];
    $phone_number   = $_POST['phone_number']; // Tambah ini
    $password       = $_POST['password']; 
    $role           = $_POST['role']; 
    $specialization = $_POST['specialization'];

    // Cek Email ATAU No HP sudah ada belum
    $checkQuery = "SELECT id FROM users WHERE email = ? OR phone_number = ?";
    $stmt = $conn->prepare($checkQuery);
    $stmt->bind_param("ss", $email, $phone_number);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "Email atau No HP sudah terdaftar"]);
    } else {
        $hashed_password = password_hash($password, PASSWORD_DEFAULT);

        // Insert Data Lengkap
        $insertQuery = "INSERT INTO users (full_name, email, phone_number, password, role, specialization) VALUES (?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($insertQuery);
        // "ssssss" artinya ada 6 string
        $stmt->bind_param("ssssss", $full_name, $email, $phone_number, $hashed_password, $role, $specialization);

        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Pekerja berhasil didaftarkan"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Gagal mendaftar"]);
        }
    }
// ...
}
?>