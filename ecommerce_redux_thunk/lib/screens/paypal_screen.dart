import 'package:flutter/material.dart';
import '../constans/texts.dart';

class PaypalPaymentScreen extends StatelessWidget {
  static const String id = '/paypal-payment';

  const PaypalPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay with PayPal')),
      body: const Center(child: Text('Redirecting to PayPal...', style: CustomTextStyles.body,)),
    );
  }
}
