import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/states/app_state.dart';
import '../redux/middlewares/user_thunk.dart';
import '../constans/colors.dart';

class LogoutButtonWidget extends StatelessWidget {
  const LogoutButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(
      converter: (store) {
        return () {
          store.dispatch(logoutUserThunk());
          Navigator.pushReplacementNamed(context, '/splash');
        };
      },
      builder: (context, callback) {
        return ElevatedButton.icon(
          icon: const Icon(Icons.logout, color:  CustomColors.backgroundColor),
          label: const Text("Logout", style: TextStyle(color: CustomColors.backgroundColor),),
          onPressed: callback,
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.errorColor,
          ),
        );
      },
    );
  }
}
