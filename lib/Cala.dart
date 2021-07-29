import 'package:cala/widgets/CalaWait.dart';
import 'package:flutter/material.dart';

import 'package:cala/helpers/DBHelper.dart';

import 'package:cala/widgets/CalaMainPage.dart';
import 'package:cala/widgets/CalaHistorial.dart';
import 'package:cala/widgets/CalaAgregar.dart';
import 'package:cala/widgets/CalaCatalogo.dart';
import 'package:cala/widgets/CalaObjetivos.dart';
import 'package:cala/widgets/CalaProgreso.dart';
import 'package:flutter/services.dart';
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

  late CalaWait espera;

  var _ready = false;

  _CalaState() {
    dbHelper = DBHelper();

    dbHelper.createDB().then((value) {
      setState(() {
        _ready = value;
      });
    });

    mainPage = CalaMainPage(dbHelper);
    historialPage = CalaHistorial(dbHelper);
    catalogoPage = CalaCatalogo(dbHelper);
    progresoPage = CalaProgreso(dbHelper);
    objetivosPage = CalaObjetivos(dbHelper);

    espera = CalaWait();

    agregarComida = CalaAgregar(dbHelper, true);
    agregarIngesta = CalaAgregar(dbHelper, false);
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Cala',
      routes: {
        '/': (context) => _ready ? mainPage : espera,
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
