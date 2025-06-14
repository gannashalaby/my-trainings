import 'package:ecommerce_redux_thunk/models/product_model.dart';

class ProductState {
  final bool isLoading;
  final List<Product> products;
  final String? errorMessage;

  ProductState({
    required this.isLoading,
    required this.products,
    this.errorMessage,
  });

  ProductState copyWith({
    bool? isLoading,
    List<Product>? products,
    String? errorMessage,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ProductState.initial() {
    return ProductState(
      isLoading: false,
      products: [],
      errorMessage: null,
    );
  }
}
