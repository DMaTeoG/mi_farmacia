import 'package:flutter/material.dart';
import '../data/medicine_dao.dart';
import '../data/models.dart';
import 'add_medicine_page.dart';

class MedicinesPage extends StatefulWidget {
  const MedicinesPage({super.key});
  @override
  State<MedicinesPage> createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  final dao = MedicineDao();

  Future<void> _openAdd([Medicine? m]) async {
    final changed = await Navigator.push(context,
      MaterialPageRoute(builder: (_) => AddMedicinePage(editing: m)));
    if (changed == true && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario')),
      body: FutureBuilder<List<Medicine>>(
        future: dao.getAll(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = snap.data!;
          if (list.isEmpty) return const Center(child: Text('Sin medicamentos'));
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final m = list[i];
              return ListTile(
                title: Text(m.name),
                subtitle: Text('Stock: ${m.stock} • Precio: ${m.price.toStringAsFixed(2)}'),
                trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () => _openAdd(m)),
                onLongPress: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Eliminar'),
                      content: Text('¿Eliminar ${m.name}?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
                      ],
                    ),
                  );
                  if (ok == true) {
                    await dao.delete(m.id!);
                    if (mounted) setState(() {});
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
