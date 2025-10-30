import 'package:flutter/material.dart';
import 'package:frontend1/api_client.dart';


class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  final api = ApiClient();
  List pedidos = [];
  bool cargando = true;

  final _nombreCtrl = TextEditingController();
  final _cantidadCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarPedidos();
  }

  Future<void> cargarPedidos() async {
    try {
      final res = await api.getPedidos();
      setState(() {
        pedidos = res;
        cargando = false;
      });
    } catch (e) {
      setState(() => cargando = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> crearPedido() async {
    if (_nombreCtrl.text.isEmpty || _cantidadCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    try {
      await api.crearPedido({
        "nombre": _nombreCtrl.text,
        "cantidad": int.tryParse(_cantidadCtrl.text) ?? 1,
      });
      _nombreCtrl.clear();
      _cantidadCtrl.clear();
      cargarPedidos();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido creado correctamente')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _nombreCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Producto',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _cantidadCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: crearPedido,
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Pedido'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : pedidos.isEmpty
                    ? const Center(child: Text('No hay pedidos registrados'))
                    : ListView.builder(
                        itemCount: pedidos.length,
                        itemBuilder: (context, i) {
                          final p = pedidos[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            elevation: 3,
                            child: ListTile(
                              leading: const Icon(Icons.inventory_2),
                              title: Text(p['nombre'] ?? 'Sin nombre'),
                              subtitle: Text(
                                  'Cantidad: ${p['cantidad'] ?? 'N/D'} unidades'),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
