import 'dart:math';

import 'package:cala/helpers/DBHelper.dart';
import 'package:cala/helpers/Tuple.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:cala/widgets/configs/CalaColors.dart';
import 'package:intl/intl.dart';

import 'configs/CalaIcons.dart';

class CalaProgreso extends StatefulWidget {
  final DBHelper _dbHelper;

  CalaProgreso(this._dbHelper);
  @override
  _CalaProgresoState createState() => _CalaProgresoState(_dbHelper);
}

class _CalaProgresoState extends State<CalaProgreso> {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  final DBHelper _dbHelper;
  var _load = true;

  late List<Tuple<double, DateTime>> _dataPeso;
  late List<Tuple<double, DateTime>> _dataGrasa;
  late List<Tuple<double, DateTime>> _dataIMC;

  late List<double> _objetivos;

  _CalaProgresoState(this._dbHelper) {
    update(true);
    _dbHelper.broadcastStream.listen((msg) {
      if (msg == 'updProg') update(false);
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget loading = new Align(
      child: new Container(
        width: 70.0,
        height: 70.0,
        child: new Padding(
            padding: const EdgeInsets.all(5.0),
            child: new Center(child: new CircularProgressIndicator())),
      ),
      alignment: FractionalOffset.center,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Progreso'),
        backgroundColor: CalaColors.mainTealColor,
      ),
      body: _load
          ? loading
          : ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Peso',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ),
                getGraph(_dataPeso,
                    minX: 0,
                    maxX: daysBetween(_dataPeso.first.s, _dataPeso.last.s)
                        .toDouble(),
                    minY: _objetivos[0] - 5,
                    maxY: getMax(_dataPeso) + 5),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '% Grasa',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ),
                getGraph(
                  _dataGrasa,
                  minX: 0,
                  maxX: daysBetween(_dataGrasa.first.s, _dataGrasa.last.s)
                      .toDouble(),
                  minY: 0,
                  maxY: 100,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'IMC',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ),
                getGraph(
                  _dataIMC,
                  minX: 0,
                  maxX: daysBetween(_dataGrasa.first.s, _dataGrasa.last.s)
                      .toDouble(),
                  minY: 20,
                  maxY: 100,
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddOBG();
        },
        child: CalaIcons.addIcon,
        backgroundColor: Colors.green,
      ),
    );
  }

  void update(bool constructor) async {
    if (!constructor) {
      setState(() {
        _load = true;
      });
    }

    _dataPeso = await _dbHelper.getPesos(30);
    _dataGrasa = await _dbHelper.getPorcentajesGrasa(30);
    _dataIMC = await _dbHelper.getIMCs(30);

    _objetivos = await _dbHelper.getLatestObjetivosGral();

    setState(() {
      _load = false;
    });
  }

  void showAddOBG() {
    var pesoCtl = TextEditingController();
    var grasCtl = TextEditingController();
    var formKey = GlobalKey<FormState>();
    var form = new Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Peso',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: pesoCtl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? 'Ingrese un peso'
                        : null;
                  },
                ),
              ),
              Text(
                'kg.',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Grasa corporal',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: grasCtl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return (value == null ||
                            value.isEmpty ||
                            double.parse(value) > 100)
                        ? 'Ingrese porcentaje de grasa'
                        : null;
                  },
                ),
              ),
              Text(
                '%',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          )
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("Nuevo pesaje."),
        content: form,
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                var peso = double.parse(pesoCtl.text);
                var gras = double.parse(grasCtl.text);
                showWaiting('Agregando...');
                var success = await _dbHelper.addPesaje(peso, gras);
                if (success) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  showInfoDiag('Agregado correctamente!');
                } else {
                  Navigator.of(context).pop();
                  showInfoDiag('No se pudo agregar.');
                }
              }
            },
          ),
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void showInfoDiag(String msg) {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Info'),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void showWaiting(String msg) {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Espere...'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              child: new Container(
                width: 70.0,
                height: 70.0,
                child: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Center(child: new CircularProgressIndicator())),
              ),
              alignment: FractionalOffset.center,
            ),
            Text(msg),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  double getMax(List<Tuple<double, DateTime>> list) =>
      list.map((e) => e.r).toList().reduce(max);

  List<FlSpot> getSpots(List<Tuple<double, DateTime>> list) {
    DateTime initial = list[0].s;
    List<FlSpot> listSpot = [];
    for (var data in list) {
      var days = daysBetween(initial, data.s).toDouble();
      var datar = data.r;
      print('spot: ($days, $datar)');
      listSpot.add(FlSpot(days, datar));
    }
    return listSpot;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  getTitleData(List<Tuple<double, DateTime>> list) => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          rotateAngle: -60,
          showTitles: true,
          reservedSize: 35,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          getTitles: (value) {
            DateTime initial = list[0].s;
            for (var data in list) {
              var days = daysBetween(initial, data.s).toDouble();
              if ((value - days) == 0)
                return DateFormat('dd-MM').format(data.s);
            }
            return '';
          },
          margin: 5,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          getTitles: (value) {
            return (value % 5) == 0 ? value.toString() : '';
          },
          margin: 5,
        ),
      );

  Widget getGraph(List<Tuple<double, DateTime>> _data,
      {required double minX,
      required double maxX,
      required double minY,
      required double maxY}) {
    return Container(
      height: 350,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: LineChart(
          LineChartData(
            minX: minX,
            maxX: maxX,
            minY: minY,
            maxY: maxY,
            titlesData: getTitleData(_data),
            gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (value) {
                return (value % 5) == 0
                    ? FlLine(
                        color: Colors.grey[400],
                        strokeWidth: 1,
                      )
                    : FlLine(
                        strokeWidth: 0,
                      );
              },
              drawVerticalLine: true,
              getDrawingVerticalLine: (value) {
                var initial = _data[0].s;
                for (var data in _data) {
                  var days = daysBetween(initial, data.s).toDouble();
                  if (value == days)
                    return FlLine(
                      color: Colors.grey[400],
                      strokeWidth: 1,
                    );
                }
                return FlLine(strokeWidth: 0);
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                  left: BorderSide(color: const Color(0xff37434d), width: 1),
                  bottom: BorderSide(color: const Color(0xff37434d), width: 1)),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: getSpots(_data),
                isCurved: true,
                colors: gradientColors,
                barWidth: 5,
                belowBarData: BarAreaData(
                  show: true,
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
