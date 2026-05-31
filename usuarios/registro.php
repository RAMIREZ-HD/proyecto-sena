<?php header("Content-Type: application/json");

include("../config/conexion.php");

$data = json_decode(file_get_contents("php://input"), true);

$nombre = $data["nombre"];
$correo = $data["correo"];

$password = password_hash($data["password"], PASSWORD_DEFAULT);

$sql = "INSERT INTO usuarios (nombre, correo, password) VALUES (?, ?, ?)";
$stmt = $conexion->prepare($sql);

$stmt->bind_param("sss", $nombre, $correo, $password);

if ($stmt->execute()) 
    {
    echo json_encode(["success" => true, "message" => "Usuario registrado"]);
} else {
    echo json_encode(["success" => false, "message" => "Error al registrar"]);
}
