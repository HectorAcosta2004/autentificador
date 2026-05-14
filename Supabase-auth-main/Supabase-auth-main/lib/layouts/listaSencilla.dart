import 'package:flutter/material.dart';

class Listasencilla extends StatelessWidget {
  const Listasencilla({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Text('Item $index');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
