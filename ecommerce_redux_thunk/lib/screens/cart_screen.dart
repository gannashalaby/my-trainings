import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/states/app_state.dart';
import '../redux/middlewares/cart_thunk.dart';
import '../widgets/cart_item_tile.dart';
import '../constans/colors.dart';
import '../widgets/cart_quantity_control.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  static const String id = '/cart';

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _proceedToPayment(AppState state) {
    final selectedItems = state.cartState.items
        .where((item) => item.isSelected)
        .toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one item to checkout"),
        ),
      );
      return;
    }

    // bool adjusted = false;

    // for (var item in selectedItems) {
    //   final available = item.productInCart.quantity;
    //   if (available == 0) {
    //     continue;
    //   }

    //   if (item.quantityInCart > available) {
    //     store.dispatch(updateCartQuantityThunk(item.productInCart.id, available));
    //     adjusted = true;
    //   }
    // }

    // if (adjusted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text("Some quantities were adjusted due to limited stock."),
    //     ),
    //   );
    // }

    print('Selected Items to pass: ${selectedItems.length}');

    Navigator.pushNamed(
      context,
      '/payment',
      arguments: {
        'items': selectedItems.map((e) => e.toJson()).toList(),
        'username': state.userState.currentUser?.name ?? 'guest',
      },
    );
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
            .where((item) => item.isSelected)
            .toList();

        final total = selectedItems.fold<double>(
          0.0,
          (sum, item) => sum + item.productInCart.price * item.quantityInCart,
        );

        final allSelected =
            cartItems.isNotEmpty && cartItems.every((item) => item.isSelected);

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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: allSelected,
                            onChanged: (_) {
                              final store = StoreProvider.of<AppState>(context);
                              final selectAll = !allSelected;
                              for (final item in cartItems) {
                                if (item.isSelected != selectAll) {
                                  store.dispatch(
                                    toggleCartItemSelectionThunk(
                                      item.productInCart.id,
                                    ),
                                  );
                                }
                              }
                            },
                            side: BorderSide(
                              color: CustomColors.backgroundColor,
                              width: 2,
                            ),
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
                    const Divider(
                      height: 1,
                      color: CustomColors.backgroundColor,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          final product = item.productInCart;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Checkbox(
                                  value: item.isSelected,
                                  onChanged: (_) {
                                    StoreProvider.of<AppState>(
                                      context,
                                    ).dispatch(
                                      toggleCartItemSelectionThunk(product.id),
                                    );
                                  },
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
                                Expanded(
                                  child: CartItemTile(
                                    item: item,
                                    product: product,
                                  ),
                                ),
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
