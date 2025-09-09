// redux/reducers/payment_reducer.dart
import '../states/payment_state.dart';
import '../actions/payment_action.dart';

PaymentState paymentReducer(PaymentState state, dynamic action) {
  if (action is MakePaymentRequest) {
    // Note: MakePaymentRequest must include 'method'
    return state.copyWith(methodUsed: action.method,);
  } else if (action is MakePaymentSuccess) {
    return state.copyWith(isPaid: true, error: null);
  } else if (action is MakePaymentFailure) {
    return state.copyWith(isPaid: false, error: null);
  } else if (action is MakePaymentFailure) {
    return state.copyWith(isPaid: false, error: action.error);
  }
  return state;
}
