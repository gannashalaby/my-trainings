import '../../models/payment_model.dart';

class MakePaymentRequest {
  final String method;

  MakePaymentRequest(this.method);
}

class MakePaymentSuccess {
  final Payment payment;
  final String method;

  MakePaymentSuccess(this.payment, this.method);
}

class MakePaymentFailure {
  final String error;
  MakePaymentFailure(this.error);
}
