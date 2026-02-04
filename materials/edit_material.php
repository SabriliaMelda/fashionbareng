<?php
include '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'];
    $material_name = $_POST['material_name'];
    $stock_quantity = $_POST['stock_quantity'];
    $price_per_unit = $_POST['price_per_unit'];
    $image_url = $_POST['image_url'];

    // Update query
    $query = "UPDATE materials SET 
              material_name = ?, 
              stock_quantity = ?, 
              price_per_unit = ?, 
              image_url = ? 
              WHERE id = ?";

    $stmt = $conn->prepare($query);
    $stmt->bind_param("siisi", $material_name, $stock_quantity, $price_per_unit, $image_url, $id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Data berhasil diupdate"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal update data"]);
    }
}
?>