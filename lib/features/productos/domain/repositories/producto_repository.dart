import 'package:annar_products_app/features/productos/domain/entities/producto.dart';

abstract class ProductoRepository {
  Future<List<Producto>> getProductos();
  Future<void> createProducto({required String nombre, 
  required String codigo,required double precio, required int cantidad });
}