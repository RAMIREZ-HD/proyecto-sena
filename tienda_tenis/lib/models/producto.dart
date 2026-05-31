class Producto {
  final int id;
  final String nombre;
  final String marca;
  final double precio;
  final String descripcion;
  final String imagen;
  final int stock;

  Producto({
    required this.id,
    required this.nombre,
    required this.marca,
    required this.precio,
    required this.descripcion,
    required this.imagen,
    required this.stock,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: int.parse(json['id'].toString()),
      nombre: json['nombre'],
      marca: json['marca'],
      precio: double.parse(json['precio'].toString()),
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      stock: int.parse(json['stock'].toString()),
    );
  }
}
