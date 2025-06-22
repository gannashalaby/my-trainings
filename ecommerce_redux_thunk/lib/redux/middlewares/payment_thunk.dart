import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import '../states/app_state.dart';
import '../actions/payment_action.dart';
import '../../services/payment_service.dart';
import '../../models/payment_model.dart';
import '../actions/cart_action.dart';
import '../middlewares/cart_thunk.dart';
import '../../models/cart_model.dart';
import '../../services/cart_service.dart';

ThunkAction<AppState> confirmPaymentThunk() {
  return (Store<AppState> store) async {
    try {
      final cartItems = store.state.cartState.items;
      final user = store.state.userState.currentUser;
      final method = store.state.paymentState.selectedMethod;

      final total = cartItems.fold<double>(
        0.0,
        (sum, item) => sum + item.productInCart.price * item.quantityInCart,
      );

      final payment = PaymentModel(
        username: user?.name ?? '',
        method: method,
        amount: total,
        items: cartItems,
        timestamp: DateTime.now(),
      );

      await PaymentService().savePayment(payment);
      store.dispatch(PaymentSuccess());

      // Clear the cart after payment
      store.dispatch(clearCartThunk());
    } catch (e) {
      store.dispatch(PaymentFailure(e.toString()));
    }
  };
}

ThunkAction<AppState> confirmSelectedItemsPaymentThunk(List<CartItem> selectedItems) {
  return (Store<AppState> store) async {
    try {
      final user = store.state.userState.currentUser;
      final method = store.state.paymentState.selectedMethod;
      final total = selectedItems.fold<double>(
        0.0,
        (sum, item) => sum + item.productInCart.price * item.quantityInCart,
      );

      final payment = PaymentModel(
        username: user?.name ?? 'Guest',
        method: method,
        amount: total,
        items: selectedItems,
        timestamp: DateTime.now(),
      );

      await PaymentService().savePayment(payment);
      store.dispatch(PaymentSuccess());

      // Remove only selected items from cart
      final remainingItems = store.state.cartState.items
          .where((item) => !selectedItems.any((sel) => sel.productInCart.id == item.productInCart.id))
          .toList();

      final username = store.state.userState.currentUser?.name;
      await CartService().saveCart(username, remainingItems);
      store.dispatch(LoadCartAction(remainingItems));
    } catch (e) {
      store.dispatch(PaymentFailure(e.toString()));
    }
  };
}

List<Middleware<AppState>> createPaymentMiddleware() => [];