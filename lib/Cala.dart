import 'package:flutter/material.dart';

import 'package:cala/helpers/DBHelper.dart';

import 'package:cala/widgets/CalaMainPage.dart';
import 'package:cala/widgets/CalaHistorial.dart';
import 'package:cala/widgets/CalaAgregar.dart';
import 'package:cala/widgets/CalaCatalogo.dart';
import 'package:cala/widgets/CalaObjetivos.dart';
import 'package:cala/widgets/CalaProgreso.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Cala extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalaState();
  }
}

class _CalaState extends State<Cala> {
  late DBHelper dbHelper;

  late CalaMainPage mainPage;
  late CalaHistorial historialPage;
  late CalaCatalogo catalogoPage;
  late CalaProgreso progresoPage;
  late CalaObjetivos objetivosPage;

  late CalaAgregar agregarComida;
  late CalaAgregar agregarIngesta;

  _CalaState() {
    dbHelper = DBHelper();

    mainPage = CalaMainPage(dbHelper);
    historialPage = CalaHistorial(dbHelper);
    catalogoPage = CalaCatalogo(dbHelper);
    progresoPage = CalaProgreso(dbHelper);
    objetivosPage = CalaObjetivos(dbHelper);

    agregarComida = CalaAgregar(dbHelper, true);
    agregarIngesta = CalaAgregar(dbHelper, false);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cala',
      routes: {
        '/': (context) => mainPage,
        '/historial': (context) => historialPage,
        '/catalogo': (context) => catalogoPage,
        '/progreso': (context) => progresoPage,
        '/objetivos': (context) => objetivosPage,
        '/agregarComida': (context) => agregarComida,
        '/agregarIngesta': (context) => agregarIngesta,
      },
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [
        const Locale('en'),
        const Locale('fr'),
        const Locale('es'),
      ],
    );
  }
}
