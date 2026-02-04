<?php
include '../config/database.php';

$query = "SELECT * FROM calendar_events ORDER BY event_date ASC";
$result = $conn->query($query);

$events = array();

while ($row = $result->fetch_assoc()) {
    $events[] = $row;
}

echo json_encode([
    "status" => "success",
    "data" => $events
]);
?>