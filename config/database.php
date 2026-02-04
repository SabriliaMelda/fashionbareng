<?php
// Izinkan akses dari mana saja (CORS) - Penting untuk development Flutter
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$host = "localhost";
$user = "root";
$pass = "";
$db   = "db_konveksi_management";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    // Jika gagal, kirim JSON error
    die(json_encode(["status" => "error", "message" => "Koneksi database gagal: " . $conn->connect_error]));
}
?>