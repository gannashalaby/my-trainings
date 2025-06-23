import 'package:ecommerce_redux_thunk/constans/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/states/app_state.dart';
import '../redux/middlewares/payment_thunk.dart';
import '../models/cart_model.dart';
import '../models/payment_model.dart';
// import '../widgets/logout_button.dart'; // optional
// import 'package:uuid/uuid.dart'; // for unique usernames if needed

class PaymentScreen extends StatefulWidget {
  static const String id = '/payment';
  final List<CartItem> selectedItems;
  final String username;

  const PaymentScreen({
    super.key,
    required this.selectedItems,
    required this.username,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'Cash';

  double get totalAmount => widget.selectedItems.fold(
    0,
    (sum, item) => sum + item.productInCart.price * item.quantityInCart,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selected Products:'),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedItems.length,
                itemBuilder: (context, index) {
                  final item = widget.selectedItems[index];
                  return ListTile(
                    title: Text(item.productInCart.name),
                    subtitle: Text(
                      'Qty: ${item.quantityInCart} • \$${(item.productInCart.price * item.quantityInCart).toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
            ),
            Text('Total: \$${totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedMethod,
              items: ['Cash', 'Paypal'].map((String method) {
                return DropdownMenuItem(value: method, child: Text(method));
              }).toList(),
              onChanged: (value) {
                setState(() => selectedMethod = value!);
              },
              decoration: const InputDecoration(labelText: 'Select Payment Method'),
            ),
            const SizedBox(height: 16),
            StoreConnector<AppState, void Function()>(
              converter: (store) {
                return () {
                  for (final item in widget.selectedItems) {
                    final payment = Payment(
                      items: item,
                      method: selectedMethod,
                      amount: item.productInCart.price * item.quantityInCart,
                      timestamp: DateTime.now(),
                    );
                    store.dispatch(makePaymentThunk(widget.username, payment));
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payments processed!')),
                  );
                  Navigator.pop(context);
                };
              },
              builder: (_, makePayment) => ElevatedButton(
                onPressed: makePayment,
                child: const Text('Pay Now', style: TextStyle(color: CustomColors.backgroundColor),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
