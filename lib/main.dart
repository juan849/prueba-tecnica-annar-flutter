    // 1. Instanciación del cliente HTTP
    import 'package:annar_products_app/features/productos/data/datasources/producto_remote_datasource.dart';
import 'package:annar_products_app/features/productos/data/repositories/producto_repository.dart';
import 'package:annar_products_app/features/productos/domain/usecases/get_product.dart';
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
    
    final ProductoRemoteDataSource = ProductoRemoteDataSourceImpl(httpClient);

    
    final ProductoRepository = ProductoRepositoryImpl(ProductoRemoteDataSource);

    
    final getProductosUseCase = GetProduct(ProductoRepository);
    final createProductoUseCase = PostProduct(ProductoRepository);


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(
            getProductsUseCase: getProductosUseCase,
            postProductsUseCase: createProductoUseCase
            
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Gestión de Usuarios',
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



    
  
