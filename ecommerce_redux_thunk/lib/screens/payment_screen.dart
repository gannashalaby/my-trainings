import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../models/cart_model.dart';
import '../models/payment_model.dart';
import '../redux/states/app_state.dart';
import '../redux/middlewares/payment_thunk.dart';
import '../constans/colors.dart';
import '../constans/texts.dart';
import '../widgets/selected_product_tile.dart';

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
        child: DefaultTextStyle(
          style: TextStyle(color: CustomColors.backgroundColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Selected Products:', style: CustomTextStyles.subheading),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.selectedItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.selectedItems[index];
                    return SelectedProductTile(item: item);
                  },
                  separatorBuilder: (_, __) => const Divider(
                    color: CustomColors.backgroundColor,
                    thickness: 0.5,
                    height: 16,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Divider(color: CustomColors.backgroundColor),
              const SizedBox(height: 16),

              const Text('Payment Method:', style: CustomTextStyles.subheading),
              const SizedBox(height: 12),

              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => selectedMethod = 'Cash');
                    },
                    child: Card(
                      color: selectedMethod == 'Cash' ? CustomColors.backgroundColor.withOpacity(0.1) : Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: const Text('Cash on Delivery', style: TextStyle(fontWeight: FontWeight.bold, color: CustomColors.backgroundColor)),
                        subtitle: const Text('Pay in cash when your order arrives at your door.', style: TextStyle(color: CustomColors.backgroundColor)),
                        trailing: selectedMethod == 'Cash' ? const Icon(Icons.check_circle, color: CustomColors.backgroundColor) : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() => selectedMethod = 'Paypal');
                    },
                    child: Card(
                      color: selectedMethod == 'Paypal' ? CustomColors.backgroundColor.withOpacity(0.1) : Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: const Text('PayPal', style: TextStyle(fontWeight: FontWeight.bold, color: CustomColors.backgroundColor)),
                        subtitle: const Text('Secure online payment via PayPal.', style: TextStyle(color: CustomColors.backgroundColor),),
                        trailing: selectedMethod == 'Paypal' ? const Icon(Icons.check_circle, color: CustomColors.backgroundColor) : null,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: CustomColors.backgroundColor.withOpacity(0.3))),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: SAR ${totalAmount.toStringAsFixed(2)}', style: CustomTextStyles.subheading),
              StoreConnector<AppState, void Function()>(
              converter: (store) {
                return () {
                  final payment = Payment(
                    id: 0,
                    items: widget.selectedItems,
                    method: selectedMethod,
                    amount: totalAmount,
                    timestamp: DateTime.now(),
                  );

                  store.dispatch(makePaymentThunk(widget.username, payment));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment completed successfully!')),
                  );
                  Navigator.pop(context);
                };
              },
              builder: (_, makePayment) => ElevatedButton(
                onPressed: () {
                  if (selectedMethod == 'Cash') {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Cash on Delivery Selected', style: TextStyle(color: CustomColors.backgroundColor)),
                        content: const Text('You have chosen to pay with Cash on Delivery. '
                            'Please ensure someone is available to receive and pay at delivery time.', style: TextStyle(color: CustomColors.backgroundColor)),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);

                              final payment = Payment(
                                id: 0,
                                items: widget.selectedItems,
                                method: selectedMethod,
                                amount: totalAmount,
                                timestamp: DateTime.now(),
                              );

                              StoreProvider.of<AppState>(context)
                                  .dispatch(makePaymentThunk(widget.username, payment));

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Payment completed successfully!')),
                              );

                              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                            },
                            child: const Text('Confirm', style: CustomTextStyles.buttonText),
                          ),
                        ],
                      ),
                    );
                  } else if (selectedMethod == 'Paypal') {
                    Navigator.pushNamed(context, '/paypal-payment');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Pay Now', style: CustomTextStyles.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
