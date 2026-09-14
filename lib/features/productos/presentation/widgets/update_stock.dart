import 'package:annar_products_app/features/productos/presentation/provider/provider_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UpdateStockDialog extends StatefulWidget {
  final int productoId;
  final int cantidadActual;

  const UpdateStockDialog({
    super.key, 
    required this.productoId, 
    required this.cantidadActual,
  });

  @override
  State<UpdateStockDialog> createState() => _UpdateStockDialogState();
}

class _UpdateStockDialogState extends State<UpdateStockDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cantidadCtrl;
  String? _errorMessage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _cantidadCtrl = TextEditingController(text: widget.cantidadActual.toString());
  }

  void _actualizar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = null;
        _isSubmitting = true;
      });

      try {
        final nuevaCantidad = int.parse(_cantidadCtrl.text);
        await context.read<ProductProvider>().updateStock(
          id: widget.productoId, 
          nuevaCantidad: nuevaCantidad,
        );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Stock actualizado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
            _errorMessage = e.toString().replaceAll('Exception: ', '');
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Actualizar Stock'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _cantidadCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Nueva Cantidad'),
              validator: (v) {
                final val = int.tryParse(v ?? '');
                if (val == null || val < 0) {
                  return 'La cantidad debe ser igual o mayor a 0';
                }
                return null;
              },
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ]
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _actualizar,
          child: _isSubmitting 
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : const Text('Guardar'),
        ),
      ],
    );
  }
}