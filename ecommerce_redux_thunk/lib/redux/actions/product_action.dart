import 'package:ecommerce_redux_thunk/models/product_model.dart';

class FetchProductRequest {}

class FetchProductSuccess {
  final List<Product> product;

  FetchProductSuccess(this.product);
}

class FetchProductFailure {
  final String error;

  FetchProductFailure(this.error);
}

class ProductJsonRequest {}

class ProductJsonSuccess {}

class ProductJsonFailure {
  final String error;

  ProductJsonFailure(this.error);
}
