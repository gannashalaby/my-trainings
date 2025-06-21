import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../models/cart_model.dart';
import '../redux/states/app_state.dart';
import '../redux/middlewares/cart_thunk.dart';
import '../widgets/cart_quantity_control.dart';
import '../constans/colors.dart';
import '../models/product_model.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final Product product;

  const CartItemTile({super.key, required this.item, required this.product});

  @override
  Widget build(BuildContext context) {
    final isSoldOut = product.quantity == 0;
    final isVeryLowStock = product.quantity > 0 && product.quantity < 5;
    final isLowStock = product.quantity >= 5 && product.quantity < 10;

    Widget? stockText() {
      if (isSoldOut) {
        return const Text(
          '🔴 Sold Out!',
          style: TextStyle(color: CustomColors.errorColor, fontWeight: FontWeight.bold),
        );
      } else if (isVeryLowStock) {
        return Text(
          '🟠 Only ${product.quantity} left!',
          style: const TextStyle(color: CustomColors.warningColor, fontWeight: FontWeight.bold),
        );
      } else if (isLowStock) {
        return const Text(
          '🟡 Low stock!',
          style: TextStyle(color: CustomColors.warningColor, fontWeight: FontWeight.bold),
        );
      }
      return null;
    }

    return StoreConnector<AppState, VoidCallback>(
      // onInit: (store) => {
      //   // print('CartItemTile: onInit called for item ${item.productInCart.id}'),
      // },
      converter: (store) =>
          () => store.dispatch(removeFromCartThunk(item.productInCart.id)),
      builder: (context, removeItem) {

        // print('Quantity: ${item.productInCart.quantity}');
        // print('SoldOut: $isSoldOut, VeryLow: $isVeryLowStock, Low: $isLowStock');

        // print('Q: ${item.productInCart.quantity} | SoldOut: $isSoldOut | VeryLow: $isVeryLowStock | Low: $isLowStock');

        return ListTile(
          leading: Image.asset(
            item.productInCart.imagePath,
            width: 50,
            height: 50,
          ),
          title: Text(
            item.productInCart.name,
            style: TextStyle(
              color: CustomColors.backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SAR ${item.productInCart.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: CustomColors.backgroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (stockText() != null) stockText()!,
            ],
          ),
          trailing: CartQuantityControls(item: item),
        );
      },
    );
  }
}
