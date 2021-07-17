import 'package:flutter/material.dart';

class CalaColors {
  static const mainTealColor = Color(0xFF7FA998);
  static const secondaryTealColor = Color(0xFFF1F1B0);
  static const mainOrangeColor = Color(0xFFDF8543);
  static const secondaryOrangeColor = Color(0xFFFBC687);

  static const textDark = Color(0xFF000000);
  static const textLight = Color(0xFFFFFFFF);

  static const MaterialColor teal =
      MaterialColor(_tealPrimaryValue, <int, Color>{
    50: Color(0xFFF0F5F3),
    100: Color(0xFFD9E5E0),
    200: Color(0xFFBFD4CC),
    300: Color(0xFFA5C3B7),
    400: Color(0xFF92B6A7),
    500: Color(_tealPrimaryValue),
    600: Color(0xFF77A290),
    700: Color(0xFF6C9885),
    800: Color(0xFF628F7B),
    900: Color(0xFF4F7E6A),
  });
  static const int _tealPrimaryValue = 0xFF7FA998;

  static const MaterialColor tealAccent =
      MaterialColor(_tealAccentValue, <int, Color>{
    100: Color(0xFFE1FFF2),
    200: Color(_tealAccentValue),
    400: Color(0xFF7BFFC4),
    700: Color(0xFF62FFB8),
  });
  static const int _tealAccentValue = 0xFFAEFFDB;

  static const MaterialColor orange =
      MaterialColor(_orangePrimaryValue, <int, Color>{
    50: Color(0xFFFBF0E8),
    100: Color(0xFFF5DAC7),
    200: Color(0xFFEFC2A1),
    300: Color(0xFFE9AA7B),
    400: Color(0xFFE4975F),
    500: Color(_orangePrimaryValue),
    600: Color(0xFFDB7D3D),
    700: Color(0xFFD77234),
    800: Color(0xFFD2682C),
    900: Color(0xFFCA551E),
  });
  static const int _orangePrimaryValue = 0xFFDF8543;

  static const MaterialColor orangeAccent =
      MaterialColor(_orangeAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_orangeAccentValue),
    400: Color(0xFFFFB89B),
    700: Color(0xFFFFA681),
  });
  static const int _orangeAccentValue = 0xFFFFDCCE;

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
