<?php
header("Content-Type: application/json");
include("../config/conexion.php");

$data = json_decode(file_get_contents("php://input"), true);

$id = $data["id"];

$sql = "DELETE FROM carrito WHERE id='$id'";

if ($conexion->query($sql)) {
    echo json_encode([
        "success" => true,
        "message" => "Producto eliminado del carrito"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => $conexion->error
    ]);
}
?>