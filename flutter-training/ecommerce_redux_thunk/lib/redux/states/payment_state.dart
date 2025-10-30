import '../../models/payment_model.dart';

class PaymentState {
  final List<Payment> payments;
  final String methodUsed;
  final bool isPaid;
  final bool isLoading;
  final String? error;

  PaymentState({
    this.payments = const [],
    this.methodUsed = '',
    this.isPaid = false,
    this.isLoading = false,
    this.error,
  });

  PaymentState copyWith({
    List<Payment>? payments,
    String? methodUsed,
    bool? isPaid,
    bool? isLoading,
    String? error,
  }) {
    return PaymentState(
      payments: payments ?? this.payments,
      methodUsed: methodUsed ?? this.methodUsed,
      isPaid: isPaid ?? this.isPaid,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
