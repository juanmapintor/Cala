import 'package:cala/helpers/IngestaHistorial.dart';
import 'package:cala/helpers/DBHelper.dart';
import 'package:flutter/material.dart';

import 'package:cala/widgets/configs/CalaColors.dart';
import 'package:intl/intl.dart';

import 'configs/CalaIcons.dart';
import 'contents/TableContents.dart';

class CalaHistorial extends StatefulWidget {
  final DBHelper _dbHelper;
  CalaHistorial(this._dbHelper);
  @override
  _CalaHistorialState createState() => _CalaHistorialState(_dbHelper);
}

class _CalaHistorialState extends State<CalaHistorial> {
  final DBHelper _dbHelper;
  var _gotten = false;
  var _load = false;

  var _totCals = 0.0;
  var _totCarb = 0.0;
  var _totProt = 0.0;
  var _totGras = 0.0;

  var _selectedFecha = 'Seleccione una fecha...';
  late List<IngestaHistorial> _ingestas;

  _CalaHistorialState(this._dbHelper);
  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            color: CalaColors.grey[200],
            width: 70.0,
            height: 70.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          )
        : new Container();

    ListView lista = ListView(
      children: [
        new Align(
          child: loadingIndicator,
          alignment: FractionalOffset.center,
        ),
        _gotten
            ? Column(
                children: _ingestas
                    .map((ingesta) => makeFoodShower(ingesta))
                    .toList())
            : Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'Nada que mostrar...',
                    style: TextStyle(
                      color: CalaColors.grey[500],
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Historial'),
        backgroundColor: CalaColors.mainTealColor,
      ),
      backgroundColor: CalaColors.grey[200],
      body: Column(
        children: [
          Expanded(child: lista),
          Container(
              color: CalaColors.teal[400],
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      _load ? 'Obteniendo comidas' : 'Totales: $_selectedFecha',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: CalaColors.white),
                    ),
                  ),
                  _gotten
                      ? Column(
                          children: [
                            TableContents.makeInfoRow(
                                'Calorias', _totCals, CalaColors.teal),
                            TableContents.makeInfoRow(
                                'Carbohidratos', _totCarb, CalaColors.teal),
                            TableContents.makeInfoRow(
                                'Proteinas', _totProt, CalaColors.teal),
                            TableContents.makeInfoRow(
                                'Grasas', _totGras, CalaColors.teal),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              'Nada que mostrar...',
                              style: TextStyle(
                                color: CalaColors.grey[300],
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                ],
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getIngestas(context);
        },
        child: CalaIcons.histIcon,
        backgroundColor: CalaColors.blueGrey,
      ),
    );
  }

  Container makeFoodShower(IngestaHistorial ingesta) {
    return Container(
      padding: EdgeInsets.only(left: 5, top: 5, right: 5),
      child: Column(
        children: [
          TableContents.makeTableRow(
              true, ['Horario', 'Nombre', 'Cantidad'], CalaColors.orange),
          TableContents.makeTableRow(
              false,
              [
                ingesta.horario,
                ingesta.nombre,
                ingesta.cant.toStringAsFixed(2)
              ],
              CalaColors.orange),
          TableContents.makeInfoRow(
              'Calorias: ', ingesta.cals, CalaColors.orange),
          TableContents.makeInfoRow(
              'Proteinas: ', ingesta.prot, CalaColors.orange),
          TableContents.makeInfoRow(
              'Carbohidratos: ', ingesta.carb, CalaColors.orange),
          TableContents.makeInfoRow(
              'Grasas: ', ingesta.gras, CalaColors.orange),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  _gotten = false;
                  _load = true;
                });
                await _dbHelper.deleteIngesta(ingesta.id);
                await update();
              },
              child: Icon(Icons.delete, color: CalaColors.white),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                primary: CalaColors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getIngestas(BuildContext context) async {
    var pickedFecha = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());

    final DateFormat formatter = DateFormat('dd-MM-yyyy');

    setState(() {
      _selectedFecha = formatter.format(pickedFecha!);
    });

    await update();
  }

  Future<void> update() async {
    setState(() {
      _gotten = false;
      _load = true;
    });
    _ingestas = await _dbHelper.getIngestas(_selectedFecha);
    updateTotals(_ingestas);

    setState(() {
      _load = false;
      _gotten = _ingestas.isNotEmpty;
    });
  }

  void updateTotals(List<IngestaHistorial> ingestas) {
    _totCals = _totCarb = _totProt = _totGras = 0.0;
    for (var ingesta in ingestas) {
      setState(() {
        _totCals += ingesta.cals;
        _totCarb += ingesta.carb;
        _totProt += ingesta.prot;
        _totGras += ingesta.gras;
      });
    }
  }
}
