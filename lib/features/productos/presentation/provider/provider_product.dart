import 'package:annar_products_app/features/productos/domain/entities/producto.dart';
import 'package:annar_products_app/features/productos/domain/usecases/get_product.dart';
import 'package:annar_products_app/features/productos/domain/usecases/post_product.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  final GetProduct getProductsUseCase;
  final PostProduct postProductsUseCase;

  ProductProvider({
    required this.getProductsUseCase,
    required this.postProductsUseCase,
  });

  List<Producto> _products = [];
  
  bool _isLoading = false;
  String? _errorMessage;

  List<Producto> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getProduct() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await getProductsUseCase();
    } catch (e) {
      _errorMessage = 'Error al cargar los Productos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

 

  Future<void> addProduct({required String nombre, 
  required String codigo,required double precio, required int cantidad }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newProduct = await postProductsUseCase.call(nombre: nombre, codigo: codigo, precio: precio, cantidad: cantidad);
      /* _products.add(newProduct); */
      _isLoading = false;
      notifyListeners();
      
    } catch (e) {
      _errorMessage = 'Error al crear el usuario: $e';
      _isLoading = false;
      notifyListeners();
      
    }
  }
}
