import 'package:flutter/material.dart';
import 'package:ecommerce_redux_thunk/constans/colors.dart';
import 'package:ecommerce_redux_thunk/constans/texts.dart';
import 'package:ecommerce_redux_thunk/route_generator.dart';
import 'package:ecommerce_redux_thunk/screens/splash_screen.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:ecommerce_redux_thunk/redux/states/app_state.dart';
import 'package:ecommerce_redux_thunk/redux/reducers/root_reducer.dart';
import 'package:ecommerce_redux_thunk/redux/middlewares/user_thunk.dart';
import 'package:ecommerce_redux_thunk/redux/middlewares/product_thunk.dart';
import 'package:ecommerce_redux_thunk/redux/middlewares/cart_thunk.dart';

void main() async{
  final store = Store<AppState>(
    rootReducer,
    initialState: AppState.initial(),
    middleware: [
      thunkMiddleware,
      ...createUserMiddleware(),
      ...createProductMiddleware(),
      ...createCartMiddleware(),
    ],
  );
  
  runApp(EcommerceThunk(store: store));
}

class EcommerceThunk extends StatelessWidget {
  final Store<AppState> store;
  const EcommerceThunk({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce Thunk',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: CustomColors.bodyColor),
            backgroundColor: CustomColors.backgroundColor,
            titleTextStyle: CustomTextStyles.appBar,
          ),
          colorScheme: ColorScheme(
            primary: CustomColors.bodyColor,//
            primaryContainer: CustomColors.backgroundColor,
            secondary: CustomColors.successColor,//
            // secondaryContainer: CustomColors.successColor,
            // background: CustomColors.bodyColor,
            surface: CustomColors.bodyColor,
            error: CustomColors.errorColor,//
            onPrimary: CustomColors.textColor,
            onSecondary: Colors.black,//
            // onBackground: CustomColors.textColor,
            onSurface: CustomColors.textColor,
            onError: Colors.white,//
            brightness: Brightness.light,
          ),
        ),
        initialRoute: SplashScreen.id,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}

//Refrences:
// 1. https://www.geeksforgeeks.org/what-is-the-use-of-middleware-redux-thunk/ (until Steps to Setup of Redux with Thunk)
// 2. https://github.com/rashidwassan/flutter-ecommerce-app-ui/tree/main
// 3. https://www.geeksforgeeks.org/flutter-working-with-animations/
// 4. https://stackoverflow.com/questions/76621965/how-to-store-restore-and-add-to-json-file-sqlite-database-or-text-file
