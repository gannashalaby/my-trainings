import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/states/app_state.dart';
import '../redux/middlewares/cart_thunk.dart';
import '../widgets/cart_item_tile.dart';
import '../constans/colors.dart';

class CartScreen extends StatelessWidget {
  static const String id = '/cart';

  const CartScreen({super.key});

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

        final total = cartItems.fold<double>(
          0.0,
          (sum, item) => sum + item.productInCart.price * item.quantityInCart,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text("Your Cart"),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(clearCartThunk());
                },
              )
            ],
          ),

          body: cartItems.isEmpty
              ? const Center(child: Text("Your cart is empty! 😱", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColors.backgroundColor,)))
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return CartItemTile(item: item);
                  },
                ),

          bottomNavigationBar: Container(
            color: CustomColors.backgroundColor,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColors.bodyColor,),
                ),
                Text(
                  "SAR ${total.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColors.bodyColor,),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}