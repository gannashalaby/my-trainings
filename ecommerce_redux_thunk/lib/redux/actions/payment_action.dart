class SelectPaymentMethod {
  final String method;
  SelectPaymentMethod(this.method);
}

class PaymentSuccess {}

class PaymentFailure {
  final String error;
  PaymentFailure(this.error);
}
