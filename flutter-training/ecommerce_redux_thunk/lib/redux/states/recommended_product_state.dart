import 'package:ecommerce_redux_thunk/models/product_model.dart';

class RecommendedProductState {
  final bool isLoading;
  final List<Product> recommendedProducts;
  final String? errorMessage;

  RecommendedProductState({
    required this.isLoading,
    required this.recommendedProducts,
    this.errorMessage,
  });

  RecommendedProductState copyWith({
    bool? isLoading,
    List<Product>? recommendedProducts,
    String? errorMessage,
  }) {
    return RecommendedProductState(
      isLoading: isLoading ?? this.isLoading,
      recommendedProducts: recommendedProducts ?? this.recommendedProducts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory RecommendedProductState.initial() {
    return RecommendedProductState(
      isLoading: false,
      recommendedProducts: [],
      errorMessage: null,
    );
  }
}