import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/provider_product.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _codigoCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final _cantidadCtrl = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _codigoCtrl.dispose();
    _precioCtrl.dispose();
    _cantidadCtrl.dispose();
    super.dispose();
  }

  void _guardarProducto() async {
    if (_formKey.currentState!.validate()) {
      try {
        await context.read<ProductProvider>().addProduct(
          nombre: _nombreCtrl.text,
          codigo: _codigoCtrl.text,
          precio: double.tryParse(_precioCtrl.text) ?? 0.0,
          cantidad: int.tryParse(_cantidadCtrl.text) ?? 0,
        );
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Producto creado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = e.toString().replaceAll('Exception: ', '');
          });
        }
        /*         final cleanError = e.toString().replaceAll('Exception: ', '');
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(cleanError),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        ); */
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo Producto'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                maxLength: 100,
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'El nombre es obligatorio';
                  if (v.length > 100) return 'Máximo 100 caracteres';
                  return null;
                },
              ),
              TextFormField(
                controller: _codigoCtrl,
                decoration: const InputDecoration(labelText: 'Código'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'El código es obligatorio';
                  if (v.length > 50) return 'Máximo 50 caracteres';
                  return null;
                },
              ),
              TextFormField(
                controller: _precioCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Precio'),
                validator: (v) {
                  final val = double.tryParse(v ?? '');
                  if (val == null || val <= 0)
                    return 'Ingrese un precio mayor a 0';
                  return null;
                },
              ),
              TextFormField(
                controller: _cantidadCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                validator: (v) {
                  final val = int.tryParse(v ?? '');
                  if (val == null || val < 0) {
                    return 'La cantidad debe ser un entero igual o mayor a 0';
                  }
                  return null;
                },
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardarProducto,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
