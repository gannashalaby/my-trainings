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
      final List<dynamic> decoded = json.decode(content);
      payments = decoded.map((e) => Payment.fromJson(e)).toList();
    }

    payments.add(payment);
    await file.writeAsString(json.encode(payments.map((e) => e.toJson()).toList()));
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
