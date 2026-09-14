    // 1. Instanciación del cliente HTTP
    import 'package:annar_products_app/features/productos/data/datasources/producto_remote_datasource.dart';
import 'package:annar_products_app/features/productos/data/repositories/producto_repository.dart';
import 'package:annar_products_app/features/productos/domain/usecases/get_product.dart';
import 'package:annar_products_app/features/productos/domain/usecases/patch_stock.dart';
import 'package:annar_products_app/features/productos/domain/usecases/post_product.dart';
import 'package:annar_products_app/features/productos/presentation/pages/product_screen.dart';
import 'package:annar_products_app/features/productos/presentation/provider/provider_product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

final httpClient = http.Client();



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    final productoRemoteDataSource = ProductoRemoteDataSourceImpl(httpClient);

    
    final productoRepository = ProductoRepositoryImpl(productoRemoteDataSource);

    
    final getProductosUseCase = GetProduct(productoRepository);
    final createProductoUseCase = PostProduct(productoRepository);
    final patchStockUseCase = PatchStock(productoRepository);


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(
            getProductsUseCase: getProductosUseCase,
            postProductsUseCase: createProductoUseCase, patchStockUseCase: patchStockUseCase
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Gestión de Productos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: ProductScreen(),
      ),
    );
    
  }
}



    
  
