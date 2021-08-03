/*

import 'package:cala/helpers/DBHelper.dart';
import 'package:cala/helpers/datamodel/ObjetosNutricionales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:cala/widgets/configs/CalaColors.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

import 'TableContents.dart';

class MainPageContent extends StatefulWidget {
  final DBHelper _dbHelper;
  MainPageContent(this._dbHelper);
  @override
  _MainPageContentState createState() => _MainPageContentState(_dbHelper);
}

class _MainPageContentState extends State<MainPageContent> {
  var _calCVal = 500;
  var _calMVal = 1000;

  var _carbCVal = 500;
  var _carbMVal = 1000;

  var _protCVal = 500;
  var _protMVal = 1000;

  var _grasCVal = 500;
  var _grasMVal = 1000;

  var _load = true;
  var _gotten = false;
  var _objSetten = false;

  late DBHelper _dbHelper;

  late List<Ingesta> _ingestas;

  _MainPageContentState(this._dbHelper) {
    update(true);
    _dbHelper.broadcastStream.listen((event) {
      if (event == 'updMain' && mounted) update(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> data = new Map();
    data.addAll({
      'Carbohidratos': _carbCVal.toDouble(),
      'Proteinas': _protCVal.toDouble(),
      'Grasas': _grasCVal.toDouble()
    });
    List<Color> _colors = [
      CalaColors.blue,
      CalaColors.orange,
      CalaColors.green
    ];
    Widget loadingIndicator = _load
        ? new Container(
            width: 70.0,
            height: 70.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          )
        : new Container();

    return !_objSetten
        ? Container(
            padding: EdgeInsets.all(30),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Comience agregando un objetivo en la pestaña objetivos',
                    style: TextStyle(
                      color: CalaColors.grey[500],
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  new Align(
                    child: loadingIndicator,
                    alignment: FractionalOffset.center,
                  ),
                ],
              ),
            ),
          )
        : Container(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                new Align(
                  child: loadingIndicator,
                  alignment: FractionalOffset.center,
                ),
                _gotten
                    ? Column(
                        children: [
                          Text(
                            'Macros',
                            style: TextStyle(
                                color: CalaColors.textDark,
                                fontSize: 25,
                                fontWeight: FontWeight.w300),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 200,
                                  margin: EdgeInsets.all(30),
                                  child: FAProgressBar(
                                    maxValue: _calMVal,
                                    currentValue: _calCVal,
                                    direction: Axis.vertical,
                                    verticalDirection: VerticalDirection.up,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(
                                        color: CalaColors.red,
                                        style: BorderStyle.solid),
                                    progressColor: CalaColors.red,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 200,
                                  margin: EdgeInsets.all(30),
                                  child: FAProgressBar(
                                    maxValue: _carbMVal,
                                    currentValue: _carbCVal,
                                    direction: Axis.vertical,
                                    verticalDirection: VerticalDirection.up,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(
                                        color: CalaColors.blue,
                                        style: BorderStyle.solid),
                                    progressColor: CalaColors.blue,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 200,
                                  margin: EdgeInsets.all(30),
                                  child: FAProgressBar(
                                    maxValue: _protMVal,
                                    currentValue: _protCVal,
                                    direction: Axis.vertical,
                                    verticalDirection: VerticalDirection.up,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(
                                        color: CalaColors.orange,
                                        style: BorderStyle.solid),
                                    progressColor: CalaColors.orange,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 200,
                                  margin: EdgeInsets.all(30),
                                  child: FAProgressBar(
                                    maxValue: _grasMVal,
                                    currentValue: _grasCVal,
                                    direction: Axis.vertical,
                                    verticalDirection: VerticalDirection.up,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(
                                        color: CalaColors.green,
                                        style: BorderStyle.solid),
                                    progressColor: CalaColors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Calorias',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Carbohidratos',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Proteinas',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Grasas',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '$_calCVal',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: _calCVal < _calMVal
                                            ? CalaColors.textDarker
                                            : CalaColors.red,
                                      ),
                                    ),
                                    Text('/$_calMVal' + 'kcal'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '$_carbCVal',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: _carbCVal < _carbMVal
                                            ? CalaColors.textDarker
                                            : CalaColors.red,
                                      ),
                                    ),
                                    Text('/$_carbMVal' + 'gr'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '$_protCVal',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: _protCVal < _protMVal
                                            ? CalaColors.textDarker
                                            : CalaColors.red,
                                      ),
                                    ),
                                    Text('/$_protMVal' + 'gr'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '$_grasCVal',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: _grasCVal < _grasMVal
                                            ? CalaColors.textDarker
                                            : CalaColors.red,
                                      ),
                                    ),
                                    Text('/$_grasMVal' + 'gr'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 20,
                          ),
                          Text(
                            'Porcentajes',
                            style: TextStyle(
                                color: CalaColors.textDark,
                                fontSize: 25,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 15,
                          ),
                          Center(
                            child: PieChart(
                              dataMap: data,
                              colorList: _colors,
                              animationDuration: Duration(milliseconds: 1500),
                              chartLegendSpacing: 32.0,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 2,
                              chartValuesOptions: ChartValuesOptions(
                                  decimalPlaces: 2,
                                  showChartValuesInPercentage: true,
                                  chartValueBackgroundColor:
                                      CalaColors.transparent,
                                  chartValueStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              legendOptions: LegendOptions(
                                showLegendsInRow: true,
                                legendPosition: LegendPosition.bottom,
                              ),
                            ),
                          ),
                          Text(
                            'Hoy',
                            style: TextStyle(
                                color: CalaColors.textDark,
                                fontSize: 25,
                                fontWeight: FontWeight.w300),
                          ),
                          CarouselSlider(
                            items: _ingestas
                                .map((ingesta) => makeFoodShower(ingesta))
                                .toList(),
                            options: CarouselOptions(
                              height: 300,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        ],
                      )
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
            ),
          );
  }

  void update(bool constructor) {
    if (!constructor) {
      setState(() {
        _gotten = false;
        _load = true;
      });
    }
    _calCVal = _carbCVal = _protCVal = _grasCVal = 0;
    _dbHelper.getObjetivoDiario().then((objetivo) {
      _calMVal = objetivo.calorias.toInt();
      _carbMVal = objetivo.carbohidratos.toInt();
      _protMVal = objetivo.proteinas.toInt();
      _grasMVal = objetivo.grasas.toInt();
      _dbHelper
          .getListaIngestas(DateFormat('dd-MM-yyyy').format(DateTime.now()))
          .then((ingestasHoy) {
        for (var ingesta in ingestasHoy) {
          _calCVal += ingesta.calorias.toInt();
          _carbCVal += ingesta.carbohidratos.toInt();
          _protCVal += ingesta.proteinas.toInt();
          _grasCVal += ingesta.grasas.toInt();
        }
        _ingestas = ingestasHoy;

        setState(() {
          if (_calMVal != 0) _objSetten = true;
          _load = false;
          _gotten = ingestasHoy.isNotEmpty;
        });
      });
    });
  }

  Container makeFoodShower(Ingesta ingesta) {
    return Container(
      padding: EdgeInsets.only(left: 5, top: 5, right: 5),
      child: Column(
        children: [
          TableContents.makeTableRow(
              true, ['Horario', 'Nombre', 'Cantidad'], CalaColors.teal),
          TableContents.makeTableRow(
              false,
              [
                ingesta.hora,
                ingesta.nombre,
                ingesta.cantidadIngesta.toStringAsFixed(2)
              ],
              CalaColors.teal),
          TableContents.makeInfoRow(
              'Calorias: ', ingesta.calorias, CalaColors.teal),
          TableContents.makeInfoRow(
              'Proteinas: ', ingesta.proteinas, CalaColors.teal),
          TableContents.makeInfoRow(
              'Carbohidratos: ', ingesta.carbohidratos, CalaColors.teal),
          TableContents.makeInfoRow(
              'Grasas: ', ingesta.grasas, CalaColors.teal),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  _gotten = false;
                  _load = true;
                });
                await _dbHelper.deleteIngesta(ingesta.id);
                update(false);
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
}
*/
