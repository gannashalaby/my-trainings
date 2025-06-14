// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:ecommerce_redux_thunk/main.dart';
import 'package:ecommerce_redux_thunk/redux/states/app_state.dart';
import 'package:ecommerce_redux_thunk/redux/reducers/root_reducer.dart';
import 'package:ecommerce_redux_thunk/redux/middlewares/user_thunk.dart';
import 'package:ecommerce_redux_thunk/redux/middlewares/product_thunk.dart';

void main() {
 testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create the store
    final store = Store<AppState>(
      rootReducer,
      initialState: AppState.initial(),
      middleware: [
        thunkMiddleware,
        ...createUserMiddleware(),
        ...createProductMiddleware(),
      ],
    );

    // Pass the store to EcommerceThunk
    await tester.pumpWidget(EcommerceThunk(store: store));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
