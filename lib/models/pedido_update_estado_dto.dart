class PedidoUpdateEstadoDto {
  final int idPedido;
  final String nuevoEstado;

  PedidoUpdateEstadoDto({
    required this.idPedido,
    required this.nuevoEstado,
  });

  Map<String, dynamic> toJson() => {
        'idPedido': idPedido,
        'nuevoEstado': nuevoEstado,
      };
}
