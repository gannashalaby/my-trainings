import 'package:flutter/material.dart';
import 'package:ecommerce_redux_thunk/screens/splash_screen.dart';
import 'package:ecommerce_redux_thunk/screens/login_screen.dart';
import 'package:ecommerce_redux_thunk/screens/register_screen.dart';
import 'package:ecommerce_redux_thunk/screens/home_screen.dart';
import 'package:ecommerce_redux_thunk/screens/product_screen.dart';
import 'package:ecommerce_redux_thunk/models/product_model.dart';
import 'package:ecommerce_redux_thunk/screens/cart_screen.dart';

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
      case ProductScreen.id:
        final args = settings.arguments as Product;
        return MaterialPageRoute(builder: (context) =>  ProductScreen(product: args));
      case CartScreen.id:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      
      default:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
    }
  }
}