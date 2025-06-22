import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/product_screen.dart';
import '../models/product_model.dart';
import '../screens/cart_screen.dart';
import '../screens/payment_screen.dart';

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
      case PaymentScreen.id:
        return MaterialPageRoute(builder: (context) => const PaymentScreen());
      
      default:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
    }
  }
}