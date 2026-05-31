<?php header("Content-Type: application/json");
include("../config/conexion.php");
$data = json_decode(file_get_contents("php://input"), true);
$nombre = $data["nombre"];
$marca = $data["marca"];
$precio = $data["precio"];
$descripcion = $data["descripcion"];
$imagen = $data["imagen"];
$stock = $data["stock"];
$sql = "INSERT INTO productos (nombre, marca, precio, descripcion, imagen, stock) VALUES (?, ?, ?, ?, ?, ?)";
$stmt = $conexion->prepare($sql);
$stmt->bind_param("ssdssi", $nombre, $marca, $precio, $descripcion, $imagen, $stock);
if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Producto creado"]);
} else {
    echo json_encode(["success" => false, "message" => "Error al crear"]);
}
