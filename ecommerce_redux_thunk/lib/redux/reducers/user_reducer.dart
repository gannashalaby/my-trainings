import 'package:ecommerce_redux_thunk/redux/actions/user_action.dart';
import 'package:ecommerce_redux_thunk/redux/states/user_state.dart';

UserState userReducer(UserState state, dynamic action) {
  if (action is RegisterUserRequest || action is LoginUserRequest) {
    return state.copyWith(isLoading: true, errorMessage: null);
  } else if (action is RegisterUserSuccess || action is LoginUserSuccess) {
    return state.copyWith(
      currentUser: action.user,
      isLoading: false,
      errorMessage: null,
    );
  } else if (action is RegisterUserFailure || action is LoginUserFailure) {
    return state.copyWith(
      isLoading: false,
      errorMessage: action.error,
    );
  }
  return state;
}