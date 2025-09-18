import 'db.dart';
import 'models.dart';

class SaleDao {
  /// Inserta una venta y descuenta stock en una transacción.
  Future<void> insertSale(Sale s) async {
    final db = await AppDB.instance.database;
    await db.transaction((txn) async {
      // Leer stock actual
      final medRows = await txn.query('medicines', where: 'id=?', whereArgs: [s.medicineId], limit: 1);
      if (medRows.isEmpty) {
        throw Exception('Medicamento no encontrado');
      }
      final stock = medRows.first['stock'] as int;
      if (stock < s.quantity) {
        throw Exception('Stock insuficiente');
      }
      // Insertar venta
      await txn.insert('sales', s.toMap());
      // Actualizar stock
      await txn.update(
        'medicines',
        {'stock': stock - s.quantity},
        where: 'id=?',
        whereArgs: [s.medicineId],
      );
    });
  }

  Future<List<Map<String, dynamic>>> list({DateTime? from, DateTime? to}) async {
    final db = await AppDB.instance.database;
    final where = <String>[];
    final args = <Object>[];
    if (from != null) { where.add('date >= ?'); args.add(from.toIso8601String()); }
    if (to != null)   { where.add('date <= ?'); args.add(to.toIso8601String()); }
    final whereClause = where.isEmpty ? '' : 'WHERE ' + where.join(' AND ');

    return db.rawQuery('''
      SELECT s.id, s.quantity, s.date, m.name AS medicine_name, m.price
      FROM sales s
      JOIN medicines m ON m.id = s.medicine_id
      $whereClause
      ORDER BY s.date DESC
    ''', args);
  }
}
