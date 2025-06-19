import 'package:ecommerce_redux_thunk/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_redux_thunk/screens/login_screen.dart';
import 'package:ecommerce_redux_thunk/constans/colors.dart';
import 'package:ecommerce_redux_thunk/controllers/splash_anim_controller.dart';
import 'package:ecommerce_redux_thunk/animations/splash_anim.dart';
import 'package:ecommerce_redux_thunk/constans/texts.dart';
// import 'package:ecommerce_redux_thunk/paths/imagePaths.dart';

class SplashScreen extends StatefulWidget {
  static const String id = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late SplashAnimationController _splashAnimController;
  // final path = imagePaths[0];

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   precacheImage(
    //     AssetImage(path),
    //     context,
    //   );
    // });

    _splashAnimController = SplashAnimationController(vsync: this);
    _splashAnimController.controller.forward();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      _splashAnimController.dispose();
      Navigator.of(context).pushReplacementNamed(HomeScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.bodyColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Welcome to E-Commerce Thunk',
                style: CustomTextStyles.heading,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 160,
              width: 160,
              alignment: Alignment.center,
              child: SplashAnim(animation: _splashAnimController.animation),
            ),
          ],
        ),
      ),
    );
  }
}
