import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/states/app_state.dart';
import '../redux/actions/payment_action.dart';
import '../redux/middlewares/cart_thunk.dart';
import '../redux/middlewares/payment_thunk.dart';
import '../models/cart_model.dart';
import '../widgets/cart_item_tile.dart';
import '../constans/colors.dart';

class PaymentScreen extends StatefulWidget {
  static const String id = '/payment';

  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late List<CartItem> selectedItems;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = StoreProvider.of<AppState>(context);
      final user = store.state.userState.currentUser;

      // Not logged in check
      if (user == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to proceed with payment.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        _checkStockAndAdjust();
      }
    });
  }

  void _checkStockAndAdjust() {
    final store = StoreProvider.of<AppState>(context);
    bool adjusted = false;

    for (var item in selectedItems) {
      final stock = item.productInCart.quantity;
      if (item.quantityInCart > stock) {
        store.dispatch(updateCartQuantityThunk(item.productInCart.id, stock));
        item = CartItem(productInCart: item.productInCart, quantityInCart: stock);
        adjusted = true;
      }
    }

    if (adjusted) {
      setState(() {}); // Refresh UI
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Some items exceeded stock and were adjusted.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Receive selected cart items from arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    selectedItems = (args is List<CartItem>) ? args : [];

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        final selectedMethod = state.paymentState.selectedMethod;

        final total = selectedItems.fold<double>(
          0.0,
          (sum, item) => sum + item.productInCart.price * item.quantityInCart,
        );

        return Scaffold(
          appBar: AppBar(title: const Text('Payment')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Selected Items",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedItems.length,
                    itemBuilder: (context, index) {
                      final item = selectedItems[index];
                      return CartItemTile(item: item, product: item.productInCart);
                    },
                  ),
                ),
                const Divider(height: 20),
                const Text("Choose Payment Method", style: TextStyle(fontSize: 18)),
                Row(
                  children: ['Cash', 'PayPal'].map((method) {
                    return Expanded(
                      child: RadioListTile<String>(
                        title: Text(method),
                        value: method,
                        groupValue: selectedMethod,
                        onChanged: (value) {
                          StoreProvider.of<AppState>(context).dispatch(
                            SelectPaymentMethod(value!),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 18)),
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
                ElevatedButton(
                  onPressed: () {
                    StoreProvider.of<AppState>(context)
                        .dispatch(confirmSelectedItemsPaymentThunk(selectedItems));

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Payment Successful'),
                        content: Text(
                          'Paid SAR ${total.toStringAsFixed(2)} via $selectedMethod',
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                  ),
                  child: const Text(
                    'Confirm Payment',
                    style: TextStyle(
                      color: CustomColors.backgroundColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
