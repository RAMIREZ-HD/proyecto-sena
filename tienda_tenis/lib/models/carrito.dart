class Carrito {
  static List<Map<String, dynamic>> items = [];

  static void agregar(Map<String, dynamic> producto) {
    int index = items.indexWhere(
      (item) => item["id"].toString() == producto["id"].toString(),
    );

    if (index >= 0) {
      items[index]["cantidad"] = (items[index]["cantidad"] ?? 1) + 1;
    } else {
      producto["cantidad"] = 1;
      items.add(producto);
    }
  }

  static void aumentar(int index) {
    items[index]["cantidad"]++;
  }

  static void disminuir(int index) {
    if (items[index]["cantidad"] > 1) {
      items[index]["cantidad"]--;
    } else {
      items.removeAt(index);
    }
  }

  static void eliminar(int index) {
    items.removeAt(index);
  }

  static double total() {
    double suma = 0;

    for (var item in items) {
      double precio = double.parse(item["precio"].toString());

      int cantidad = item["cantidad"] ?? 1;

      suma += precio * cantidad;
    }

    return suma;
  }
}
