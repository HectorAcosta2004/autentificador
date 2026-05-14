import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_basico/layouts/gestor_tareas.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final LocalAuthentication auth = LocalAuthentication();

  bool _isLoading = false;

  // -------- BIOMETRÍA --------
  Future<void> _authenticateBiometric() async {
    try {
      // 1. Verificar soporte hardware
      final bool canCheckBiometrics = await auth.canCheckBiometrics;
      final bool isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        _showMsg("Biometría no soportada", Colors.red);
        return;
      }

      // 2. Lanzar el sensor
      final bool didAuthenticate = await auth.authenticate(
        localizedReason:
            'Por favor, escanea tu huella para acceder a tus tareas',
        options: const AuthenticationOptions(
          stickyAuth:
              true, // Mantiene la autenticación si el usuario sale de la app un segundo
          biometricOnly: true,
        ),
      );

      if (didAuthenticate) {
        // 3. ¡PASO CLAVE! Verificar si Supabase tiene una sesión válida guardada
        final session = Supabase.instance.client.auth.currentSession;

        if (session != null) {
          // Si hay sesión, vamos al Gestor de Tareas
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          }
        } else {
          // Si no hay sesión (primera vez o cerró sesión), obligar a usar Email/Password
          _showMsg(
            "Inicia sesión con contraseña al menos una vez para vincular tu huella",
            Colors.orange,
          );
        }
      }
    } catch (e) {
      _showMsg("Error: $e", Colors.red);
    }
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    } catch (e) {
      _showMsg("Error al iniciar sesión", Colors.red);
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
        padding: const EdgeInsets.all(24),

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
              onPressed: _login,
              child: const Text("Login con Supabase"),
            ),
          ],
        ),
      ),
    );
  }
}
