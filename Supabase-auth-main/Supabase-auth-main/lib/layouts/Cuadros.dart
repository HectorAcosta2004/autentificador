import 'package:flutter/material.dart';

class Cuadros extends StatelessWidget {
  const Cuadros({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color.fromARGB(253, 63, 113, 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                color: Colors.red,
                child: Center(
                  child: Text('Rojo', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: Center(
                  child: Text('Azul', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                color: Colors.green,
                child: Center(
                  child: Text('Verde', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 100,
                height: 100,
                color: Colors.green,
                child: Center(
                  child: Text('Verde', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 100,
                height: 100,
                color: Colors.green,
                child: Center(
                  child: Text('Verde', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                color: Colors.black,
                child: Center(
                  child: Text('Negro', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
