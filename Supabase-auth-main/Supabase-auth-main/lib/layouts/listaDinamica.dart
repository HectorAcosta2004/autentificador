import 'package:flutter/material.dart';

class Producto {
  final String nombre;
  final double precio;

  Producto({required this.nombre, required this.precio});
}

class ListaDinam extends StatefulWidget {
  ListaDinam({super.key, required this.productos, required this.onDelete});

  final List<Producto> productos;
  final Function(int) onDelete;

  @override
  State<ListaDinam> createState() => _ListaDinamState();
}

class _ListaDinamState extends State<ListaDinam> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.productos.length,
                itemBuilder: (context, index) {
                  final producto = widget.productos[index];
                  return ListTile(
                    leading: const Icon(Icons.shopping_bag),
                    title: Text(producto.nombre),
                    subtitle: Text('Precio: \$${producto.precio}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () => widget.onDelete(index),
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
