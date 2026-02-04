<?php
include '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Ambil input (bisa email atau phone_number)
    $loginValue = isset($_POST['email']) ? $_POST['email'] : '';
    $password   = isset($_POST['password']) ? $_POST['password'] : '';

    if (empty($loginValue) || empty($password)) {
        echo json_encode(["status" => "error", "message" => "Email/No HP dan Password wajib diisi"]);
        exit;
    }

    // Query Cari User: Cek di kolom email ATAU phone_number
    $query = "SELECT * FROM users WHERE email = ? OR phone_number = ? LIMIT 1";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ss", $loginValue, $loginValue);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($user = $result->fetch_assoc()) {
        // Cek Password
        if (password_verify($password, $user['password'])) {
            // Hapus password dari array sebelum dikirim ke Flutter demi keamanan
            unset($user['password']);
            echo json_encode([
                "status" => "success", 
                "message" => "Login Berhasil",
                "data" => $user
            ]);
        } else {
            echo json_encode(["status" => "error", "message" => "Password salah"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "User tidak ditemukan"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid Request"]);
}
?>