<?php
header("Content-Type: application/json");
include("../config/conexion.php");

$data = json_decode(file_get_contents("php://input"), true);

$usuario_id = $data["usuario_id"];
$producto_id = $data["producto_id"];
$cantidad = $data["cantidad"];

$sql = "INSERT INTO carrito(usuario_id, producto_id, cantidad)
VALUES('$usuario_id','$producto_id','$cantidad')";

if ($conexion->query($sql)) {
    echo json_encode([
        "success" => true,
        "message" => "Producto agregado al carrito"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => $conexion->error
    ]);
}
?>