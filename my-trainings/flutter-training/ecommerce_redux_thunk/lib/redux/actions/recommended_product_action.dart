import 'package:ecommerce_redux_thunk/models/product_model.dart';

class FetchRecommendedProductRequest {}

class FetchRecommendedProductSuccess {
  final List<Product> recommendedProducts;

  FetchRecommendedProductSuccess(this.recommendedProducts);
}

class FetchRecommendedProductFailure {
  final String error;

  FetchRecommendedProductFailure(this.error);
}