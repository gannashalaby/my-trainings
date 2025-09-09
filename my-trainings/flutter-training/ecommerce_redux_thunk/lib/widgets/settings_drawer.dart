import 'package:ecommerce_redux_thunk/redux/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'logout_button.dart';
import 'login_button.dart';
import '../constans/colors.dart';
import '../redux/states/app_state.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserState>(
      converter: (store) => store.state.userState,
      builder: (context, state) {
        final username = state.currentUser?.name;

        return Drawer(
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: CustomColors.backgroundColor,
                  ),
                  title: Text(
                    "Settings",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.backgroundColor,
                    ),
                  ),
                ),
                const Divider(color: CustomColors.backgroundColor),
                const SizedBox(height: 12),

                if (username != null) LogoutButtonWidget()
                else LoginButtonWidget()
              ],
            ),
          ),
        );
      },
    );
  }
}
