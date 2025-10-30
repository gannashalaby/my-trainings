import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../redux/states/app_state.dart';
import '../redux/middlewares/user_thunk.dart';
import '../constans/texts.dart';

class UserBottomBar extends StatelessWidget {
  const UserBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  store.dispatch(printUsersThunk());
                },
                child: const Text(
                  'Print Users',
                  style: CustomTextStyles.smallButtonText,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  store.dispatch(clearUsersThunk());
                },
                child: const Text(
                  'Clear Users',
                  style: CustomTextStyles.smallButtonText,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  store.dispatch(printUserPathThunk());
                },
                child: const Text(
                  'Print Users Path',
                  style: CustomTextStyles.smallButtonText,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}