import '../../models/cart_model.dart';

class LoadCartAction {
  final List<CartItem> items;
  LoadCartAction(this.items);
}

class AddToCartAction {
  final CartItem item;
  AddToCartAction(this.item);
}

class RemoveFromCartAction {
  final int productId;
  RemoveFromCartAction(this.productId);
}

class ClearCartAction {}