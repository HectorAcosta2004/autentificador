import 'package:flutter/material.dart';
//import 'package:flutter_basico/layouts/cuadros.dart';
//import 'package:flutter_basico/components/Texto_Ejemplo.dart';
//import 'package:flutter_basico/layouts/Columnas_Ejemplo.dart';
//import 'package:flutter_basico/layouts/Filas_Eemplo.dart';
//import 'package:flutter_basico/components/CampoTexto.dart';
//import 'package:flutter_basico/components/imagen.dart';
//import 'package:flutter_basico/layouts/pantallaLogin.dart';
//import 'layouts/auth_screen.dart';
import 'layouts/supabase_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
    url: 'https://edbjqkekzaimfrmdrulm.supabase.co',
    anonKey: 'sb_publishable_Q9s_rzciTf9Q5ReywolQAg_VLi48-ot',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}
