<?php
$host = "localhost";
$user = "root";
$password = "";
$database = "app_proyecto_sena";

$conexion = new mysqli($host, $user, $password, $database);
if ($conexion->connect_error) {
    die(json_encode([
        "success" => false,
        "message" => "Error de conexión"
    ]));
}
$conexion->set_charset("utf8");
?>