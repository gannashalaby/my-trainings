import 'user_state.dart';
import 'product_state.dart';
import 'recommended_product_state.dart';

class AppState {
  final UserState userState;
  final ProductState productState;
  final RecommendedProductState recommendedProductState;

  AppState({required this.userState, required this.productState, required this.recommendedProductState});

  factory AppState.initial() => AppState(
        userState: UserState.initial(),
        productState: ProductState.initial(),
        recommendedProductState: RecommendedProductState.initial(),
      );
}
