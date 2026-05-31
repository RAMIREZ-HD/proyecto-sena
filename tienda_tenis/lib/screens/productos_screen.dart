import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'producto_form_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Productos")),

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

      body: ListView.builder(
        itemCount: productos.length,

        itemBuilder: (context, index) {
          final producto = productos[index];

          return Card(
            child: ListTile(
              title: Text(producto["nombre"]),

              subtitle: Text("\$ ${producto["precio"]}"),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,

                children: [
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

                    onPressed: () {
                      eliminar(int.parse(producto["id"].toString()));
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
