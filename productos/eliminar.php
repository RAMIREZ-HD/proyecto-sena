<?php header("Content-Type: application/json");
include("../config/conexion.php");
$data = json_decode(file_get_contents("php://input"), true);
$id = $data["id"];
$sql = "DELETE FROM productos WHERE id=?";
$stmt = $conexion->prepare($sql);
$stmt->bind_param("i", $id);
if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Producto eliminado"]);
} else {
    echo json_encode(["success" => false, "message" => "Error al eliminar"]);
}
