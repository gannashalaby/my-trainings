import 'user_state.dart';
import 'product_state.dart';

class AppState {
  final UserState userState;
  final ProductState productState;

  AppState({required this.userState, required this.productState});

  factory AppState.initial() => AppState(
        userState: UserState.initial(),
        productState: ProductState.initial(),
      );
}
