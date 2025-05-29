import 'package:ecommerce_redux_thunk/constans/colors.dart';
import 'package:ecommerce_redux_thunk/route_generator.dart';
import 'package:ecommerce_redux_thunk/screens/splashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ecommerceThunk());
}

class ecommerceThunk extends StatelessWidget {
  const ecommerceThunk({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce Thunk',
      theme: ThemeData(
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
    );
  }
}

//Refrences:
// 1. https://www.geeksforgeeks.org/what-is-the-use-of-middleware-redux-thunk/ (until Steps to Setup of Redux with Thunk)
// 2. https://github.com/rashidwassan/flutter-ecommerce-app-ui/tree/main
// 3. https://www.geeksforgeeks.org/flutter-working-with-animations/
