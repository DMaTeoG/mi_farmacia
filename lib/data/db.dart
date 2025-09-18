import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDB {
  AppDB._();
  static final AppDB instance = AppDB._();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mifarmacia.db');
    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE medicines(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            stock INTEGER NOT NULL DEFAULT 0,
            price REAL NOT NULL DEFAULT 0,
            expiry_date TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE sales(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            medicine_id INTEGER NOT NULL,
            quantity INTEGER NOT NULL CHECK(quantity > 0),
            date TEXT NOT NULL,
            FOREIGN KEY(medicine_id) REFERENCES medicines(id) ON DELETE RESTRICT
          )
        ''');
        // Datos de ejemplo opcionales
        await db.insert('medicines', {
          'name': 'Paracetamol 500mg', 'stock': 50, 'price': 1500.0, 'expiry_date': '2026-12-31'
        });
        await db.insert('medicines', {
          'name': 'Ibuprofeno 400mg', 'stock': 30, 'price': 2200.0, 'expiry_date': '2026-06-30'
        });
      },
    );
  }
}
