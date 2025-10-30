class ResenaCreateDto {
  final int idProducto;
  final int idUsuario;
  final int calificacion;
  final String comentario;

  ResenaCreateDto({
    required this.idProducto,
    required this.idUsuario,
    required this.calificacion,
    required this.comentario,
  });

  Map<String, dynamic> toJson() => {
        'idProducto': idProducto,
        'idUsuario': idUsuario,
        'calificacion': calificacion,
        'comentario': comentario,
      };
}
