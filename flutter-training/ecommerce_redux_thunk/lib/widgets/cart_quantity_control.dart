import 'package:ecommerce_redux_thunk/constans/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/states/app_state.dart';
import '../redux/middlewares/cart_thunk.dart';
import '../models/cart_model.dart';

class CartQuantityControls extends StatelessWidget {
  final CartItem item;

  const CartQuantityControls({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline, color: CustomColors.backgroundColor,),
          onPressed: () {
            StoreProvider.of<AppState>(context).dispatch(
              decreaseCartItemQuantityThunk(item.productInCart.id, context),
            );
          },
        ),
        Text(
          item.quantityInCart.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, color: CustomColors.backgroundColor,),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, color: CustomColors.backgroundColor,),
          onPressed: () {
            StoreProvider.of<AppState>(context).dispatch(
              addToCartThunk(
                CartItem(productInCart: item.productInCart, quantityInCart: 1),
                context,
              ),
            );
          },
        ),
      ],
    );
  }
}