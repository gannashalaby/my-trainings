import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:ecommerce_redux_thunk/models/user_model.dart';
import 'package:ecommerce_redux_thunk/services/user_service.dart';
import 'package:ecommerce_redux_thunk/redux/actions/user_action.dart';
import 'package:ecommerce_redux_thunk/redux/states/app_state.dart';
import 'package:ecommerce_redux_thunk/services/cart_service.dart';

final userService = UserService();

ThunkAction<AppState> registerUserThunk(String name, String password) {
  return (Store<AppState> store) async {
    store.dispatch(RegisterUserRequest());

    try {
      final users = await userService.getAllUsers();

      final newId = users.userList.isEmpty
          ? 1
          : users.userList.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1;

      final user = User(id: newId, name: name, password: password);

      await userService.addUser(user);

      store.dispatch(RegisterUserSuccess(user));
    } catch (error) {
      store.dispatch(RegisterUserFailure(error.toString()));
    }
  };
}

ThunkAction<AppState> loginUserThunk(String name, String password) {
  return (Store<AppState> store) async {
    store.dispatch(LoginUserRequest());

    try {
      final users = await userService.getAllUsers();
      final id = users.userList.first.id;

      final user = User(id: id, name: name, password: password);

      store.dispatch(LoginUserSuccess(user));
    } catch (e) {
      store.dispatch(LoginUserFailure(e.toString()));
    }
  };
}

ThunkAction<AppState> logoutUserThunk() {
  return (Store<AppState> store) async {
    String? username = store.state.userState.currentUser?.name;

    if (username != null && username.isNotEmpty) {
      // print(username + " is logging out");
      await CartService().saveCart(username, store.state.cartState.items);
    }
    store.dispatch(LogoutUserAction());
      // print(username! + " logged out successfully");
  };
}

ThunkAction<AppState> printUsersThunk() {
  return (Store<AppState> store) async {
    await userService.printJsonContent();
  };
}

ThunkAction<AppState> clearUsersThunk() {
  return (Store<AppState> store) async {
    await userService.clearAllUsers();
  };
}

ThunkAction<AppState> printUserPathThunk() {
  return (Store<AppState> store) async {
    await userService.getJsonFilePath();
  };
}

List<Middleware<AppState>> createUserMiddleware() => [];