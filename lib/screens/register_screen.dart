import 'package:flutter/material.dart';
import 'package:frontend1/api_client.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final idCompaniaCtrl = TextEditingController();
  String rol = 'usuario';
  bool loading = false;

  final api = ApiClient();

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      await api.register(
        rol,
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
        rol == 'empresa' ? idCompaniaCtrl.text.trim() : null,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso ✅')),
      );

      Navigator.pop(context); // vuelve a login
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Icon(Icons.person_add, size: 80, color: Colors.blueGrey),
              const SizedBox(height: 10),
              const Center(child: Text('Crea tu cuenta', style: TextStyle(fontSize: 18))),
              const SizedBox(height: 30),

              // Rol
              DropdownButtonFormField<String>(
                value: rol,
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'usuario', child: Text('Usuario')),
                  DropdownMenuItem(value: 'empresa', child: Text('Empresa')),
                ],
                onChanged: (v) => setState(() => rol = v!),
              ),
              const SizedBox(height: 15),

              // Email
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v != null && v.contains('@') ? null : 'Correo inválido',
              ),
              const SizedBox(height: 15),

              // Contraseña
              TextFormField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v != null && v.length >= 4 ? null : 'Mínimo 4 caracteres',
              ),
              const SizedBox(height: 15),

              // ID de compañía (solo si es empresa)
              if (rol == 'empresa')
                TextFormField(
                  controller: idCompaniaCtrl,
                  decoration: const InputDecoration(
                    labelText: 'ID de Compañía',
                    prefixIcon: Icon(Icons.business),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => rol == 'empresa' && (v == null || v.isEmpty)
                      ? 'Ingrese ID de Compañía'
                      : null,
                ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: loading ? null : _registrar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Registrarse', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 15),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    '¿Ya tienes cuenta? Inicia sesión',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
