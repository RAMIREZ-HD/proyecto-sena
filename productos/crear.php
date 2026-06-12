<?php header("Content-Type: application/json");
include("../config/conexion.php");

$data = json_decode(file_get_contents("php://input"), true);
$nombre = $data["nombre"];
$marca = $data["marca"];
$precio = $data["precio"];
$descripcion = $data["descripcion"];
$imagen = $data["imagen"];
$stock = $data["stock"];

// La imagen puede ser:
// 1. URL externa completa (http://...)
// 2. Nombre de archivo que existe en uploads/
// 3. Ruta relativa a uploads/

$sql = "INSERT INTO productos (nombre, marca, precio, descripcion, imagen, stock) VALUES (?, ?, ?, ?, ?, ?)";
$stmt = $conexion->prepare($sql);
$stmt->bind_param("ssdssi", $nombre, $marca, $precio, $descripcion, $imagen, $stock);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Producto creado exitosamente"]);
} else {
    echo json_encode(["success" => false, "message" => "Error al crear el producto"]);
}

$stmt->close();
$conexion->close();
?>