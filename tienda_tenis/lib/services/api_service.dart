import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Cambia la IP según tu servidor
  static const String baseUrl = "http://192.168.40.49/APPPROYECTOSENA";

  // ==========================
  // REGISTRO DE USUARIO
  // ==========================

  Future<Map<String, dynamic>> registrarUsuario({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/usuarios/registro.php"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({
        "nombre": nombre,
        "correo": correo,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  // ==========================
  // LOGIN
  // ==========================

  Future<Map<String, dynamic>> login({
    required String correo,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/usuarios/login.php"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({"correo": correo, "password": password}),
    );

    return jsonDecode(response.body);
  }

  // ==========================
  // LISTAR PRODUCTOS
  // ==========================

  Future<List<dynamic>> obtenerProductos() async {
    final response = await http.get(Uri.parse("$baseUrl/productos/listar.php"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Error al obtener productos");
  }

  // ==========================
  // CREAR PRODUCTO
  // ==========================

  Future<Map<String, dynamic>> crearProducto({
    required String nombre,
    required String marca,
    required double precio,
    required String descripcion,
    required String imagen,
    required int stock,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/productos/crear.php"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({
        "nombre": nombre,
        "marca": marca,
        "precio": precio,
        "descripcion": descripcion,
        "imagen": imagen,
        "stock": stock,
      }),
    );

    return jsonDecode(response.body);
  }

  // ==========================
  // ACTUALIZAR PRODUCTO
  // ==========================

  Future<Map<String, dynamic>> actualizarProducto({
    required int id,
    required String nombre,
    required String marca,
    required double precio,
    required String descripcion,
    required String imagen,
    required int stock,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/productos/actualizar.php"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({
        "id": id,
        "nombre": nombre,
        "marca": marca,
        "precio": precio,
        "descripcion": descripcion,
        "imagen": imagen,
        "stock": stock,
      }),
    );

    return jsonDecode(response.body);
  }

  // ==========================
  // ELIMINAR PRODUCTO
  // ==========================

  Future<Map<String, dynamic>> eliminarProducto(int id) async {
    final response = await http.post(
      Uri.parse("$baseUrl/productos/eliminar.php"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({"id": id}),
    );

    return jsonDecode(response.body);
  }
}
