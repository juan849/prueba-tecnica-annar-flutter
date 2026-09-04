import 'package:annar_products_app/features/productos/presentation/provider/provider_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().getProduct();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('listado Productos'),),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(),);
          }
          if(provider.errorMessage != null){
            return Center(
              child: Text(provider.errorMessage ?? ''),
            );
          }
          
          return ListView.builder(
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              final product = provider.products[index];
              print('product $product');
              return Card(
                child: ListTile(
                  leading: Text(product.nombre, style: TextStyle(fontSize: 10),),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(product.codigo),
                      Text(product.precio.toString()),
                      Text(product.cantidad.toString()),

                    ],
                  ),

                ),
              );
            },
            
            );
          
        },
        
        ),
    );
  }
}