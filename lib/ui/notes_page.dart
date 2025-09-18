import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/hive_service.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _noteCtrl = TextEditingController();

  @override
  void dispose() { _noteCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final settings = HiveService.settingsBox;
    final notes = HiveService.notesBox;

    return Scaffold(
      appBar: AppBar(title: const Text('Notas & Configuración')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tema oscuro
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tema oscuro'),
                ValueListenableBuilder(
                  valueListenable: settings.listenable(keys: const ['darkMode']),
                  builder: (_, __, ___) {
                    final dark = settings.get('darkMode', defaultValue: false) as bool;
                    return Switch(
                      value: dark,
                      onChanged: (v) => settings.put('darkMode', v),
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            const Text('Nueva nota'),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _noteCtrl,
                  decoration: const InputDecoration(hintText: 'Ej: Revisar inventario lunes'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  final text = _noteCtrl.text.trim();
                  if (text.isEmpty) return;
                  await HiveService.addNote(text);
                  _noteCtrl.clear();
                },
              )
            ]),
            const SizedBox(height: 12),
            const Text('Notas guardadas'),
            const SizedBox(height: 8),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: notes.listenable(),
                builder: (_, __, ___) {
                  if (notes.isEmpty) return const Text('Sin notas');
                  return ListView.separated(
                    itemCount: notes.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final text = notes.getAt(i)!;
                      return ListTile(
                        title: Text(text),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => HiveService.deleteNoteAt(i),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
