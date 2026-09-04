import 'package:annar_products_app/features/productos/domain/entities/producto.dart';
import 'package:annar_products_app/features/productos/domain/repositories/producto_repository.dart';

class GetProduct {
  final ProductoRepository repository;

  GetProduct(this.repository);
  Future<List<Producto>> call() async{
    return await repository.getProductos();

  }

}