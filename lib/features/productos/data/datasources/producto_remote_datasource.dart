import 'dart:convert';

import 'package:annar_products_app/core/constant/api_constant.dart';
import 'package:annar_products_app/features/productos/data/models/producto_model.dart';

import 'package:http/http.dart' as http;

abstract class ProductoRemoteDatasource {
    Future<List<ProductoModel>> getProductos();
  Future<void> createProducto({
    required String nombre, 
    required String codigo,
    required double precio, required int cantidad });

}

class ProductoRemoteDataSourceImpl implements ProductoRemoteDatasource {

  final http.Client client;

  ProductoRemoteDataSourceImpl(this.client);

  @override
  Future<void> createProducto({required String nombre, required String codigo, required double precio, required int cantidad}) async {
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

      if(response.statusCode == 200){
         ProductoModel.fromJson(jsonDecode(response.body));
      }else {
        throw Exception('Error creando los usuarios');
      }

   
  }

  @override
  Future<List<ProductoModel>> getProductos() async {
    final response = await client.get(Uri.parse(ApiConstant.endPoint),
      headers: {
      'Content-Type': 'application/json',
      });
    
    if(response.statusCode == 200){
      final List<dynamic> bodyList = jsonDecode(response.body);
      
      return bodyList.map((json) => ProductoModel.fromJson(json)).toList();
    }else {
        throw Exception('Error creando los usuarios');
      }


  }

} 