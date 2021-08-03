import 'package:cala/widgets/configs/CalaColors.dart';
import 'package:cala/widgets/configs/CalaFonts.dart';
import 'package:flutter/material.dart';

class CalaContents {
  static waitingWidget({bool light: false}) => Center(
        child: light
            ? CircularProgressIndicator(
                color: CalaColors.white,
              )
            : CircularProgressIndicator(),
      );
  static successWidget() => Center(
        child: Icon(
          Icons.check_circle,
          size: 60,
          color: CalaColors.white,
        ),
      );
  static errorWidget() => Center(
        child: Icon(
          Icons.block,
          size: 60,
          color: CalaColors.white,
        ),
      );
  static body2({required String text, bool light: false}) => Text(
        text,
        textAlign: TextAlign.justify,
        style: light
            ? CalaFonts.pacificoFontLight.bodyText2
            : CalaFonts.pacificoFontDark.bodyText2,
      );
  static body1({required String text, bool light: false}) => Text(
        text,
        textAlign: TextAlign.justify,
        style: light
            ? CalaFonts.pacificoFontLight.bodyText1
            : CalaFonts.pacificoFontDark.bodyText1,
      );
  static headline1({required String text, bool light: false}) => Text(
        text,
        style: light
            ? CalaFonts.pacificoFontLight.headline1
            : CalaFonts.pacificoFontDark.headline1,
      );
  static headline2({required String text, bool light: false}) => Text(
        text,
        style: light
            ? CalaFonts.pacificoFontLight.headline2
            : CalaFonts.pacificoFontDark.headline2,
      );
  static headline3({required String text, bool light: false}) => Text(
        text,
        style: light
            ? CalaFonts.pacificoFontLight.headline3
            : CalaFonts.pacificoFontDark.headline3,
      );
  static headline4({required String text, bool light: false}) => Text(
        text,
        style: light
            ? CalaFonts.pacificoFontLight.headline4
            : CalaFonts.pacificoFontDark.headline4,
      );
  static headline5({required String text, bool light: false}) => Text(
        text,
        style: light
            ? CalaFonts.pacificoFontLight.headline5
            : CalaFonts.pacificoFontDark.headline5,
      );
  static headline6({required String text, bool light: false}) => Text(
        text,
        style: light
            ? CalaFonts.pacificoFontLight.headline6
            : CalaFonts.pacificoFontDark.headline6,
      );
  static subtitle1({required String text, bool light: false}) => Text(
        text,
        textAlign: TextAlign.left,
        style: light
            ? CalaFonts.pacificoFontLight.subtitle1
            : CalaFonts.pacificoFontDark.subtitle1,
      );
  static subtitle2({required String text, bool light: false}) => Text(
        text,
        textAlign: TextAlign.left,
        style: light
            ? CalaFonts.pacificoFontLight.subtitle2
            : CalaFonts.pacificoFontDark.subtitle2,
      );
  static button({required String text, bool light: false}) => Text(
        text.toUpperCase(),
        textAlign: TextAlign.left,
        style: light
            ? CalaFonts.pacificoFontLight.button
            : CalaFonts.pacificoFontDark.button,
      );
  static caption({required String text, bool light: false}) => Text(
        text,
        textAlign: TextAlign.left,
        style: light
            ? CalaFonts.pacificoFontLight.caption
            : CalaFonts.pacificoFontDark.caption,
      );
  static overline({required String text, bool light: false}) => Text(
        text.toUpperCase(),
        textAlign: TextAlign.left,
        style: light
            ? CalaFonts.pacificoFontLight.overline
            : CalaFonts.pacificoFontDark.overline,
      );
}
