<?php
include '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'];
    $amount = $_POST['amount']; // Jumlah penambahan (misal: 10)

    // Query Update: Stok Lama + Stok Baru
    $query = "UPDATE materials SET stock_quantity = stock_quantity + ? WHERE id = ?";
    
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ii", $amount, $id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Stok berhasil ditambahkan"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal menambah stok"]);
    }
}
?>