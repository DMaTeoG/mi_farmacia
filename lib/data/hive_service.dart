import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const settingsBoxName = 'settings';
  static const notesBoxName = 'notes';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(settingsBoxName);
    await Hive.openBox<String>(notesBoxName);
  }

  // Settings
  static Box get settingsBox => Hive.box(settingsBoxName);
  static bool get darkMode => settingsBox.get('darkMode', defaultValue: false) as bool;
  static set darkMode(bool v) => settingsBox.put('darkMode', v);

  // Notes (solo strings)
  static Box<String> get notesBox => Hive.box<String>(notesBoxName);
  static Future<int> addNote(String text) => notesBox.add(text);
  static Future<void> deleteNoteAt(int index) => notesBox.deleteAt(index);
}
