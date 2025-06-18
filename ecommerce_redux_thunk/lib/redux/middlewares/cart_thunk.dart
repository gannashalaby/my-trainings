import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import '../states/app_state.dart';
import '../../models/cart_model.dart';
import '../../services/cart_service.dart';
import '../actions/cart_action.dart';

ThunkAction<AppState> loadCartThunk(String username) {
  return (Store<AppState> store) async {
    final items = await CartService().loadCart(username);
    store.dispatch(LoadCartAction(items));
  };
}

ThunkAction<AppState> addToCartThunk(CartItem item, BuildContext context) {
  return (Store<AppState> store) async {
    final existing = store.state.cartState.items.firstWhere(
      (e) => e.productInCart.id == item.productInCart.id,
      orElse: () => CartItem(productInCart: item.productInCart, quantityInCart: 0),
    );

    final newQuantity = existing.quantityInCart + item.quantityInCart;
    final availableStock = item.productInCart.quantity;

    if (availableStock == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("This item is sold out")),
      );
      return;
    }

    if (newQuantity > availableStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Not enough stock available")),
      );
      return;
    }

    store.dispatch(AddToCartAction(item));

    final username = store.state.userState.currentUser?.name;
    if (username != null) {
      await CartService().saveCart(username, store.state.cartState.items);
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Item added to cart successfully")),
    );
  };
}


ThunkAction<AppState> decreaseCartItemQuantityThunk(int productId, BuildContext context) {
  return (Store<AppState> store) async {
    final current = store.state.cartState.items;
    final index = current.indexWhere((e) => e.productInCart.id == productId);
    if (index == -1) return;

    final item = current[index];
    if (item.quantityInCart > 1) {
      store.dispatch(
        AddToCartAction(
          CartItem(
            productInCart: item.productInCart,
            quantityInCart: -1,
          ),
        ),
      );
    } else {
      store.dispatch(RemoveFromCartAction(productId));
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Item removed from cart successfully")),
    );
    
    final username = store.state.userState.currentUser!.name;
    await CartService().saveCart(username, store.state.cartState.items);
  };
}

ThunkAction<AppState> removeFromCartThunk(int productId) {
  return (Store<AppState> store) async {
    store.dispatch(RemoveFromCartAction(productId));

    final username = store.state.userState.currentUser?.name;
    if (username != null) {
      await CartService().saveCart(username, store.state.cartState.items);
    }
  };
}

ThunkAction<AppState> clearCartThunk() {
  return (Store<AppState> store) async {
    store.dispatch(ClearCartAction());

    final username = store.state.userState.currentUser?.name;
    if (username != null) {
      await CartService().clearCart(username);
    }
  };
}

List<Middleware<AppState>> createCartMiddleware() => [];