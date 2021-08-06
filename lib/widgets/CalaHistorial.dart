import 'package:cala/helpers/DBHelper.dart';
import 'package:cala/helpers/FormatHelper.dart';
import 'package:cala/helpers/datamodel/ObjetosNutricionales.dart';
import 'package:cala/widgets/contents/CalaContents.dart';
import 'package:cala/widgets/contents/CalaDialogs.dart';
import 'package:flutter/material.dart';

import 'package:cala/widgets/configs/CalaColors.dart';

class CalaHistorial extends StatefulWidget {
  final DBHelper _dbHelper;
  CalaHistorial(this._dbHelper);
  @override
  _CalaHistorialState createState() => _CalaHistorialState(_dbHelper);
}

class _CalaHistorialState extends State<CalaHistorial> {
  final DBHelper _dbHelper;

  var _loadState = 0;

  var _selectedFecha = 'Seleccione una fecha...';

  List<Ingesta> _listaIngestas = [];

  UnidadNutricional _totales =
      UnidadNutricional(calorias: 0, carbohidratos: 0, proteinas: 0, grasas: 0);

  _CalaHistorialState(this._dbHelper);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            CalaContents.headline5(text: 'Historial de comidas', light: true),
        backgroundColor: CalaColors.mainTealColor,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.calendar_today),
        onPressed: () {
          _seleccionarFecha();
        },
      ),
      body: _mainBody(),
    );
  }

  Widget _mainBody() {
    var _mainList = ListView(
      children: _listaIngestas
          .map((ingesta) => CalaContents.itemCuantificado(
              horario: ingesta.hora,
              nombre: ingesta.nombre,
              cantidad: ingesta.cantidadIngesta.toStringAsFixed(0),
              calorias: ingesta.calorias.toStringAsFixed(0),
              carbohidratos: ingesta.carbohidratos.toStringAsFixed(0),
              proteinas: ingesta.proteinas.toStringAsFixed(0),
              grasas: ingesta.grasas.toStringAsFixed(0),
              onPressedDelete: () {
                _deleteIngesta(ingesta.id);
              }))
          .toList(),
    );
    Widget _statedWidget(int state) {
      switch (state) {
        case 0:
          return Center(
            child: CalaContents.body1(text: 'Nada que mostrar.'),
          );
        case 1:
          return Center(child: CalaContents.waitingWidget());
        case 2:
        default:
          return _mainList;
      }
    }

    return Container(
      child: Column(
        children: [
          Expanded(
            child: _statedWidget(_loadState),
          ),
          Container(
              padding: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: CalaColors.orange[800],
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CalaContents.subtitle2(
                                text: 'Calorias', light: true),
                            SizedBox(
                              height: 5,
                            ),
                            CalaContents.body1(
                              text: _totales.calorias.toStringAsFixed(2),
                              light: true,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CalaContents.caption(
                              text: 'kcal.',
                              light: true,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CalaContents.subtitle2(
                              text: 'Hidratos',
                              light: true,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CalaContents.body1(
                              text: _totales.carbohidratos.toStringAsFixed(2),
                              light: true,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CalaContents.caption(
                              text: 'gr.',
                              light: true,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CalaContents.subtitle2(
                              text: 'Proteinas',
                              light: true,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CalaContents.body1(
                              text: _totales.proteinas.toStringAsFixed(2),
                              light: true,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CalaContents.caption(
                              text: 'gr.',
                              light: true,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CalaContents.subtitle2(
                              text: 'Grasas',
                              light: true,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CalaContents.body1(
                              text: _totales.grasas.toStringAsFixed(2),
                              light: true,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CalaContents.caption(
                              text: 'gr',
                              light: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: CalaColors.blueGrey[800],
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    child: CalaContents.subtitle1(
                      text: _selectedFecha,
                      light: true,
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void getLista(String fechaSeleccionada) async {
    if (mounted) {
      setState(() {
        _loadState = 1;
      });
    }
    CalaDialogs.showWaitingDiag(
        context: context, message: 'Obteniendo ingestas');

    var _listaObtenida = await _dbHelper.getListaIngestas(_selectedFecha);
    var _totalesObtenidos = UnidadNutricional(
        calorias: 0, carbohidratos: 0, proteinas: 0, grasas: 0);
    _listaObtenida.forEach((ingesta) {
      _totalesObtenidos.calorias += ingesta.calorias;
      _totalesObtenidos.carbohidratos += ingesta.carbohidratos;
      _totalesObtenidos.proteinas += ingesta.proteinas;
      _totalesObtenidos.grasas += ingesta.grasas;
    });

    Navigator.pop(context);

    if (mounted) {
      setState(() {
        if (_listaObtenida.isNotEmpty) {
          _loadState = 2;
          _listaIngestas = _listaObtenida;
          _totales = _totalesObtenidos;
        } else {
          _loadState = 0;
        }
      });
    }
  }

  void _seleccionarFecha() async {
    var dateGotten = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );

    if (mounted) {
      if (dateGotten != null) {
        setState(() {
          _selectedFecha = FormatHelper.dateTime(dateGotten);
        });
        getLista(FormatHelper.dateTime(dateGotten));
      } else {
        setState(() {
          _loadState = 0;
        });
      }
    }
  }

  void _deleteIngesta(int id) async {
    CalaDialogs.showWaitingDiag(
        context: context, message: 'Eliminando ingesta');
    var success = await _dbHelper.deleteIngesta(id);
    Navigator.pop(context);
    if (success) {
      await CalaDialogs.showSuccessDiag(context: context);
      getLista(_selectedFecha);
    } else {
      CalaDialogs.showFailDiag(
          context: context,
          errorMessage: 'No se pudo eliminar la ingesta',
          onAccept: () {
            Navigator.pop(context);
          });
    }
  }
}
