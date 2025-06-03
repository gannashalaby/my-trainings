import 'package:flutter/material.dart';
import 'package:ecommerce_redux_thunk/constans/colors.dart';

class CustomTextStyles {
  static const TextStyle appBar = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: CustomColors.bodyColor,
  );
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: CustomColors.backgroundColor,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: CustomColors.textColor,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: CustomColors.textColor,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: CustomColors.successColor,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: CustomColors.backgroundColor,
  );

  static const TextStyle smallButtonText = TextStyle(
    fontSize: 12,
    // fontWeight: FontWeight.w600,
    color: CustomColors.backgroundColor,
  );
}
