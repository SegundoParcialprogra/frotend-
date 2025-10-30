import 'package:flutter/material.dart';
import 'package:frontend1/api_client.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  String? mensaje;
  bool cargando = false;

  final api = ApiClient();

  Future<void> login() async {
    setState(() {
      cargando = true;
      mensaje = null;
    });

    try {
      final res = await api.login(email.text, password.text);
      if (res != null && res['token'] != null) {
        // ✅ Si el login fue exitoso, ir a productos
        Navigator.pushReplacementNamed(context, '/productos');
      } else {
        setState(() => mensaje = 'Credenciales incorrectas');
      }
    } catch (e) {
      setState(() => mensaje = 'Error: $e');
    } finally {
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: password,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: cargando ? null : login,
              child: cargando
                  ? const CircularProgressIndicator()
                  : const Text('Entrar'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text('¿No tienes cuenta? Regístrate aquí'),
            ),
            if (mensaje != null) ...[
              const SizedBox(height: 16),
              Text(
                mensaje!,
                style: TextStyle(
                  color: mensaje!.contains('Error')
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
