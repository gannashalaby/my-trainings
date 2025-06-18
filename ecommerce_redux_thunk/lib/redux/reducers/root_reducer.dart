import '../reducers/user_reducer.dart';
import '../reducers/product_reducer.dart';
import '../reducers/recommended_product_reducer.dart';
import '../reducers/cart_reducer.dart';
import '../states/app_state.dart';

AppState rootReducer(AppState state, dynamic action) {
  return AppState(
    userState: userReducer(state.userState, action),
    productState: productReducer(state.productState, action),
    recommendedProductState: recommendedProductReducer(state.recommendedProductState, action),
    cartState: cartReducer(state.cartState, action),
  );
}