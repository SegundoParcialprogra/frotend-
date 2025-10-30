class PedidoCreateDto {
  final int idUsuario;
  final List<int> productosIds;

  PedidoCreateDto({
    required this.idUsuario,
    required this.productosIds,
  });

  Map<String, dynamic> toJson() => {
        'idUsuario': idUsuario,
        'productosIds': productosIds,
      };
}
