import 'package:flutter/material.dart';

class ColumnasEjemplo extends StatelessWidget {
  const ColumnasEjemplo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 40, left: 10, right: 10),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color.fromARGB(253, 63, 113, 120),
      ),
    );
  }
}
