import 'package:annar_products_app/features/productos/domain/entities/producto.dart';

class ProductoModel extends Producto {
  ProductoModel(
    {required super.id, 
    required super.nombre, 
    required super.codigo,
    required super.precio, 
    required super.cantidad});

    factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id: json["id"] ?? 0,
        nombre: json["nombre"] ?? '',
        codigo: json["codigo"] ?? '',
        precio: json["precio"],
        cantidad: json["cantidad"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "codigo": codigo,
        "precio": precio,
        "cantidad": cantidad,
    };
}
