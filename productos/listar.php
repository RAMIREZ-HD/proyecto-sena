<?php

header("Content-Type: application/json");

include("../config/conexion.php");

$baseUrl = "http://192.168.40.49/APPPROYECTOSENA/uploads/";

$sql = "SELECT * FROM productos";

$resultado = $conexion->query($sql);

$productos = [];

while($fila = $resultado->fetch_assoc()){
    // Construir URL completa para la imagen
    if (!empty($fila["imagen"])) {
        // Si la imagen no comienza con http, es un nombre de archivo local
        if (strpos($fila["imagen"], "http") === false) {
            $fila["imagen"] = $baseUrl . $fila["imagen"];
        }
    }
    $productos[] = $fila;
}

echo json_encode($productos);

?>