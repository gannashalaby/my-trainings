import 'cart_model.dart';

class PaymentModel {
  final String username;
  final String method;
  final double amount;
  final List<CartItem> items;
  final DateTime timestamp;

  PaymentModel({
    required this.username,
    required this.method,
    required this.amount,
    required this.items,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'method': method,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
