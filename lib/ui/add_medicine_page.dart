import 'package:flutter/material.dart';
import '../data/models.dart';
import '../data/medicine_dao.dart';

class AddMedicinePage extends StatefulWidget {
  final Medicine? editing;
  const AddMedicinePage({super.key, this.editing});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _stock = TextEditingController();
  final _price = TextEditingController();
  final _expiry = TextEditingController();
  final dao = MedicineDao();

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    if (e != null) {
      _name.text = e.name;
      _stock.text = e.stock.toString();
      _price.text = e.price.toString();
      _expiry.text = e.expiryDate ?? '';
    }
  }

  @override
  void dispose() {
    _name.dispose(); _stock.dispose(); _price.dispose(); _expiry.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final m = Medicine(
      id: widget.editing?.id,
      name: _name.text.trim(),
      stock: int.parse(_stock.text),
      price: double.parse(_price.text),
      expiryDate: _expiry.text.isEmpty ? null : _expiry.text.trim(),
    );
    if (widget.editing == null) {
      await dao.insert(m);
    } else {
      await dao.update(m);
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.editing == null ? 'Nuevo medicamento' : 'Editar medicamento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) => (v==null||v.trim().isEmpty) ? 'Requerido' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _stock,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stock'),
              validator: (v) => (v==null||v.isEmpty) ? 'Requerido' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _price,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Precio'),
              validator: (v) => (v==null||v.isEmpty) ? 'Requerido' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _expiry,
              decoration: const InputDecoration(labelText: 'Fecha vencimiento (YYYY-MM-DD, opcional)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _save, child: const Text('Guardar')),
          ]),
        ),
      ),
    );
  }
}
