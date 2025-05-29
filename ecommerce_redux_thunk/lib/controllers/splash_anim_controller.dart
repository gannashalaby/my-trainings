import 'package:flutter/material.dart';

class SplashAnimationController {
  late final AnimationController controller;
  late final Animation<double> animation;

  SplashAnimationController({required TickerProvider vsync}) {
    controller = AnimationController(
      vsync: vsync,
      duration: Duration(milliseconds: 500),
    );

    animation = Tween(begin: 140.0, end: 160.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.elasticInOut,
      ),
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.repeat();
      }
    });
  }

  void dispose() {
    controller.dispose();
  }
}
