import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import '../../models/payment_model.dart';
import '../../services/payment_service.dart';
import '../actions/payment_action.dart';
import '../states/app_state.dart';
import '../../services/cart_service.dart';
import '../../services/product_service.dart';

ThunkAction<AppState> makePaymentThunk(String username, Payment payment) {
  return (Store<AppState> store) async {
    store.dispatch(MakePaymentRequest(payment.method));

    try {
      final service = PaymentService();
      await service.savePayment(username, payment);

      final cartService = CartService();
      await cartService.removePurchasedItems(username, payment.items);

      final productService = ProductService();
      final currentProducts = productService.getMockProducts();

      await productService.reduceProductStockFromList(payment.items, currentProducts);

      store.dispatch(MakePaymentSuccess(payment, payment.method));
    } catch (e) {
      store.dispatch(MakePaymentFailure(e.toString()));
    }
  };
}
