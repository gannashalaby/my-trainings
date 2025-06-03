import 'package:flutter/material.dart';
import 'package:ecommerce_redux_thunk/screens/splash_screen.dart';
import 'package:ecommerce_redux_thunk/screens/login_screen.dart';
import 'package:ecommerce_redux_thunk/screens/register_screen.dart';
import 'package:ecommerce_redux_thunk/screens/home_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.id:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case LoginScreen.id:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case RegisterScreen.id:
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case HomeScreen.id:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      
      default:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
    }
  }
}