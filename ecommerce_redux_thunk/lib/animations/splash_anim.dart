import 'package:flutter/material.dart';

class SplashAnim extends StatelessWidget {
  final Animation<double> animation;

  const SplashAnim({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: ClipOval(
        // borderRadius: BorderRadius.circular(500),
        child: SizedBox(
          width: 400,
          height: 400,
          child: Image.asset(
            'assets/images/splash_screen_image.jpg',
          ),
        ),
      ),
    );
  }
}
