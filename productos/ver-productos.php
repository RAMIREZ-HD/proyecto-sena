<?php
header("Content-Type: text/html; charset=utf-8");
include("../config/conexion.php");

echo "<h2>Productos en la Base de Datos</h2>";
echo "<table border='1' cellpadding='10'>";
echo "<tr><th>ID</th><th>Nombre</th><th>Marca</th><th>Imagen (en BD)</th></tr>";

$sql = "SELECT id, nombre, marca, imagen FROM productos";
$resultado = $conexion->query($sql);

while($fila = $resultado->fetch_assoc()){
    echo "<tr>";
    echo "<td>" . $fila["id"] . "</td>";
    echo "<td>" . $fila["nombre"] . "</td>";
    echo "<td>" . $fila["marca"] . "</td>";
    echo "<td><code>" . $fila["imagen"] . "</code></td>";
    echo "</tr>";
}

echo "</table>";
?>
