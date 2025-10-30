class ProductoCreateDto {
  final String nombre;
  final double precio;
  final String descripcion;
  final int stock;

  ProductoCreateDto({
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.stock,
  });

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'precio': precio,
        'descripcion': descripcion,
        'stock': stock,
      };
}
