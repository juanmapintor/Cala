import 'package:cala/widgets/CalaAgregar.dart';
import 'package:cala/widgets/CalaWelcome.dart';
import 'package:flutter/material.dart';

import 'package:cala/helpers/DBHelper.dart';

import 'package:cala/widgets/CalaMainPage.dart';
import 'package:cala/widgets/CalaHistorial.dart';
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
  late DBHelper _dbHelper;

  late CalaWelcome _welcomePage;
  late CalaMainPage _mainPage;
  late CalaHistorial _historialPage;
  late CalaCatalogo _catalogoPage;
  late CalaProgreso _progresoPage;
  late CalaObjetivos _objetivosPage;
  late CalaAgregar _agregar;
  late CalaAgregar _agregar2;

  var _created = false;

  _CalaState() {
    _dbHelper = DBHelper();

    _dbHelper.createDB().then((value) {
      _created = value;
    });

    _welcomePage = CalaWelcome();
    _mainPage = CalaMainPage(_dbHelper);
    _historialPage = CalaHistorial(_dbHelper);
    _catalogoPage = CalaCatalogo(_dbHelper);
    _progresoPage = CalaProgreso(_dbHelper);
    _objetivosPage = CalaObjetivos(_dbHelper);

    _agregar = CalaAgregar(_dbHelper, false);
    _agregar2 = CalaAgregar(_dbHelper, true);
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
        '/': (context) => _created ? _mainPage : _welcomePage,
        '/historial': (context) => _historialPage,
        '/catalogo': (context) => _catalogoPage,
        '/progreso': (context) => _progresoPage,
        '/objetivos': (context) => _objetivosPage,
        '/agregarIngesta': (context) => _agregar,
        '/agregarComida': (context) => _agregar2,
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
