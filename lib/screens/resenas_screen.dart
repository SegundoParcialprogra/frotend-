import 'package:flutter/material.dart';
import 'package:frontend1/api_client.dart';


class ResenasScreen extends StatefulWidget {
  const ResenasScreen({super.key});

  @override
  State<ResenasScreen> createState() => _ResenasScreenState();
}

class _ResenasScreenState extends State<ResenasScreen> {
  final api = ApiClient();
  final comentarioCtrl = TextEditingController();
  final calificacionCtrl = TextEditingController();
  bool cargando = true;
  List resenas = [];

  @override
  void initState() {
    super.initState();
    cargarResenas();
  }

  Future<void> cargarResenas() async {
    try {
      final data = await api.getResenas();
      setState(() {
        resenas = data;
        cargando = false;
      });
    } catch (e) {
      setState(() => cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar reseñas: $e')),
      );
    }
  }

  Future<void> crearResena() async {
    final comentario = comentarioCtrl.text.trim();
    final calificacion = calificacionCtrl.text.trim();

    if (comentario.isEmpty || calificacion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    try {
      await api.crearResena({
        'comentario': comentario,
        'calificacion': int.parse(calificacion),
      });

      comentarioCtrl.clear();
      calificacionCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reseña creada con éxito')),
      );
      cargarResenas(); // 🔄 refrescar lista
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reseñas'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: comentarioCtrl,
              decoration: const InputDecoration(labelText: 'Comentario'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: calificacionCtrl,
              decoration: const InputDecoration(labelText: 'Calificación (1-5)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: crearResena,
              child: const Text('Enviar Reseña'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: cargando
                  ? const Center(child: CircularProgressIndicator())
                  : resenas.isEmpty
                      ? const Center(child: Text('No hay reseñas disponibles'))
                      : ListView.builder(
                          itemCount: resenas.length,
                          itemBuilder: (context, i) {
                            final r = resenas[i];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              elevation: 2,
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(r['comentario'] ?? 'Sin comentario'),
                                subtitle: Text('⭐ ${r['calificacion'] ?? '-'}'),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
