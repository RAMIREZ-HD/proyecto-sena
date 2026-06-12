<?php
// Endpoint de prueba para verificar URLs de imágenes
// Accede desde: http://192.168.40.49/APPPROYECTOSENA/productos/test-urls.php

header("Content-Type: application/json");
include("../config/conexion.php");

$baseUrl = "http://192.168.40.49/APPPROYECTOSENA/uploads/";

$sql = "SELECT id, nombre, marca, imagen FROM productos LIMIT 10";
$resultado = $conexion->query($sql);

$productos = [];

while($fila = $resultado->fetch_assoc()){
    $imagen = $fila["imagen"] ?? "";
    $imagenCompleta = $imagen;

    // Construir URL completa si es necesario
    if (!empty($imagen) && strpos($imagen, "http") === false) {
        $imagenCompleta = $baseUrl . $imagen;
    }

    $productos[] = [
        "id" => $fila["id"],
        "nombre" => $fila["nombre"],
        "marca" => $fila["marca"],
        "imagen_original" => $imagen,
        "imagen_completa" => $imagenCompleta,
        "tipo" => (strpos($imagen, "http") === false) ? "local" : "externa"
    ];
}

echo json_encode([
    "total" => count($productos),
    "base_url" => $baseUrl,
    "productos" => $productos
], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);

$resultado->close();
$conexion->close();
?>
