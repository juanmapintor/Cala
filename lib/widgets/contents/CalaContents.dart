import 'package:cala/widgets/configs/CalaColors.dart';
import 'package:cala/widgets/configs/CalaFonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CalaContents {
  // Widgets comunes que tienen varios usos
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

  // Tipografia para titulos, cuerpo, etc.
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

// Items para Catalogo, Historial y Hoy (MainPage)
  static Widget itemCuantificado(
      {String horario: '',
      required String nombre,
      required String cantidad,
      required String calorias,
      required String carbohidratos,
      required String proteinas,
      required String grasas,
      required void Function()? onPressedDelete}) {
    return Slidable(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: CalaColors.grey[300]!,
                width: 0.8,
                style: BorderStyle.solid),
          ),
        ),
        child: Center(
          child: ListTile(
            leading: Container(
              height: 33,
              width: 75,
              decoration: BoxDecoration(
                color: CalaColors.orange,
                borderRadius: BorderRadius.all(
                  Radius.circular(33),
                ),
              ),
              child: Center(
                child:
                    CalaContents.overline(text: '$calorias kcal.', light: true),
              ),
            ),
            title: CalaContents.subtitle1(text: nombre),
            subtitle: horario.isNotEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CalaContents.caption(text: 'Horario: $horario'),
                      CalaContents.caption(text: 'Cantidad: $cantidad')
                    ],
                  )
                : CalaContents.caption(text: 'Cantidad: $cantidad'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CalaContents.overline(text: 'H.'),
                    CalaContents.body2(text: '$carbohidratos'),
                    CalaContents.caption(text: 'gr.')
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CalaContents.overline(text: 'P.'),
                    CalaContents.body2(text: '$proteinas'),
                    CalaContents.caption(text: 'gr.')
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CalaContents.overline(text: 'G.'),
                    CalaContents.body2(text: '$grasas'),
                    CalaContents.caption(text: 'gr.')
                  ],
                ),
                SizedBox(
                  width: 8,
                ),
                Icon(Icons.chevron_left_rounded)
              ],
            ),
          ),
        ),
      ),
      actionPane: SlidableScrollActionPane(),
      secondaryActions: [
        Container(
          color: CalaColors.red,
          child: Center(
            child: TextButton(
              onPressed: onPressedDelete,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete,
                    color: CalaColors.white,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CalaContents.button(text: 'Eliminar', light: true),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
