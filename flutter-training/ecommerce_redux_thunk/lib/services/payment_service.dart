import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/payment_model.dart';

class PaymentService {
  Future<String> _getFilePath(String username) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/payments_$username.json';
  }

  Future<void> savePayment(String username, Payment payment) async {
    final path = await _getFilePath(username);
    final file = File(path);
    List<Payment> payments = [];

    if (await file.exists()) {
      final content = await file.readAsString();
      final decoded = jsonDecode(content);
      payments = (decoded as List).map((e) => Payment.fromJson(e)).toList();
    }

    final nextId = payments.isEmpty 
        ? 1 
        : payments.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;

    final newPayment = Payment(
      id: nextId,
      items: payment.items,
      method: payment.method,
      amount: payment.amount,
      timestamp: payment.timestamp,
    );

    payments.add(newPayment);

    await file.writeAsString(jsonEncode(payments.map((e) => e.toJson()).toList()));
  }

  Future<List<Payment>> loadPayments(String username) async {
    final path = await _getFilePath(username);
    final file = File(path);

    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> decoded = json.decode(content);
      return decoded.map((e) => Payment.fromJson(e)).toList();
    }

    return [];
  }
}
