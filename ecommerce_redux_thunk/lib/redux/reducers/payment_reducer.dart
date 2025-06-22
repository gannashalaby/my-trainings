import '../actions/payment_action.dart';
import '../states/payment_state.dart';

PaymentState paymentReducer(PaymentState state, dynamic action) {
  if (action is SelectPaymentMethod) {
    return state.copyWith(selectedMethod: action.method, error: null);
  } else if (action is PaymentSuccess) {
    return state.copyWith(isPaid: true, error: null);
  } else if (action is PaymentFailure) {
    return state.copyWith(error: action.error);
  }

  return state;
}
