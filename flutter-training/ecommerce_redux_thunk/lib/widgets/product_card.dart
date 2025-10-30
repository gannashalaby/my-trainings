import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../models/product_model.dart';
import '../constans/colors.dart';
import '../screens/product_screen.dart';
import '../redux/states/app_state.dart';
import '../redux/middlewares/cart_thunk.dart';
import '../models/cart_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isVeryLowStock = product.quantity > 0 && product.quantity < 5;
    final isLowStock = product.quantity >= 5 && product.quantity < 10;

    Widget? stockText() {
      if (isVeryLowStock) {
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
      converter: (store) {
        return () {
          final item = CartItem(productInCart: product, quantityInCart: 1);
          store.dispatch(addToCartThunk(item, context));
        };
      },
      builder: (context, addToCart) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              ProductScreen.id,
              arguments: product,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: CustomColors.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: CustomColors.textColor, blurRadius: 4),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      product.imagePath,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.broken_image));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\SAR ${product.price.toStringAsFixed(2)}'),
                      IconButton(
                        onPressed: addToCart,
                        icon: const Icon(Icons.add_shopping_cart),
                        color: CustomColors.bodyColor,
                      ),
                    ],
                  ),
                ),
                if (stockText() != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: stockText(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}