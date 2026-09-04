import 'package:annar_products_app/features/productos/domain/entities/producto.dart';
import 'package:annar_products_app/features/productos/domain/repositories/producto_repository.dart';

class PostProduct {
  final ProductoRepository repository;

  PostProduct(this.repository);
  Future<void> call({required String nombre, 
  required String codigo,required double precio, required int cantidad }) async{
     await repository.createProducto(nombre: nombre, codigo: codigo, precio: precio, cantidad: cantidad);
  }

}