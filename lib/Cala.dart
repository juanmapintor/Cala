import 'package:flutter/material.dart';

import 'package:cala/widgets/CalaMainPage.dart';
import 'package:cala/widgets/CalaHistorial.dart';

class Cala extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CalaState();
  }
}

class CalaState extends State<Cala> {
  late CalaMainPage mainPage;
  late CalaHistorial historialPage;
  CalaState() {
    mainPage = CalaMainPage();
    historialPage = CalaHistorial();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Cala', routes: {
      '/': (context) => mainPage,
      '/historial': (context) => historialPage,
      /* '/catalogo': (context) => ,
      '/progreso': (context) => ,
      '/objetivos': (context) => ,*/
    });
  }
}
