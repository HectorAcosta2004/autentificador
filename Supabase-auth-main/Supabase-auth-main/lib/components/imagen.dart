import 'package:flutter/material.dart';

class ImagenEjemplo extends StatelessWidget {
  const ImagenEjemplo({super.key});


 @override
  Widget build(BuildContext context) {
    return Image(image: NetworkImage('https://x.com/timsneath/status/1487144742634680320'))
  }
}