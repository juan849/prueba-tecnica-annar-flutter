import 'package:annar_products_app/features/productos/domain/entities/producto.dart';
import 'package:annar_products_app/features/productos/domain/usecases/get_product.dart';
import 'package:annar_products_app/features/productos/domain/usecases/patch_stock.dart';
import 'package:annar_products_app/features/productos/domain/usecases/post_product.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  final GetProduct getProductsUseCase;
  final PostProduct postProductsUseCase;
  final PatchStock patchStockUseCase;

  ProductProvider({
    required this.getProductsUseCase,
    required this.postProductsUseCase,
    required this.patchStockUseCase,
  });

  List<Producto> _products = [];

  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<Producto> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<Producto> get filteredProducts {
    if (_searchQuery.trim().isEmpty) {
      return _products;
    } 
      final query = _searchQuery.toLowerCase();
      return _products.where((p) {
        final findNombre = p.nombre.toLowerCase().contains(query);
        final findCodigo = p.codigo.toLowerCase().contains(query);
        return findNombre || findCodigo;
      }).toList();
  }

  void setSearchQuery(String query){
    _searchQuery = query;
    notifyListeners();
  }




  Future<void> getProduct() async {
    if (!_isLoading) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      _products = await getProductsUseCase();
    } catch (e) {
      print('Error al cargar los Productos: ${e.toString()}');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct({
    required String nombre,
    required String codigo,
    required double precio,
    required int cantidad,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await postProductsUseCase.call(
        nombre: nombre,
        codigo: codigo,
        precio: precio,
        cantidad: cantidad,
      );

      await getProduct();
    } catch (e) {
      ///_errorMessage = 'Error al crear el producto: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      //?rethrow: Relanza la excepción para que pueda ser manejada en la UI si es necesario
      rethrow;
    }
  }

  Future<void> updateStock({
    required int id,
    required int nuevaCantidad,
  }) async {
    try {
      final updatedProduct = await patchStockUseCase.call(
        id: id,
        cantidad: nuevaCantidad,
      );

      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
    } catch (e) {
      rethrow; // Propaga el error para capturarlo en la UI
    }
  }






}
