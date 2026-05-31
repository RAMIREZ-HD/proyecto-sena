import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProductoFormScreen extends StatefulWidget {
  final Map<String, dynamic>? producto;

  const ProductoFormScreen({super.key, this.producto});

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final ApiService api = ApiService();

  final nombreController = TextEditingController();

  final marcaController = TextEditingController();

  final precioController = TextEditingController();

  final descripcionController = TextEditingController();

  final imagenController = TextEditingController();

  final stockController = TextEditingController();

  bool editar = false;

  @override
  void initState() {
    super.initState();

    if (widget.producto != null) {
      editar = true;

      nombreController.text = widget.producto!["nombre"];

      marcaController.text = widget.producto!["marca"];

      precioController.text = widget.producto!["precio"].toString();

      descripcionController.text = widget.producto!["descripcion"];

      imagenController.text = widget.producto!["imagen"];

      stockController.text = widget.producto!["stock"].toString();
    }
  }

  Future<void> guardar() async {
    Map<String, dynamic> respuesta;

    if (editar) {
      respuesta = await api.actualizarProducto(
        id: int.parse(widget.producto!["id"].toString()),

        nombre: nombreController.text,

        marca: marcaController.text,

        precio: double.parse(precioController.text),

        descripcion: descripcionController.text,

        imagen: imagenController.text,

        stock: int.parse(stockController.text),
      );
    } else {
      respuesta = await api.crearProducto(
        nombre: nombreController.text,

        marca: marcaController.text,

        precio: double.parse(precioController.text),

        descripcion: descripcionController.text,

        imagen: imagenController.text,

        stock: int.parse(stockController.text),
      );
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(respuesta["message"])));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editar ? "Editar Producto" : "Nuevo Producto"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),

            TextField(
              controller: marcaController,
              decoration: const InputDecoration(labelText: "Marca"),
            ),

            TextField(
              controller: precioController,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: "Precio"),
            ),

            TextField(
              controller: descripcionController,

              decoration: const InputDecoration(labelText: "Descripción"),
            ),

            TextField(
              controller: imagenController,

              decoration: const InputDecoration(labelText: "URL Imagen"),
            ),

            TextField(
              controller: stockController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: "Stock"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: guardar,
              child: Text(editar ? "Actualizar" : "Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
