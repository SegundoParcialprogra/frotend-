import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'https://app-251029154238.azurewebsites.net/api';

  // ---------- 🔐 LOGIN ----------
  Future<Map<String, dynamic>> login(String email, String password) async {
  await Future.delayed(Duration(seconds: 1)); // Simula espera de servidor
  if (email.isNotEmpty && password.isNotEmpty) {
    return {'token': 'fake_jwt_token', 'user': {'email': email}};
  } else {
    throw Exception('Error al iniciar sesión');
  }
}


 // ---------- 🧍 REGISTRO (Azure real) ----------
Future<void> register(String rol, String email, String password, [String? idCompania]) async {
  final url = Uri.parse('$baseUrl/Auth/register');

  final body = {
    'rol': rol,
    'email': email,
    'password': password,
    if (rol == 'empresa' && idCompania != null && idCompania.isNotEmpty)
      'idCompania': idCompania,
  };

  final res = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  if (res.statusCode != 200 && res.statusCode != 201) {
    throw Exception('Error ${res.statusCode}: ${res.body}');
  }
}



  // ---------- 🛍️ PRODUCTOS ----------
  Future<List> getProductos() async {
    final url = Uri.parse('$baseUrl/Productos');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Error al obtener productos');
    }
  }

  // ---------- 🧾 PEDIDOS ----------
  Future<void> crearPedido(Map<String, dynamic> pedido) async {
    final url = Uri.parse('$baseUrl/Pedidos');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pedido),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Error al crear pedido: ${res.body}');
    }
  }

  Future<List> getPedidos() async {
    final url = Uri.parse('$baseUrl/Pedidos');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Error al obtener pedidos');
    }
  }

  // ---------- 💬 RESEÑAS ----------
  Future<List> getResenas() async {
    final url = Uri.parse('$baseUrl/Resenas');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Error al obtener reseñas');
    }
  }

  Future<void> crearResena(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/Resenas');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Error al crear reseña: ${res.body}');
    }
  }
}
