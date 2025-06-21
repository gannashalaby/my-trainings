import 'product_model.dart';

class CartItem {
  final Product productInCart;
  final int quantityInCart;

  CartItem({
    required this.productInCart,
    required this.quantityInCart,
  });

  bool get isSoldOut => productInCart.quantity == 0;
  bool get isVeryLowStock => productInCart.quantity > 0 && productInCart.quantity <= 4;
  bool get isLowStock => productInCart.quantity >= 5 && productInCart.quantity <= 9;

  Map<String, dynamic> toJson() => {
        'product': productInCart.toJson(),
        'quantityInCart': quantityInCart,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productInCart: Product.fromJson(json['product']),
      quantityInCart: json['quantityInCart'],
    );
  }
}