<?php
include '../config/database.php';

$query = "SELECT * FROM materials ORDER BY material_name ASC";
$result = $conn->query($query);

$materials = array();

while ($row = $result->fetch_assoc()) {
    $materials[] = $row;
}

echo json_encode([
    "status" => "success",
    "data" => $materials
]);
?>