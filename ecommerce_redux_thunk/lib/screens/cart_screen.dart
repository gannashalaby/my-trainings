import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/states/app_state.dart';
import '../redux/middlewares/cart_thunk.dart';
import '../widgets/cart_item_tile.dart';
import '../constans/colors.dart';
import '../widgets/cart_quantity_control.dart';

class CartScreen extends StatefulWidget {
  static const String id = '/cart';

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Set<int> _selectedProductIds = {};

  void _toggleSelection(int productId) {
    setState(() {
      if (_selectedProductIds.contains(productId)) {
        _selectedProductIds.remove(productId);
      } else {
        _selectedProductIds.add(productId);
      }
    });
  }

  bool _areAllSelected(List<int> productIds) {
    return productIds.every((id) => _selectedProductIds.contains(id));
  }

  void _toggleSelectAll(List<int> productIds) {
    setState(() {
      if (_areAllSelected(productIds)) {
        _selectedProductIds.clear();
      } else {
        _selectedProductIds.addAll(productIds);
      }
    });
  }

  void _proceedToPayment(AppState state) {
    final selectedItems = state.cartState.items
        .where((item) => _selectedProductIds.contains(item.productInCart.id))
        .toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one item to checkout"),
        ),
      );
      return;
    }
    Navigator.pushNamed(context, '/payment', arguments: selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      onInit: (store) {
        final username = store.state.userState.currentUser?.name;
        store.dispatch(loadCartThunk(username));
      },
      converter: (store) => store.state,
      builder: (context, state) {
        final cartItems = state.cartState.items;

        final selectedItems = cartItems
            .where((item) => _selectedProductIds.contains(item.productInCart.id))
            .toList();

        final total = selectedItems.fold<double>(
          0.0,
          (sum, item) => sum + item.productInCart.price * item.quantityInCart,
        );

        final productIds = cartItems.map((item) => item.productInCart.id).toList();
        final allSelected = _areAllSelected(productIds);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Your Cart"),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  StoreProvider.of<AppState>(
                    context,
                  ).dispatch(clearCartThunk());
                },
              ),
            ],
          ),

          body: cartItems.isEmpty
              ? const Center(
                  child: Text(
                    "Your cart is empty! 😱",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.backgroundColor,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                      child: Row(
                        children: [
                          Checkbox(
                            value: allSelected,
                            onChanged: (_) => _toggleSelectAll(productIds),
                            side: BorderSide(color: CustomColors.backgroundColor, width: 2),
                            activeColor: CustomColors.backgroundColor,
                            checkColor: CustomColors.bodyColor,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "Select All",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.backgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: CustomColors.backgroundColor),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          final product = item.productInCart;
                          final isSelected = _selectedProductIds.contains(product.id);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (_) => _toggleSelection(product.id),
                                  side: BorderSide(
                                    color: CustomColors.backgroundColor,
                                    width: 2,
                                  ),
                                  activeColor: CustomColors.backgroundColor,
                                  checkColor: CustomColors.bodyColor,
                                ),
                                Image.asset(
                                  product.imagePath,
                                  width: 70,
                                  height: 70,
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: CartItemTile(item: item, product: product)),
                                CartQuantityControls(item: item),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

          bottomNavigationBar: Container(
            color: CustomColors.backgroundColor,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.bodyColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "SAR ${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.bodyColor,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    final store = StoreProvider.of<AppState>(context);
                    final user = store.state.userState.currentUser;

                    if (user == null) {
                      // Not logged in
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Login Required'),
                          content: const Text(
                            'Please log in to proceed with payment.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                                Navigator.pushNamed(
                                  context,
                                  '/login',
                                ); // Navigate to login
                              },
                              child: const Text('Login'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      _proceedToPayment(state);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.bodyColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    "Checkout",
                    style: TextStyle(
                      fontSize: 18,
                      color: CustomColors.backgroundColor,
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
