import 'package:flutter/material.dart';
import '../data/sale_dao.dart';
import 'add_sale_page.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});
  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final dao = SaleDao();

  Future<void> _openAdd() async {
    final changed = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddSalePage()));
    if (changed == true && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ventas')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
      future: dao.list(),
      builder: (context, snap) {
    if (!snap.hasData) return const Center(child: CircularProgressIndicator());
    final rows = snap.data!;
          if (rows.isEmpty) return const Center(child: Text('Sin ventas'));
          return ListView.separated(
            itemCount: rows.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final r = rows[i];
              return ListTile(
                title: Text(r['medicine_name'] as String),
                subtitle: Text('Cant: ${r['quantity']} • Fecha: ${r['date']}'),
                trailing: Text((r['price'] as num).toDouble().toStringAsFixed(2)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: _openAdd, child: const Icon(Icons.add)),
    );
  }
}
