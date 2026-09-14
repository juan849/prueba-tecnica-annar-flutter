import 'dart:convert';

import 'package:annar_products_app/core/constant/api_constant.dart';
import 'package:annar_products_app/features/productos/data/models/producto_model.dart';

import 'package:http/http.dart' as http;

abstract class ProductoRemoteDatasource {
  Future<List<ProductoModel>> getProductos();
  Future<ProductoModel> createProducto({
    required String nombre, 
    required String codigo,
    required double precio, required int cantidad });
  Future<ProductoModel> updateStock({required int id, required int cantidad});

}

class ProductoRemoteDataSourceImpl implements ProductoRemoteDatasource {

  final http.Client client;

  ProductoRemoteDataSourceImpl(this.client);

  @override
  Future<ProductoModel> createProducto({required String nombre,
   required String codigo, required double precio, required int cantidad}) async {
    
    
    final response = await client.post(Uri.parse(ApiConstant.endPoint),
      headers: {
      'Content-Type': 'application/json',
      },
      body: jsonEncode({
          "nombre": nombre,
          "codigo": codigo,
          "precio": precio,
          "cantidad": cantidad})
      );

      if(response.statusCode == 200 || response.statusCode == 201 ){
         return ProductoModel.fromJson(jsonDecode(response.body));
      }else {
        final errorBody = response.body;

        String errorMessage;
        try {
          final decoded = jsonDecode(errorBody);
          if (decoded is Map<String, dynamic> && decoded.containsKey('title')) {
            errorMessage = decoded['title'] ?? 'Error al crear el producto';
          } else {
            errorMessage = decoded.toString();
          }
          
        } catch (_) {
            errorMessage = (errorBody.isNotEmpty) 
            ? errorBody : 'Error ${response.statusCode} al crear el producto';
        }
        print('Error creando el producto: ${response.statusCode} - ${response.body}');
        throw Exception(errorMessage);
      }

   
  }

  @override
  Future<List<ProductoModel>> getProductos() async {
    try {
      final response = await client.get(
        Uri.parse(ApiConstant.endPoint),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> bodyList = jsonDecode(response.body);
        return bodyList.map((json) => ProductoModel.fromJson(json)).toList();
      } else {
        final errorBody = response.body;
        String errorMessage;

        try {
          final decoded = jsonDecode(errorBody);
          if (decoded is Map<String, dynamic> && decoded.containsKey('title')) {
            errorMessage = decoded['title'] ?? 'Error al obtener productos';
          } else {
            errorMessage = decoded.toString();
          }
        } catch (_) {
          errorMessage = errorBody.isNotEmpty 
              ? errorBody 
              : 'Error ${response.statusCode} al obtener los productos';
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error al obtener los productos: ${e.toString()}');
      if (e is Exception && !e.toString().contains('ClientException') && 
      !e.toString().contains('SocketException')) {
        rethrow;
      }
      
      throw Exception('No se pudo conectar con el servidor. Verifica que el backend esté activo.');
    }
  }


// Implementation
@override
Future<ProductoModel> updateStock({required int id, required int cantidad}) async {
  try {

    final uri = Uri.parse('${ApiConstant.endPoint}/$id/stock').replace(
      queryParameters: {'cantidad': cantidad.toString()},
    );

    final response = await client.patch(
      uri,headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return ProductoModel.fromJson(jsonDecode(response.body));
    } else {
      final errorBody = response.body;
      String errorMessage;

      try {
        final decoded = jsonDecode(errorBody);
        if (decoded is Map<String, dynamic> && decoded.containsKey('title')) {
          errorMessage = decoded['title'] ?? 'Error al actualizar stock';
        } else {
          errorMessage = decoded.toString();
        }
      } catch (_) {
        errorMessage = errorBody.isNotEmpty 
            ? errorBody 
            : 'Error ${response.statusCode} al actualizar stock';
      }

      throw Exception(errorMessage);
    }
  } catch (e) {
    if (e is Exception) rethrow;
    throw Exception('Error de conexión al actualizar stock');
  }
}

} 