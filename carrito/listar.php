<?php
header("Content-Type: application/json");
include("../config/conexion.php");

$usuario_id = $_GET["usuario_id"];

$sql = "SELECT
c.id,
p.nombre,
p.precio,
c.cantidad
FROM carrito c
INNER JOIN productos p
ON c.producto_id = p.id
WHERE c.usuario_id = '$usuario_id'";

$resultado = $conexion->query($sql);

$datos = [];

while($fila = $resultado->fetch_assoc()){
    $datos[] = $fila;
}

echo json_encode($datos);
?>