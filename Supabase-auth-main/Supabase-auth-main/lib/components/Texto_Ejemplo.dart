import 'package:flutter/material.dart';

class TextoEjemplo extends StatelessWidget {
  const TextoEjemplo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Este es un ejemplo de texto.',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text(
          'Otro texto de ejemplo con un tamaño de fuente mas pequeño.',
          style: TextStyle(fontSize: 25, color: Colors.blue),
        ),
      ],
    );
  }
}
