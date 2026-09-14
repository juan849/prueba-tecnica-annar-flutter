import 'package:annar_products_app/features/productos/domain/entities/producto.dart';
import 'package:annar_products_app/features/productos/domain/repositories/producto_repository.dart';

class PatchStock {
  final ProductoRepository repository;

  PatchStock(this.repository);

  Future<Producto> call({required int id, required int cantidad}) {
    return repository.updateStock(id: id, cantidad: cantidad);
  }
}