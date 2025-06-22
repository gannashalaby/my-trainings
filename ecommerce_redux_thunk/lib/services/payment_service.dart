import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../../models/payment_model.dart';

class PaymentService {
  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/payments.json';
  }

  Future<void> savePayment(PaymentModel payment) async {
    final file = File(await _getFilePath());
    List<dynamic> existing = [];

    if (await file.exists()) {
      final content = await file.readAsString();
      if (content.isNotEmpty) {
        existing = jsonDecode(content);
      }
    }

    existing.add(payment.toJson());
    await file.writeAsString(jsonEncode(existing));
  }
}
