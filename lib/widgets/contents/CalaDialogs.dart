// Configs
import 'package:cala/widgets/configs/CalaColors.dart';
// Contents
import 'package:cala/widgets/contents/CalaContents.dart';
// Dependencies
import 'package:flutter/material.dart';

/*
En esta clase se agruparan todos los mensajes que se puedan mostrar como pop-up 
durante la ejecucion de la aplicacion.

En principio contendra dialogos para:
  - Mensaje
  - Espera
  - Exito
  - Error
 */

class CalaDialogs {
  static void showInfoDiag(
      {required BuildContext context, required String message}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: CalaContents.headline5(text: 'Información'),
        content: CalaContents.body2(text: message),
        actions: <Widget>[
          TextButton(
            child: CalaContents.button(text: 'OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  static void showWaitingDiag(
      {required BuildContext context, required String message}) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Center(
          child: CalaContents.headline5(text: 'Espere...'),
        ),
        content: Container(
          width: 150,
          height: 150,
          child: Column(
            children: [
              Expanded(
                child: CalaContents.waitingWidget(),
              ),
              message != ''
                  ? Expanded(
                      child: Center(
                        child: CalaContents.body2(text: message),
                      ),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> showSuccessDiag(
      {required BuildContext context, int duration: 1000}) async {
    await showDialog(
      context: context,
      builder: (_) {
        Future.delayed(Duration(milliseconds: duration), () {
          Navigator.pop(context);
        });
        return AlertDialog(
          backgroundColor: CalaColors.green[700],
          title: Center(
            child: CalaContents.headline5(text: 'Éxito!', light: true),
          ),
          content: Container(
            height: 170,
            child: CalaContents.successWidget(),
          ),
        );
      },
    );
  }

  static void showFailDiag(
      {required BuildContext context,
      int duration: 1000,
      required String errorMessage,
      required Function onAccept}) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: CalaColors.red[700],
          title: Center(
            child: CalaContents.headline5(text: 'Error!', light: true),
          ),
          content: Container(
            width: 150,
            height: 150,
            child: Column(
              children: [
                Expanded(
                  child: CalaContents.errorWidget(),
                ),
                errorMessage != ''
                    ? Expanded(
                        child: Center(
                          child: CalaContents.body1(
                              text: errorMessage, light: true),
                        ),
                      )
                    : Container(
                        width: 0,
                        height: 0,
                      ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => onAccept(),
                child: CalaContents.button(text: 'Aceptar', light: true))
          ],
        );
      },
    );
  }
}
