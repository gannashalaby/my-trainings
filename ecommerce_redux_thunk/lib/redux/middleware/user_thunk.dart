import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:ecommerce_redux_thunk/models/user_model.dart';
import 'package:ecommerce_redux_thunk/services/user_service.dart';
import 'package:ecommerce_redux_thunk/redux/actions/user_action.dart';
import 'package:ecommerce_redux_thunk/redux/states/user_state.dart';

final userService = UserService();

ThunkAction<UserState> registerUserThunk(String name, String password) {
  return (Store<UserState> store) async {
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

ThunkAction<UserState> loginUserThunk(String name, String password) {
  return (Store<UserState> store) async {
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

ThunkAction<UserState> printUsersThunk() {
  return (Store<UserState> store) async {
    await userService.printJsonContent();
  };
}

ThunkAction<UserState> clearUsersThunk() {
  return (Store<UserState> store) async {
    await userService.clearAllUsers();
  };
}

ThunkAction<UserState> printUserPathThunk() {
  return (Store<UserState> store) async {
    await userService.getJsonFilePath();
  };
}
