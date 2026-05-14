import 'package:flutter/material.dart';

class FilasEemplo extends StatelessWidget {
  const FilasEemplo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      color: Color.fromARGB(253, 63, 113, 120),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [Text('Primera linea de texto'), Text('azul')],
      ),
    );
  }
}
