import '../../models/cart_model.dart';

class CartState {
  final List<CartItem> items;

  CartState({this.items = const []});

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}