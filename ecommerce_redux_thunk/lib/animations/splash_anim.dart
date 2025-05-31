import 'package:ecommerce_redux_thunk/paths/imagePaths.dart';
import 'package:flutter/material.dart';

class SplashAnim extends StatelessWidget {
  final Animation<double> animation;
  final path = imagePaths[0];

  SplashAnim({super.key, required this.animation});

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
              image: AssetImage((path)),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
