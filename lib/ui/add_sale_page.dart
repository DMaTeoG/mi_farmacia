import 'package:flutter/material.dart';
import '../data/medicine_dao.dart';
import '../data/sale_dao.dart';
import '../data/models.dart';

class AddSalePage extends StatefulWidget {
  const AddSalePage({super.key});
  @override
  State<AddSalePage> createState() => _AddSalePageState();
}

class _AddSalePageState extends State<AddSalePage> {
  final _formKey = GlobalKey<FormState>();
  final _qtyCtrl = TextEditingController(text: '1');
  final medDao = MedicineDao();
  final saleDao = SaleDao();

  Medicine? _selected;
  List<Medicine> _meds = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await medDao.getAll();
    setState(() {
      _meds = list;
      if (list.isNotEmpty) _selected = list.first;
    });
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selected == null) return;
    final qty = int.parse(_qtyCtrl.text);
    try {
      await saleDao.insertSale(Sale(
        medicineId: _selected!.id!,
        quantity: qty,
        date: DateTime.now(),
      ));
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva venta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _meds.isEmpty
            ? const Center(child: Text('Agrega medicamentos primero'))
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<Medicine>(
                      initialValue: _selected,
                      items: _meds
                          .map((m) => DropdownMenuItem(
                                value: m,
                                child: Text('${m.name} (stock: ${m.stock})'),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _selected = v),
                      decoration:
                          const InputDecoration(labelText: 'Medicamento'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _qtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Cantidad'),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: _save, child: const Text('Registrar')),
                  ],
                ),
              ),
      ),
    );
  }
}
