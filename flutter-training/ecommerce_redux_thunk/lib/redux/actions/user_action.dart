import 'package:ecommerce_redux_thunk/models/user_model.dart';

class RegisterUserRequest {}
class RegisterUserSuccess {
  final User user;

  RegisterUserSuccess(this.user);
}
class RegisterUserFailure {
  final String error;

  RegisterUserFailure(this.error);
}

class LoginUserRequest {}
class LoginUserSuccess {
  final User user;

  LoginUserSuccess(this.user);
}
class LoginUserFailure {
  final String error;

  LoginUserFailure(this.error);
}

class LogoutUserAction {}

class UserJsonRequest {}
class UserJsonSuccess {}
class UserJsonFailure {
  final String error;

  UserJsonFailure(this.error);
}