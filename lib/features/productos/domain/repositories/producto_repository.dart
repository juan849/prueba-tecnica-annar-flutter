import 'package:annar_products_app/features/productos/domain/entities/producto.dart';

abstract class ProductoRepository {
  Future<List<Producto>> getProductos();
  Future<Producto> createProducto({required String nombre, 
  required String codigo,required double precio, required int cantidad });
  Future<Producto> updateStock({required int id, required int cantidad});
}