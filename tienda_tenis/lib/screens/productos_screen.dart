import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'producto_form_screen.dart';
import 'carrito_screen.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  final ApiService api = ApiService();

  List productos = [];

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  Future<void> cargarProductos() async {
    try {
      final data = await api.obtenerProductos();

      setState(() {
        productos = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> eliminar(int id) async {
    final respuesta = await api.eliminarProducto(id);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(respuesta["message"])));

    cargarProductos();
  }

  Future<void> agregarAlCarrito(int productoId) async {
    try {
      final respuesta = await api.agregarAlCarrito(
        usuarioId: 1, // temporal mientras implementamos sesión completa
        productoId: productoId,
        cantidad: 1,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(respuesta["message"])));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Aquí abriremos la pantalla del carrito
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CarritoScreen()),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductoFormScreen()),
          );

          cargarProductos();
        },
      ),

      body: productos.isEmpty
          ? const Center(
              child: Text(
                "No hay productos registrados",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: productos.length,

              itemBuilder: (context, index) {
                final producto = productos[index];

                return Card(
                  child: ListTile(
                    title: Text(
                      producto["nombre"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Marca: ${producto["marca"]}"),
                        Text("Precio: \$${producto["precio"]}"),
                        Text("Stock: ${producto["stock"]}"),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          tooltip: "Agregar al carrito",
                          onPressed: () {
                            agregarAlCarrito(
                              int.parse(producto["id"].toString()),
                            );
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductoFormScreen(producto: producto),
                              ),
                            );

                            cargarProductos();
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final confirmar = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Eliminar producto"),
                                content: const Text(
                                  "¿Está seguro de que desea eliminar este producto?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Cancelar"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text("Eliminar"),
                                  ),
                                ],
                              ),
                            );

                            if (confirmar == true) {
                              eliminar(int.parse(producto["id"].toString()));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
