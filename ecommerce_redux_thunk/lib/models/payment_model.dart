import 'cart_model.dart';

class Payment {
  final CartItem items;
  final String method;
  final double amount;
  final DateTime timestamp;

  Payment({
    required this.items,
    required this.method,
    required this.amount,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
      'items': items.toJson(),
      'method': method,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
    };

  static Payment fromJson(Map<String, dynamic> json) {
    return Payment(
      items: json['items'],
      method: json['method'],
      amount: json['amount'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
