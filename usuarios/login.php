<?php header("Content-Type: application/json");
include("../config/conexion.php");
$data = json_decode(file_get_contents("php://input"), true);
$correo = $data["correo"];
$password = $data["password"];
$sql = "SELECT * FROM usuarios WHERE correo=?";
$stmt = $conexion->prepare($sql);
$stmt->bind_param("s", $correo);
$stmt->execute();
$resultado = $stmt->get_result();
if ($resultado->num_rows > 0) {
    $usuario = $resultado->fetch_assoc();
    if (password_verify($password, $usuario["password"])) {
        echo json_encode(["success" => true, "usuario" => ["id" => $usuario["id"], "nombre" => $usuario["nombre"], "correo" => $usuario["correo"]]]);
    } else {
        echo json_encode(["success" => false, "message" => "Contraseña incorrecta"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Usuario no encontrado"]);
}
