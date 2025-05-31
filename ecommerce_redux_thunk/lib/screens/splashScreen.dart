import 'package:flutter/material.dart';
import 'package:ecommerce_redux_thunk/screens/loginScreen.dart';
import 'package:ecommerce_redux_thunk/constans/colors.dart';
import 'package:ecommerce_redux_thunk/controllers/splash_anim_controller.dart';
import 'package:ecommerce_redux_thunk/animations/splash_anim.dart';
// import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  static const String id = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late SplashAnimationController _splashAnimController;

  @override
  void initState() {
    super.initState();

    _splashAnimController = SplashAnimationController(vsync: this);
    _splashAnimController.controller.forward();

    Future.delayed(const Duration(seconds: 5), () {
      _splashAnimController.dispose();
      Navigator.of(context).pushReplacementNamed(LoginScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.bodyColor,
      body: Center(
        child: SplashAnim(animation: _splashAnimController.animation),
      ),
    );
  }
}
