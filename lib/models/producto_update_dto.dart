class ProductoUpdateDto {
  final int id;
  final String nombre;
  final double precio;
  final String descripcion;
  final int stock;

  ProductoUpdateDto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.stock,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'precio': precio,
        'descripcion': descripcion,
        'stock': stock,
      };
}
