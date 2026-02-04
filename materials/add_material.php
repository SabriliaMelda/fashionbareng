<?php
include '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Ambil data
    $name     = $_POST['material_name'];
    $stock    = $_POST['stock_quantity'];
    $unit     = $_POST['unit'];
    $price    = $_POST['price_per_unit'];
    $category = $_POST['category'];
    $image    = $_POST['image_url'];

    // Query Insert
    $query = "INSERT INTO materials (material_name, stock_quantity, unit, price_per_unit, category, image_url) VALUES (?, ?, ?, ?, ?, ?)";
    
    $stmt = $conn->prepare($query);
    
    // PERBAIKAN FINAL: "sissss" 
    // Urutan:
    // 1. name (s - string)
    // 2. stock (i - integer) -> Sesuai kolom int(11)
    // 3. unit (s - string)
    // 4. price (s - string) -> Sesuai kolom decimal, kita kirim string biar aman
    // 5. category (s - string)
    // 6. image (s - string)
    $stmt->bind_param("sissss", $name, $stock, $unit, $price, $category, $image);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Barang berhasil ditambahkan"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal: " . $stmt->error]);
    }
}
?>