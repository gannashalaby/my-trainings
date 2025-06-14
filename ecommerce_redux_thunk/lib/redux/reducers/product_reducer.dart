import 'package:ecommerce_redux_thunk/redux/actions/product_action.dart';
import 'package:ecommerce_redux_thunk/redux/states/product_state.dart';

ProductState productReducer(ProductState state, dynamic action) {
  if (action is FetchProductRequest) {
    return state.copyWith(isLoading: true, errorMessage: null);
  } else if (action is FetchProductSuccess) {
    return state.copyWith(
      products: action.product,
      isLoading: false,
      errorMessage: null,
    );
  } else if (action is FetchProductFailure) {
    return state.copyWith(isLoading: false, errorMessage: action.error);
  }
  return state;
}
