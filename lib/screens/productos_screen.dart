import 'package:flutter/material.dart';
import 'package:frontend1/api_client.dart';

import 'pedidos_screen.dart';
import 'resenas_screen.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  final api = ApiClient();
  List productos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  Future<void> cargarProductos() async {
    try {
      final res = await api.getProductos();
      setState(() {
        productos = res;
        cargando = false;
      });
    } catch (e) {
      setState(() => cargando = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Ver pedidos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PedidosScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.rate_review),
            tooltip: 'Ver reseñas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ResenasScreen()),
              );
            },
          ),
        ],
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : productos.isEmpty
              ? const Center(child: Text('No hay productos disponibles'))
              : ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, i) {
                    final p = productos[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(Icons.shopping_bag),
                        title: Text(p['nombre'] ?? 'Sin nombre'),
                        subtitle: Text('Precio: ${p['precio'] ?? 0} Bs'),
                      ),
                    );
                  },
                ),
    );
  }
}
