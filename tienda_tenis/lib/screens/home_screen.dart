import 'package:flutter/material.dart';
import 'productos_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tienda de Tenis")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Productos"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductosScreen()),
            );
          },
        ),
      ),
    );
  }
}
