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
  bool _cargando = false;

  static const Color primaryColor = Color(0xFF1A1A2E);
  static const Color accentColor = Color(0xFF00C9A7);
  static const Color cardBg = Color(0xFFF8F9FA);

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

  @override
  void dispose() {
    nombreController.dispose();
    marcaController.dispose();
    precioController.dispose();
    descripcionController.dispose();
    imagenController.dispose();
    stockController.dispose();
    super.dispose();
  }

  bool _validar() {
    if (nombreController.text.trim().isEmpty) {
      _mostrarError("El nombre es requerido");
      return false;
    }
    if (marcaController.text.trim().isEmpty) {
      _mostrarError("La marca es requerida");
      return false;
    }
    if (precioController.text.trim().isEmpty) {
      _mostrarError("El precio es requerido");
      return false;
    }
    try {
      double precio = double.parse(precioController.text);
      if (precio <= 0) {
        _mostrarError("El precio debe ser mayor a 0");
        return false;
      }
    } catch (e) {
      _mostrarError("El precio debe ser un número válido");
      return false;
    }
    if (stockController.text.trim().isEmpty) {
      _mostrarError("El stock es requerido");
      return false;
    }
    try {
      int stock = int.parse(stockController.text);
      if (stock < 0) {
        _mostrarError("El stock no puede ser negativo");
        return false;
      }
    } catch (e) {
      _mostrarError("El stock debe ser un número válido");
      return false;
    }
    return true;
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> guardar() async {
    if (!_validar()) return;

    setState(() => _cargando = true);

    try {
      Map<String, dynamic> respuesta;

      if (editar) {
        respuesta = await api.actualizarProducto(
          id: int.parse(widget.producto!["id"].toString()),
          nombre: nombreController.text.trim(),
          marca: marcaController.text.trim(),
          precio: double.parse(precioController.text),
          descripcion: descripcionController.text.trim(),
          imagen: imagenController.text.trim(),
          stock: int.parse(stockController.text),
        );
      } else {
        respuesta = await api.crearProducto(
          nombre: nombreController.text.trim(),
          marca: marcaController.text.trim(),
          precio: double.parse(precioController.text),
          descripcion: descripcionController.text.trim(),
          imagen: imagenController.text.trim(),
          stock: int.parse(stockController.text),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(respuesta["message"])),
            ],
          ),
          backgroundColor: accentColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _cargando = false);
      _mostrarError("Error al guardar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBg,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          editar ? "Editar Producto" : "Nuevo Producto",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Información del Producto",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 24),

              _Campo(
                controller: nombreController,
                label: "Nombre del producto",
                icono: Icons.inventory_2_outlined,
              ),

              const SizedBox(height: 16),

              _Campo(
                controller: marcaController,
                label: "Marca",
                icono: Icons.local_offer_outlined,
              ),

              const SizedBox(height: 16),

              _Campo(
                controller: precioController,
                label: "Precio",
                icono: Icons.attach_money_outlined,
                teclado: TextInputType.number,
              ),

              const SizedBox(height: 16),

              _Campo(
                controller: descripcionController,
                label: "Descripción",
                icono: Icons.description_outlined,
              ),

              const SizedBox(height: 16),

              _Campo(
                controller: imagenController,
                label: "URL de la imagen",
                icono: Icons.image_outlined,
              ),

              const SizedBox(height: 16),

              _Campo(
                controller: stockController,
                label: "Stock disponible",
                icono: Icons.store_outlined,
                teclado: TextInputType.number,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _cargando ? null : guardar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: editar ? primaryColor : accentColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        (editar ? primaryColor : accentColor).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                  child: _cargando
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          editar ? "Actualizar" : "Guardar",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Campo extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icono;
  final TextInputType teclado;
  final bool obscure;
  final Widget? sufijo;

  const _Campo({
    required this.controller,
    required this.label,
    required this.icono,
    this.teclado = TextInputType.text,
    this.obscure = false,
    this.sufijo,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: teclado,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icono, color: const Color(0xFF1A1A2E), size: 20),
        suffixIcon: sufijo,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00C9A7), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }
}
