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
      final bool canCheckBiometrics = await auth.canCheckBiometrics;
      final bool isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        _showMsg("Biometría no soportada en este dispositivo", Colors.red);
        return;
      }

      // CORRECCIÓN FINAL:
      // Si recibes error en 'AuthenticationOptions', usa esta sintaxis
      // que es la más estable en las versiones actuales.
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Autentícate para continuar',
      );
      if (didAuthenticate) {
        // Verificar si Supabase ya tiene una sesión persistida
        final session = Supabase.instance.client.auth.currentSession;

        if (session != null) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          }
        } else {
          _showMsg(
            "Inicia sesión con contraseña una vez para activar la huella",
            Colors.orange,
          );
        }
      }
    } catch (e) {
      _showMsg("Error de biometría: $e", Colors.red);
    }
  }

  // -------- LOGIN MANUAL --------
  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMsg("Por favor, llena todos los campos", Colors.orange);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
        );
      }
    } on AuthException catch (error) {
      _showMsg(error.message, Colors.red);
    } catch (e) {
      _showMsg("Error inesperado", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Autenticación Segura")),
      body: SingleChildScrollView(
        // Evita errores de overflow con el teclado
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.fingerprint, size: 100, color: Colors.blue),
            const SizedBox(height: 20),

            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                ),
                onPressed: _authenticateBiometric,
                icon: const Icon(Icons.lock_open),
                label: const Text("ENTRAR CON BIOMETRÍA"),
              ),

            const SizedBox(height: 40),
            const Divider(),
            const Text("O usa tu cuenta"),
            const SizedBox(height: 20),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Correo electrónico",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _isLoading ? null : _login,
              child: const Text("INICIAR SESIÓN"),
            ),
          ],
        ),
      ),
    );
  }
}
