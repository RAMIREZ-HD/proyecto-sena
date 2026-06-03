import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  final ApiService api = ApiService();

  List carrito = [];

  double total = 0;

  @override
  void initState() {
    super.initState();
    cargarCarrito();
  }

  Future<void> cargarCarrito() async {
    try {
      final data = await api.obtenerCarrito(1);

      double suma = 0;

      for (var item in data) {
        suma +=
            (double.parse(item["precio"].toString())) *
            (int.parse(item["cantidad"].toString()));
      }

      setState(() {
        carrito = data;
        total = suma;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> eliminarDelCarrito(int id) async {
    final respuesta = await api.eliminarDelCarrito(id);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(respuesta["message"])));

    cargarCarrito();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mi Carrito")),

      body: carrito.isEmpty
          ? const Center(
              child: Text(
                "El carrito está vacío",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: carrito.length,
                    itemBuilder: (context, index) {
                      final item = carrito[index];

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(item["nombre"]),

                          subtitle: Text(
                            "Cantidad: ${item["cantidad"]}\nPrecio: \$${item["precio"]}",
                          ),

                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              eliminarDelCarrito(
                                int.parse(item["id"].toString()),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Total: \$${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
