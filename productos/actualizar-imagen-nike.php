<?php
header("Content-Type: application/json; charset=utf-8");
include("../config/conexion.php");

$nombreArchivo = "4419dfdd7a4a4560bd994abcc522d96f.webp";

// Actualizar productos Nike (o todos si contienen "Air Max")
$sql = "UPDATE productos
        SET imagen = ?
        WHERE nombre LIKE '%Nike%' OR nombre LIKE '%Air Max%' OR marca LIKE '%Nike%'";

$stmt = $conexion->prepare($sql);
$stmt->bind_param("s", $nombreArchivo);

if ($stmt->execute()) {
    $actualizados = $stmt->affected_rows;

    // Verificar que se actualizó correctamente
    $sqlVerify = "SELECT id, nombre, marca, imagen FROM productos WHERE imagen = ?";
    $stmtVerify = $conexion->prepare($sqlVerify);
    $stmtVerify->bind_param("s", $nombreArchivo);
    $stmtVerify->execute();
    $resultVerify = $stmtVerify->get_result();
    $productos = $resultVerify->fetch_all(MYSQLI_ASSOC);

    echo json_encode([
        "success" => true,
        "message" => "Actualización completada",
        "actualizados" => $actualizados,
        "productos_actualizados" => $productos,
        "base_url" => "http://192.168.40.49/APPPROYECTOSENA/uploads/",
        "url_completa" => "http://192.168.40.49/APPPROYECTOSENA/uploads/" . $nombreArchivo
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Error al actualizar: " . $stmt->error
    ]);
}

$stmt->close();
$stmtVerify->close();
$conexion->close();
?>
