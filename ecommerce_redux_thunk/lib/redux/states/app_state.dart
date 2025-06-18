import 'user_state.dart';
import 'product_state.dart';
import 'recommended_product_state.dart';
import 'cart_state.dart';

class AppState {
  final UserState userState;
  final ProductState productState;
  final RecommendedProductState recommendedProductState;
  final CartState cartState;

  AppState({required this.userState, required this.productState, required this.recommendedProductState, required this.cartState});

  factory AppState.initial() => AppState(
        userState: UserState.initial(),
        productState: ProductState.initial(),
        recommendedProductState: RecommendedProductState.initial(),
        cartState: CartState(),
      );
}
