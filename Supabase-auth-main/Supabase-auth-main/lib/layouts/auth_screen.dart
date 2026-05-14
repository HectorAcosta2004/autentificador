import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart'; // El único paquete real y verificado
import 'package:flutter_basico/layouts/gestor_tareas.dart'; // Pantalla de destino tras login exitoso

class PasskeyAuthScreen extends StatefulWidget {
  const PasskeyAuthScreen({super.key});
  @override
  State<PasskeyAuthScreen> createState() => _PasskeyAuthScreenState();
}

class _PasskeyAuthScreenState extends State<PasskeyAuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  bool _isLoading = false;

  // --- 1. FUNCIÓN DE BIOMETRÍA (PASSKEY SIMULADO) ---
  Future<void> _authenticateBiometric() async {
    try {
      // 1. Verificación básica de soporte
      final bool canCheckBiometrics = await auth.canCheckBiometrics;
      final bool isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        _showMsg(
          "Biometría no soportada en este navegador/dispositivo",
          Colors.red,
        );
        return;
      }

      // 2. Llamada simplificada (Compatible con Chrome y Android)
      // Eliminamos 'options' y 'AuthenticationOptions' que dan error en Web
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Autentícate para continuar',
      );

      if (didAuthenticate) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
        );
      }
    } catch (e) {
      _showMsg("Error de biometría: $e", Colors.red);
      print(e);
    }
  }

  // --- 2. LOGIN TRADICIONAL (FIREBASE) ---
  Future<void> _loginStandard() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMsg(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Biometría Académica 2026")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.fingerprint, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _authenticateBiometric,
              icon: const Icon(Icons.lock_open),
              label: const Text("ENTRAR CON HUELLA"),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: _loginStandard,
              child: const Text("Login con Firebase"),
            ),
          ],
        ),
      ),
    );
  }
}
