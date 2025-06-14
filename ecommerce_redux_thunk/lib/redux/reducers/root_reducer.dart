import 'package:ecommerce_redux_thunk/redux/reducers/user_reducer.dart';
import 'package:ecommerce_redux_thunk/redux/reducers/product_reducer.dart';
import 'package:ecommerce_redux_thunk/redux/states/app_state.dart';

AppState rootReducer(AppState state, dynamic action) {
  return AppState(
    userState: userReducer(state.userState, action),
    productState: productReducer(state.productState, action),
  );
}