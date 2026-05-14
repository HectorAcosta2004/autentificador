import 'package:flutter/material.dart';

class Producto {
  final String nombre;
  final double precio;

  Producto({required this.nombre, required this.precio});

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      nombre: json['nombre'], // Extrae el valor de la llave 'nombre'
      precio: double.tryParse(json['precio'].toString()) ?? 0.0,
      // Extrae el valor de la llave 'precio'
    );
  }
}

class ListaDinamicaJson extends StatefulWidget {
  ListaDinamicaJson({super.key});

  @override
  State<ListaDinamicaJson> createState() => _ListaDinamicaJsonState();
}

class _ListaDinamicaJsonState extends State<ListaDinamicaJson> {
  late List<Producto> productos;

  @override
  void initState() {
    super.initState();

    // Simulamos una respuesta de una API (Lista de Mapas)
    List<Map<String, dynamic>> jsonDesdeApi = [
      {"nombre": "Monitor Gamer", "precio": "300"},
      {"nombre": "Silla Pro", "precio": "150"},
      {"nombre": "Microfóno USB", "precio": "80"},
    ];

    // Convertimos la "basura" de la API en objetos reales de nuestra clase
    productos = jsonDesdeApi.map((item) => Producto.fromJson(item)).toList();
  }

  void eliminarProducto(int index) {
    // setState le avisa a Flutter que algo cambió y debe redibujar la UI
    setState(() {
      productos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return ListTile(
                    leading: const Icon(Icons.shopping_bag),
                    title: Text(producto.nombre),
                    subtitle: Text('Precio: \$${producto.precio}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        productos.removeAt(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
