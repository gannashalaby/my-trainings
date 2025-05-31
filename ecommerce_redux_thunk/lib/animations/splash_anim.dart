import 'package:flutter/material.dart';

class SplashAnim extends StatelessWidget {
  final Animation<double> animation;

  const SplashAnim({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          height: animation.value,
          width: animation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/splash_screen_image.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
