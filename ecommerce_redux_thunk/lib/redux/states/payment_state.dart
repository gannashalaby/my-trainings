class PaymentState {
  final String selectedMethod;
  final bool isPaid;
  final String? error;

  PaymentState({
    this.selectedMethod = 'Cash',
    this.isPaid = false,
    this.error,
  });

  PaymentState copyWith({
    String? selectedMethod,
    bool? isPaid,
    String? error,
  }) {
    return PaymentState(
      selectedMethod: selectedMethod ?? this.selectedMethod,
      isPaid: isPaid ?? this.isPaid,
      error: error,
    );
  }
  
  factory PaymentState.initial() {
    return PaymentState(
      selectedMethod: 'Cash',
      isPaid: false,
      error: null,
    );
  }
}
