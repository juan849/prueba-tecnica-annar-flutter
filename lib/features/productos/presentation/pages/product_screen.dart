import 'package:annar_products_app/features/productos/presentation/provider/provider_product.dart';
import 'package:annar_products_app/features/productos/presentation/widgets/add_product_dialog.dart';
import 'package:annar_products_app/features/productos/presentation/widgets/update_stock.dart';
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

  void _openAddModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) =>
          const AddProductDialog(), // Llamada limpia al widget independiente
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () => context.read<ProductProvider>().getProduct(),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage ?? ''));
          }

          if (provider.products.isEmpty) {
            return const Center(child: Text('No hay productos registrados.'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o código...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: provider.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => context
                                .read<ProductProvider>()
                                .setSearchQuery(''),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (value) {
                    context.read<ProductProvider>().setSearchQuery(value);
                  },
                ),
              ),

              Expanded(
                child: provider.filteredProducts.isEmpty
                    ? const Center(child: Text('No se encontraron productos.'))
                    : ListView.builder(
                        /* itemCount: provider.products.length, */
                        itemCount: provider.filteredProducts.length,
                        itemBuilder: (context, index) {
                          /* final product = provider.products[index]; */
                          final product = provider.filteredProducts[index];
                          print('product ${product.nombre}');
                          return Card(
                            child: ListTile(
                              leading: Text(
                                product.nombre,
                                style: TextStyle(fontSize: 10),
                              ),
                              title: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(product.codigo),
                                  Text(product.precio.toString()),
                                  Text(product.cantidad.toString()),
                                ],
                              ),

                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.edit_document,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => UpdateStockDialog(
                                      productoId: product.id,
                                      cantidadActual: product.cantidad,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddModal(context),
        child: const Icon(Icons.add_a_photo_outlined),
      ),
    );
  }
}
