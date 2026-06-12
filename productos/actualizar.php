<?php

header("Content-Type: application/json");

include("../config/conexion.php");

$data = json_decode(file_get_contents("php://input"), true);

$id = $data["id"];
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

$sql = "UPDATE productos SET
nombre=?,
marca=?,
precio=?,
descripcion=?,
imagen=?,
stock=?
WHERE id=?";

$stmt = $conexion->prepare($sql);

$stmt->bind_param(
    "ssdssii",
    $nombre,
    $marca,
    $precio,
    $descripcion,
    $imagen,
    $stock,
    $id
);

if($stmt->execute()){
    echo json_encode([
        "success" => true,
        "message" => "Producto actualizado exitosamente"
    ]);
}else{
    echo json_encode([
        "success" => false,
        "message" => "Error al actualizar el producto"
    ]);
}

$stmt->close();
$conexion->close();
?>