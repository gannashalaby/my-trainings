import '../actions/cart_action.dart';
import '../states/cart_state.dart';
import '../../models/cart_model.dart';

import '../actions/user_action.dart';
import '../states/user_state.dart';

CartState cartReducer(CartState state, dynamic action) {
  if (action is LoadCartAction) {
    return state.copyWith(items: action.items);

  } else if (action is AddToCartAction) {
    final existingIndex = state.items.indexWhere(
      (item) => item.productInCart.id == action.item.productInCart.id,
    );

    final updatedItems = [...state.items];
    if (existingIndex >= 0) {
      final existingItem = updatedItems[existingIndex];
      final newQuantity = existingItem.quantityInCart + action.item.quantityInCart;

      if (newQuantity > 0) {
        updatedItems[existingIndex] = CartItem(
          productInCart: existingItem.productInCart,
          quantityInCart: newQuantity,
        );
      } else {
        updatedItems.removeAt(existingIndex);
      }
    } else if (action.item.quantityInCart > 0) {
      updatedItems.add(action.item);
    }

    return state.copyWith(items: updatedItems);
  } else if (action is RemoveFromCartAction) {
    return state.copyWith(
      items: state.items.where((e) => e.productInCart.id != action.productId).toList(),
    );

  } else if (action is ClearCartAction) {
    return state.copyWith(items: []);
  } else if (action is LogoutUserAction) {
    return CartState(items: []);
  }

  return state;
}