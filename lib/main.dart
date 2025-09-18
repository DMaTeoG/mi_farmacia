import 'package:flutter/material.dart';
import 'data/hive_service.dart';
import 'ui/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final settings = HiveService.settingsBox;
    return ValueListenableBuilder(
      valueListenable: settings.listenable(keys: const ['darkMode']),
      builder: (_, __, ___) {
        final dark = settings.get('darkMode', defaultValue: false) as bool;
        return MaterialApp(
          title: 'MiFarmacia',
          theme: ThemeData(useMaterial3: true, brightness: dark ? Brightness.dark : Brightness.light),
          home: const HomePage(),
        );
      },
    );
  }
}
