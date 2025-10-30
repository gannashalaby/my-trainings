import 'package:ecommerce_redux_thunk/models/product_model.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:ecommerce_redux_thunk/services/product_service.dart';
import 'package:ecommerce_redux_thunk/redux/actions/recommended_product_action.dart';
import 'package:ecommerce_redux_thunk/redux/states/app_state.dart';

ThunkAction<AppState> fetchRecommendedProductsThunk(Product currentProduct) {
  return (Store<AppState> store) async {
    store.dispatch(FetchRecommendedProductRequest());

    try {
      final recommended = await ProductService().getRecommendedProducts(currentProduct);
      store.dispatch(FetchRecommendedProductSuccess(recommended));
    } catch (error) {
      store.dispatch(FetchRecommendedProductFailure(error.toString()));
    }
  };
}