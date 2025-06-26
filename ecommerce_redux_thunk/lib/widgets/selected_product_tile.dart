import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../constans/colors.dart';

class SelectedProductTile extends StatelessWidget {
  final CartItem item;

  const SelectedProductTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(item.productInCart.imagePath), // assuming this is a URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productInCart.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.backgroundColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'SAR ${item.productInCart.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.backgroundColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantity: ${item.quantityInCart}',
                  style: const TextStyle(
                    color: CustomColors.backgroundColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
