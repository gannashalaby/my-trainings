import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../redux/states/app_state.dart';
import '../constans/colors.dart';

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(
      converter: (Store<AppState> store) {
        return () {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        };
      },
      builder: (context, callback) {
        return ElevatedButton.icon(
          icon: const Icon(Icons.logout, color:  CustomColors.bodyColor),
          label: const Text("Login", style: TextStyle(color: CustomColors.bodyColor),),
          onPressed: callback,
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.backgroundColor,
          ),
        );
      },
    );
  }
}
