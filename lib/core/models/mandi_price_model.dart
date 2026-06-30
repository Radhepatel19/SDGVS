class MandiPriceModel {
  final String id;
  final String cropName;
  final String price; // formatted as "₹Avg/Unit"
  final String minPrice;
  final String maxPrice;
  final String unit;
  final String status; // 'up', 'down', 'stable'
  final String change; // Derived or direct status text
  final String mandi;
  final DateTime date;

  MandiPriceModel({
    required this.id,
    required this.cropName,
    required this.price,
    required this.minPrice,
    required this.maxPrice,
    required this.unit,
    required this.status,
    required this.change,
    required this.mandi,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cropName': cropName,
      'price': price,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'unit': unit,
      'status': status,
      'change': change,
      'mandi': mandi,
      'date': date.toIso8601String(),
    };
  }

  factory MandiPriceModel.fromMap(Map<String, dynamic> map) {
    final rawAvg = map['price_avg'] ?? 0;
    final unit = map['unit'] ?? 'Quintal';
    final priceStr = '₹$rawAvg/${unit[0]}';

    final minStr = '₹${map['price_min'] ?? '—'}';
    final maxStr = '₹${map['price_max'] ?? '—'}';
    final statusStr = map['status'] ?? 'stable';

    return MandiPriceModel(
      id: map['id'].toString(),
      cropName: map['crop_name'] ?? '',
      price: priceStr,
      minPrice: minStr,
      maxPrice: maxStr,
      unit: unit,
      status: statusStr,
      change: statusStr.toUpperCase(),
      mandi: map['mandi_name'] ?? '',
      date: map['price_date'] != null
          ? DateTime.parse(map['price_date'])
          : DateTime.now(),
    );
  }
}
