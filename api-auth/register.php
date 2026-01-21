<?php
// register.php
file_put_contents(__DIR__ . "/error_register.log", "TEST\n", FILE_APPEND);

// ====== HEADERS (WAJIB UNTUK ANDROID HP) ======
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type, Accept');
header('Access-Control-Allow-Methods: POST, OPTIONS');

// ====== LOG HIT (buat bukti request masuk) ======
file_put_contents(__DIR__ . "/hp_hit.log", date("c") . " HIT from " . ($_SERVER['REMOTE_ADDR'] ?? '-') . " METHOD=" . ($_SERVER['REQUEST_METHOD'] ?? '-') . "\n", FILE_APPEND);

// ====== HANDLE PREFLIGHT OPTIONS (PENTING) ======
if (($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {
  http_response_code(200);
  echo json_encode(["ok" => true, "method" => "OPTIONS"]);
  exit;
}

// ====== HARUS POST ======
if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
  http_response_code(405);
  echo json_encode(["success" => false, "message" => "Method harus POST"]);
  exit;
}

require __DIR__ . "/db.php";

// ====== AMBIL BODY ======
$raw = file_get_contents("php://input");
file_put_contents(__DIR__ . "/raw_register.log", date("c") . " RAW=" . $raw . "\n", FILE_APPEND);

$input = json_decode($raw, true);
if (!is_array($input)) {
  http_response_code(400);
  echo json_encode(["success" => false, "message" => "Body JSON tidak valid"]);
  exit;
}

$name = trim($input["name"] ?? "");
$phone = trim($input["phone"] ?? "");
$email = trim($input["email"] ?? "");
$password = (string)($input["password"] ?? "");
$password_confirmation = (string)($input["password_confirmation"] ?? "");
$agree_terms = (bool)($input["agree_terms"] ?? false);

// ====== VALIDASI ======
if ($name === "") {
  http_response_code(422);
  echo json_encode(["success" => false, "message" => "Nama wajib diisi"]);
  exit;
}

if ($phone === "" && $email === "") {
  http_response_code(422);
  echo json_encode(["success" => false, "message" => "Isi nomor telepon atau email"]);
  exit;
}

if ($email !== "" && !filter_var($email, FILTER_VALIDATE_EMAIL)) {
  http_response_code(422);
  echo json_encode(["success" => false, "message" => "Format email tidak valid"]);
  exit;
}

if (strlen($password) < 6) {
  http_response_code(422);
  echo json_encode(["success" => false, "message" => "Password minimal 6 karakter"]);
  exit;
}

if ($password !== $password_confirmation) {
  http_response_code(422);
  echo json_encode(["success" => false, "message" => "Konfirmasi password tidak sama"]);
  exit;
}

if (!$agree_terms) {
  http_response_code(422);
  echo json_encode(["success" => false, "message" => "Wajib setuju syarat & ketentuan"]);
  exit;
}

// ====== NORMALISASI PHONE (opsional) ======
if ($phone !== "") {
  $phone = preg_replace('/\D+/', '', $phone);
  if (str_starts_with($phone, "0")) {
    $phone = "62" . substr($phone, 1);
  }
}

$password_hash = password_hash($password, PASSWORD_BCRYPT);

try {
  // ====== CEK UNIK ======
  if ($phone !== "") {
    $st = $pdo->prepare("SELECT id FROM users WHERE phone = ? LIMIT 1");
    $st->execute([$phone]);
    if ($st->fetch()) {
      http_response_code(422);
      echo json_encode(["success" => false, "message" => "Nomor telepon sudah terdaftar"]);
      exit;
    }
  }

  if ($email !== "") {
    $st = $pdo->prepare("SELECT id FROM users WHERE email = ? LIMIT 1");
    $st->execute([$email]);
    if ($st->fetch()) {
      http_response_code(422);
      echo json_encode(["success" => false, "message" => "Email sudah terdaftar"]);
      exit;
    }
  }

  // ====== INSERT ======
  $st = $pdo->prepare("
    INSERT INTO users (name, phone, email, password, agree_terms, agreed_at, created_at, updated_at)
    VALUES (?, ?, ?, ?, 1, NOW(), NOW(), NOW())
  ");
  $st->execute([$name, $phone ?: null, $email ?: null, $password_hash]);

  echo json_encode([
    "success" => true,
    "message" => "Register berhasil",
    "data" => [
      "id" => (int)$pdo->lastInsertId(),
      "name" => $name,
      "phone" => $phone ?: null,
      "email" => $email ?: null,
    ]
  ]);
}  catch (PDOException $e) {

  file_put_contents(
      __DIR__ . "/error_register.log",
      date("c") . " ERROR=" . $e->getMessage() . "\n",
      FILE_APPEND
  );

  http_response_code(500);

  echo json_encode([
      "success" => false,
      "message" => "DB Error",
      "sql_error" => $e->getMessage()
  ]);
}
