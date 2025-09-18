import 'db.dart';
import 'models.dart';

class MedicineDao {
  Future<List<Medicine>> getAll() async {
    final db = await AppDB.instance.database;
    final rows = await db.query('medicines', orderBy: 'name ASC');
    return rows.map((e) => Medicine.fromMap(e)).toList();
  }

  Future<int> insert(Medicine m) async {
    final db = await AppDB.instance.database;
    return db.insert('medicines', m.toMap());
  }

  Future<int> update(Medicine m) async {
    final db = await AppDB.instance.database;
    return db.update('medicines', m.toMap(), where: 'id=?', whereArgs: [m.id]);
  }

  Future<int> delete(int id) async {
    final db = await AppDB.instance.database;
    return db.delete('medicines', where: 'id=?', whereArgs: [id]);
  }

  Future<Medicine?> findById(int id) async {
    final db = await AppDB.instance.database;
    final rows = await db.query('medicines', where: 'id=?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return Medicine.fromMap(rows.first);
  }
}
