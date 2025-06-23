import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import '../../models/payment_model.dart';
import '../../services/payment_service.dart';
import '../actions/payment_action.dart';
import '../states/app_state.dart';

ThunkAction<AppState> makePaymentThunk(String username, Payment payment) {
  return (Store<AppState> store) async {
    store.dispatch(MakePaymentRequest(payment.method)); // Pass method explicitly

    try {
      final service = PaymentService();
      await service.savePayment(username, payment);

      store.dispatch(MakePaymentSuccess(payment, payment.method)); // Pass method explicitly
    } catch (e) {
      store.dispatch(MakePaymentFailure(e.toString()));
    }
  };
}
