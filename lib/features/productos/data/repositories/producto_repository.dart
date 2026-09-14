


import 'package:annar_products_app/features/productos/data/datasources/producto_remote_datasource.dart';
import 'package:annar_products_app/features/productos/domain/entities/producto.dart';
import 'package:annar_products_app/features/productos/domain/repositories/producto_repository.dart';

class ProductoRepositoryImpl implements ProductoRepository {
  final ProductoRemoteDatasource remoteDatasource;

  ProductoRepositoryImpl(this.remoteDatasource);

  @override
  Future<Producto> createProducto({required String nombre, required String codigo, required double precio, required int cantidad}) async {
    return await remoteDatasource.createProducto(nombre: nombre, codigo: codigo, precio: precio, cantidad: cantidad);
  }

  @override
  Future<List<Producto>> getProductos() async {
    return await remoteDatasource.getProductos();
   
  }

  @override
  Future<Producto> updateStock({required int id, required int cantidad}) async {
    return await remoteDatasource.updateStock(id: id, cantidad: cantidad);
  }

  
}