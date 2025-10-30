import 'package:ecommerce_redux_thunk/models/user_model.dart';

class UserState {
  final User? currentUser;
  final bool isLoading;
  final String? errorMessage;

  UserState({
    this.currentUser,
    this.isLoading = false,
    this.errorMessage,
  });

  UserState copyWith({
    User? currentUser,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserState(
      currentUser: currentUser,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory UserState.initial() {
    return UserState(currentUser: null, isLoading: false, errorMessage: null);
  }
}