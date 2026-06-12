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
  List productosFiltrados = [];
  final TextEditingController _searchController = TextEditingController();
  bool cargando = true;

  // Paleta de colores de la tienda
  static const Color primaryColor = Color(0xFF1A1A2E);
  static const Color accentColor = Color(0xFF00C9A7);
  static const Color cardBg = Color(0xFFF8F9FA);
  static const Color priceColor = Color.fromARGB(255, 18, 121, 104);

  @override
  void initState() {
    super.initState();
    cargarProductos();
    _searchController.addListener(_filtrar);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filtrar() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      productosFiltrados = productos.where((p) {
        final nombre = (p["nombre"] ?? "").toLowerCase();
        final marca = (p["marca"] ?? "").toLowerCase();
        return nombre.contains(query) || marca.contains(query);
      }).toList();
    });
  }

  Future<void> cargarProductos() async {
    setState(() => cargando = true);
    try {
      final data = await api.obtenerProductos();
      setState(() {
        productos = data;
        productosFiltrados = data;
        cargando = false;
      });
    } catch (e) {
      setState(() => cargando = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al cargar productos: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> eliminar(int id) async {
    final respuesta = await api.eliminarProducto(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(respuesta["message"]),
        backgroundColor: Colors.redAccent,
      ),
    );
    cargarProductos();
  }

  Future<void> agregarAlCarrito(int productoId) async {
    try {
      final respuesta = await api.agregarAlCarrito(
        usuarioId: 1,
        productoId: productoId,
        cantidad: 1,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text(respuesta["message"]),
            ],
          ),
          backgroundColor: accentColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent),
      );
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
        title: const Text(
          "Tienda de Tenis",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CarritoScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          "Nuevo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductoFormScreen()),
          );
          cargarProductos();
        },
      ),
      body: Column(
        children: [
          // Header con búsqueda
          Container(
            color: primaryColor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Buscar por nombre o marca...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(0.7),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _searchController.clear();
                          _filtrar();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Contador de resultados
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${productosFiltrados.length} producto${productosFiltrados.length != 1 ? 's' : ''}",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton.icon(
                  onPressed: cargarProductos,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text("Actualizar"),
                  style: TextButton.styleFrom(foregroundColor: accentColor),
                ),
              ],
            ),
          ),

          // Lista de productos
          Expanded(
            child: cargando
                ? const Center(
                    child: CircularProgressIndicator(color: accentColor),
                  )
                : productosFiltrados.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isNotEmpty
                              ? "Sin resultados para\n\"${_searchController.text}\""
                              : "No hay productos registrados",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: cargarProductos,
                    color: accentColor,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
                      itemCount: productosFiltrados.length,
                      itemBuilder: (context, index) {
                        final producto = productosFiltrados[index];
                        return _ProductoCard(
                          producto: producto,
                          onAgregarCarrito: () => agregarAlCarrito(
                            int.parse(producto["id"].toString()),
                          ),
                          onEditar: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductoFormScreen(producto: producto),
                              ),
                            );
                            cargarProductos();
                          },
                          onEliminar: () async {
                            final confirmar = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text("Eliminar producto"),
                                content: Text(
                                  "¿Eliminar \"${producto["nombre"]}\"? Esta acción no se puede deshacer.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Cancelar"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
                                    ),
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
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// Widget separado para la tarjeta de producto
class _ProductoCard extends StatelessWidget {
  final dynamic producto;
  final VoidCallback onAgregarCarrito;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  static const Color accentColor = Color(0xFF00C9A7);
  static const Color primaryColor = Color(0xFF1A1A2E);

  const _ProductoCard({
    required this.producto,
    required this.onAgregarCarrito,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final int stock = int.tryParse(producto["stock"].toString()) ?? 0;
    final bool hayStock = stock > 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  producto["imagen"] ?? "",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey[100],
                    child: Center(
                      child: Icon(
                        Icons.sports_soccer_outlined,
                        size: 70,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ),
                // Badge de stock
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: hayStock
                          ? accentColor.withOpacity(0.9)
                          : Colors.redAccent.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      hayStock ? "Stock: $stock" : "Agotado",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y marca
                Text(
                  producto["nombre"] ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  producto["marca"] ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    letterSpacing: 0.5,
                  ),
                ),

                // Descripción
                if ((producto["descripcion"] ?? "").isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    producto["descripcion"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],

                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Precio y botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Precio
                    Text(
                      "\$${producto["precio"]}",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),

                    // Botones de acción
                    Row(
                      children: [
                        // Carrito
                        ElevatedButton.icon(
                          onPressed: hayStock ? onAgregarCarrito : null,
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 18,
                          ),
                          label: const Text("Agregar"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),

                        const SizedBox(width: 4),

                        // Editar
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.blueGrey,
                          ),
                          tooltip: "Editar",
                          onPressed: onEditar,
                        ),

                        // Eliminar
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                          tooltip: "Eliminar",
                          onPressed: onEliminar,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
