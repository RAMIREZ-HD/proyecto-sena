<?php
header("Content-Type: application/json");
include("../config/conexion.php");

$sql = "SELECT id, nombre, correo FROM usuarios";
$resultado = $conexion->query($sql);

$usuarios = [];

while ($fila = $resultado->fetch_assoc()) {
    $usuarios[] = $fila;
}

echo json_encode($usuarios);

$conexion->close();
?>