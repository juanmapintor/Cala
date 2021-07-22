import 'package:flutter/material.dart';

class CalaColors {
  static const mainTealColor = Colors.teal;
  static const secondaryTealColor = Colors.tealAccent;
  static const mainOrangeColor = Colors.orange;
  static const secondaryOrangeColor = Colors.orangeAccent;

  static const textDarker = Color(0xFF000000);
  static const textDark = Color(0xFF000000);
  static const textLighter = Color(0xFFFFFFFF);
  static const textLight = Color(0xFFFFFFFF);

  static const MaterialColor teal = Colors.teal;

  static const MaterialColor orange = Colors.orange;

  static const gradientBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        orange,
        teal,
      ],
    ),
  );
}
