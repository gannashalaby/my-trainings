import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../models/cart_model.dart';
import '../redux/states/app_state.dart';
import '../redux/middlewares/cart_thunk.dart';
import '../widgets/cart_quantity_control.dart';
import '../constans/colors.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(
      converter: (store) => () => store.dispatch(removeFromCartThunk(item.productInCart.id)),
      builder: (context, removeItem) {
        final isSoldOut = item.isSoldOut;
        final isVeryLowStock = item.isVeryLowStock;
        final isLowStock = item.isLowStock;

        Widget? _stockText(CartItem item) {
          if (item.isSoldOut) {
            return const Text('Sold Out', style: TextStyle(color: CustomColors.errorColor));
          } else if (item.isVeryLowStock) {
            return Text('Only ${item.productInCart.quantity} left!',
                style: const TextStyle(color: CustomColors.warningColor, fontWeight: FontWeight.bold));
          } else if (item.isLowStock) {
            return const Text('Low stock!',
                style: TextStyle(color: CustomColors.warningColor, fontWeight: FontWeight.bold));
          }
          return null;
        }

        print('Quantity: ${item.productInCart.quantity}');
        print('SoldOut: $isSoldOut, VeryLow: $isVeryLowStock, Low: $isLowStock');

        print('Q: ${item.productInCart.quantity} | SoldOut: $isSoldOut | VeryLow: $isVeryLowStock | Low: $isLowStock');

        return ListTile(
          leading: Image.asset(item.productInCart.imagePath, width: 50, height: 50),
          title: Text(
            item.productInCart.name,
            style: TextStyle(color: CustomColors.backgroundColor, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SAR ${item.productInCart.price.toStringAsFixed(2)}',
                style: TextStyle(color: CustomColors.backgroundColor, fontWeight: FontWeight.bold),
              ),
              if (_stockText(item) != null) _stockText(item)!,
            ],
          ),
          trailing: CartQuantityControls(item: item),
        );
      },
    );
  }
}