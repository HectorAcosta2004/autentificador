import 'package:flutter/material.dart';
import 'package:flutter_basico/layouts/inicio.dart';

class LoginEjemplo extends StatelessWidget {
  LoginEjemplo({super.key});
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(image: AssetImage('image/pajaro.jpg'), width: 200, height: 200),
        SizedBox(height: 20),
        TextField(
          controller: username,
          decoration: InputDecoration(
            labelText: 'Usuario',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: password,
          obscureText: true,
          style: TextStyle(
            fontSize: 25,
            color: Colors.green,
            fontFamily: 'Arial',
          ),
          decoration: InputDecoration(
            labelText: 'Contraseña',
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
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            String user = username.text;
            String pass = password.text;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Inicio(username: user)),
            );
          },
          child: Text('Iniciar Sesion'),
        ),
      ],
    );
  }
}
