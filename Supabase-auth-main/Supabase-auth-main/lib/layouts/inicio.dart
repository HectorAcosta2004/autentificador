import 'package:flutter/material.dart';
import 'package:flutter_basico/layouts/actualizar_ejemplo.dart';

class Inicio extends StatelessWidget {
  Inicio({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola Bienvenido ala pantalla de incio $username'),
      ),
      body: Center(child: MyApp()),
    );
  }
}
