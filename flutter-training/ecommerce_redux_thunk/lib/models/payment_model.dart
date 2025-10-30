import 'cart_model.dart';

class Payment {
  final int id;
  final List<CartItem> items;
  final String method;
  final double amount;
  final DateTime timestamp;

  Payment({
    required this.id,
    required this.items,
    required this.method,
    required this.amount,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
      'id': id,
      'items': items.map((e) => e.toJson()).toList(),
      'method': method,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
    };

  static Payment fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      items: (json['items'] as List).map((e) => CartItem.fromJson(e)).toList(),
      method: json['method'],
      amount: json['amount'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
