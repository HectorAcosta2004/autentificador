import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  const CampoTexto({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Nombre',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          style: TextStyle(
            fontSize: 25,
            color: Colors.green,
            fontFamily: 'Arial',
          ),
          decoration: InputDecoration(
            labelText: 'Correo Electronico',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
