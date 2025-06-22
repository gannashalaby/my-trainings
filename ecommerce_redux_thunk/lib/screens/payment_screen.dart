import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../constans/colors.dart';

class PaymentScreen extends StatefulWidget {
  static const String id = '/payment';

  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<CartItem> selectedItems = [];
  String selectedMethod = 'Cash';
  bool stockAdjusted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is List<CartItem>) {
      selectedItems = List<CartItem>.from(args);

      // Adjust cart if stock is less than requested quantity
      for (int i = 0; i < selectedItems.length; i++) {
        final item = selectedItems[i];
        if (item.quantityInCart > item.productInCart.quantity) {
          selectedItems[i] = CartItem(
            productInCart: item.productInCart,
            quantityInCart: item.productInCart.quantity,
          );
          stockAdjusted = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = selectedItems.fold<double>(
      0.0,
      (sum, item) => sum + item.productInCart.price * item.quantityInCart,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (stockAdjusted)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '⚠ Some items were adjusted due to limited stock.',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const Text(
              'Items Selected:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: selectedItems.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = selectedItems[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        item.productInCart.imagePath,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productInCart.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'SAR ${item.productInCart.price.toStringAsFixed(2)} × ${item.quantityInCart}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Payment Method:',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: ['Cash', 'PayPal'].map((method) {
                return Expanded(
                  child: RadioListTile<String>(
                    title: Text(method),
                    value: method,
                    groupValue: selectedMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedMethod = value!;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'SAR ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Payment Successful'),
                      content: Text(
                        'You paid SAR ${total.toStringAsFixed(2)} via $selectedMethod.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.bodyColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Confirm Payment',
                  style: TextStyle(
                    color: CustomColors.backgroundColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
