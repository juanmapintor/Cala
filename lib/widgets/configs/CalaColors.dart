import 'package:flutter/material.dart';

class CalaColors {
  static const mainTealColor = Color(0xff23b6e6);
  static const secondaryTealColor = Color(0xff02d39a);
  static const mainOrangeColor = Color(0xffe68723);
  static const secondaryOrangeColor = Color(0xffd34a02);

  static const textDarker = Color(0xFF000000);
  static const textDark = Color(0xFF000000);
  static const textLighter = Color(0xFFFFFFFF);
  static const textLight = Color(0xFFFFFFFF);

  static const MaterialColor teal =
      MaterialColor(_tealPrimaryValue, <int, Color>{
    50: Color(0xFFE5F6FC),
    100: Color(0xFFBDE9F8),
    200: Color(0xFF91DBF3),
    300: Color(0xFF65CCEE),
    400: Color(0xFF44C1EA),
    500: Color(_tealPrimaryValue),
    600: Color(0xFF1FAFE3),
    700: Color(0xFF1AA6DF),
    800: Color(0xFF159EDB),
    900: Color(0xFF0C8ED5),
  });
  static const int _tealPrimaryValue = 0xFF23B6E6;

  static const MaterialColor tealAccent =
      MaterialColor(_tealAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_tealAccentValue),
    400: Color(0xFF9AD8FF),
    700: Color(0xFF80CEFF),
  });
  static const int _tealAccentValue = 0xFFCDECFF;

  static const MaterialColor orange =
      MaterialColor(_orangePrimaryValue, <int, Color>{
    50: Color(0xFFFCF1E5),
    100: Color(0xFFF8DBBD),
    200: Color(0xFFF3C391),
    300: Color(0xFFEEAB65),
    400: Color(0xFFEA9944),
    500: Color(_orangePrimaryValue),
    600: Color(0xFFE37F1F),
    700: Color(0xFFDF741A),
    800: Color(0xFFDB6A15),
    900: Color(0xFFD5570C),
  });
  static const int _orangePrimaryValue = 0xFFE68723;

  static const MaterialColor orangeAccent =
      MaterialColor(_orangeAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_orangeAccentValue),
    400: Color(0xFFFFBB9A),
    700: Color(0xFFFFAA80),
  });
  static const int _orangeAccentValue = 0xFFFFDDCD;

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

  static const List<Color> tealGradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  static const List<Color> orangeGradientColors = [
    const Color(0xffe68723),
    const Color(0xffd34a02),
  ];

  static const grey = Colors.grey;
  static const green = Colors.green;
  static const white = Colors.white;
  static const red = Colors.red;
  static const blueGrey = Colors.blueGrey;
  static const transparent = Colors.transparent;
  static const blue = Colors.blue;
  static const black = Colors.black;
}
