import 'package:ecommerce_redux_thunk/redux/actions/recommended_product_action.dart';
import 'package:ecommerce_redux_thunk/redux/states/recommended_product_state.dart';

RecommendedProductState recommendedProductReducer(RecommendedProductState state, dynamic action) {
  if (action is FetchRecommendedProductRequest) {
    return state.copyWith(isLoading: true, errorMessage: null);
  } else if (action is FetchRecommendedProductSuccess) {
    return state.copyWith(
      recommendedProducts: action.recommendedProducts,
      isLoading: false,
      errorMessage: null,
    );
  } else if (action is FetchRecommendedProductFailure) {
    return state.copyWith(isLoading: false, errorMessage: action.error);
  }
  return state;
}