class Medicine {
  final int? id;
  final String name;
  final int stock;
  final double price;
  final String? expiryDate; // ISO-8601 (YYYY-MM-DD)

  Medicine({this.id, required this.name, required this.stock, required this.price, this.expiryDate});

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'stock': stock,
    'price': price,
    'expiry_date': expiryDate,
  };

  factory Medicine.fromMap(Map<String, dynamic> m) => Medicine(
    id: m['id'] as int?,
    name: m['name'] as String,
    stock: m['stock'] as int,
    price: (m['price'] as num).toDouble(),
    expiryDate: m['expiry_date'] as String?,
  );
}

class Sale {
  final int? id;
  final int medicineId;
  final int quantity;
  final DateTime date;

  Sale({this.id, required this.medicineId, required this.quantity, required this.date});

  Map<String, dynamic> toMap() => {
    'id': id,
    'medicine_id': medicineId,
    'quantity': quantity,
    'date': date.toIso8601String(),
  };

  factory Sale.fromMap(Map<String, dynamic> m) => Sale(
    id: m['id'] as int?,
    medicineId: m['medicine_id'] as int,
    quantity: m['quantity'] as int,
    date: DateTime.parse(m['date'] as String),
  );
}
