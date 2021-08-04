import 'dart:math';

import 'package:cala/helpers/DBHelper.dart';
import 'package:cala/helpers/FormatHelper.dart';
import 'package:cala/helpers/datamodel/ObjetosNutricionales.dart';
import 'package:cala/widgets/configs/CalaColors.dart';
import 'package:cala/widgets/configs/CalaFonts.dart';
import 'package:cala/widgets/configs/CalaIcons.dart';
import 'package:cala/widgets/contents/CalaContents.dart';
import 'package:cala/widgets/contents/CalaDialogs.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CalaProgreso extends StatefulWidget {
  final DBHelper _dbHelper;
  CalaProgreso(this._dbHelper);
  @override
  _CalaProgresoState createState() => _CalaProgresoState(_dbHelper);
}

class _CalaProgresoState extends State<CalaProgreso> {
  final DBHelper _dbHelper;

  List<Map<String, dynamic>> _data = [];
  late ObjetivoGeneral _objetivo;

  var _load = true;

  _CalaProgresoState(this._dbHelper) {
    update(true);
    _dbHelper.broadcastStream.listen((msg) {
      if (msg == 'updProg' && mounted) update(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CalaContents.headline5(text: 'Progreso', light: true),
        backgroundColor: CalaColors.mainTealColor,
      ),
      body: _load ? CalaContents.waitingWidget() : _carousel(),
      floatingActionButton: _floatingActionButton(),
    );
  }

  void update(bool constructor) async {
    if (!constructor) {
      setState(() {
        _load = true;
      });
    }

    _data = [];

    var _pesajes = (await _dbHelper.getPesajes(10)).reversed.toList();

    for (int i = 0; i < _pesajes.length; i++) {
      var pesaje = _pesajes[i];
      var fechaMaker = pesaje.fecha.split('-');
      var fecha = DateTime.parse(
          fechaMaker[2] + '-' + fechaMaker[1] + '-' + fechaMaker[0]);
      if (i != 0) {
        DateTime date1 = _data[0]['fecha'];
        var value = daysBetween(date1, fecha).toDouble();
        _data.add({
          'value': value,
          'fecha': fecha,
          'title': fechaMaker[0] + '/' + fechaMaker[1],
          'peso': pesaje.peso,
          'porcGrasa': pesaje.porcGrasa
        });
      } else {
        _data.add({
          'value': 0.0,
          'fecha': fecha,
          'title': fechaMaker[0] + '/' + fechaMaker[1],
          'peso': pesaje.peso,
          'porcGrasa': pesaje.porcGrasa
        });
      }
    }

    _objetivo = await _dbHelper.getObjetivoGral();

    setState(() {
      _load = false;
    });
  }

  static Widget _title(String text) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: CalaContents.headline5(
          text: text,
        ),
      ),
    );
  }

  static Widget _infoVacio() {
    return Container(
      height: 300,
      child: Center(
        child: CalaContents.body1(
          text: 'Comience agregando un pesaje',
        ),
      ),
    );
  }

  Widget _carousel() {
    _carouselCard(Widget child) => Container(
          decoration: BoxDecoration(
            color: CalaColors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(15),
          child: child,
        );
    return Container(
      color: CalaColors.grey[350],
      child: CarouselSlider(
        items: [
          _carouselCard(_paginaPeso()),
          _carouselCard(_paginaGrasa()),
        ],
        options: CarouselOptions(
          height: 700000,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          //autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget _paginaPeso() {
    return Column(
      children: [
        _title('Peso'),
        Expanded(
          child: _data.isEmpty ? _infoVacio() : _getGraph(true),
        ),
      ],
    );
  }

  Widget _paginaGrasa() {
    return Column(
      children: [
        _title('% Grasa'),
        Expanded(
          child: _data.isEmpty ? _infoVacio() : _getGraph(false),
        ),
      ],
    );
  }

  Widget _getGraph(bool peso) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(15),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: _data.last['value'],
          minY: peso
              ? (_objetivo.peso != 0 ? _objetivo.peso - 5 : 60)
              : (_objetivo.porcGrasa != 0 ? _objetivo.porcGrasa - 5 : 10),
          maxY: _max(peso) + 5,
          titlesData: _titlesData(),
          gridData: _gridData(),
          borderData: _borderData(),
          lineBarsData: [
            _lineBarData(peso),
          ],
        ),
      ),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  double _max(bool peso) {
    return _data
        .map((mapeo) {
          double pesoVal = mapeo['peso'];
          double porcGrasaVal = mapeo['porcGrasa'];
          return peso ? pesoVal : porcGrasaVal;
        })
        .toList()
        .reduce(max);
  }

  FlTitlesData _titlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        rotateAngle: -60,
        reservedSize: 35,
        showTitles: true,
        getTextStyles: (_) => CalaFonts.pacificoFontDark.subtitle2!,
        getTitles: (value) {
          for (var title in _data) {
            if (value == title['value']) return title['title'];
          }
          return '';
        },
        margin: 5,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        reservedSize: 35,
        getTextStyles: (_) => CalaFonts.pacificoFontDark.caption!,
        getTitles: (value) {
          return (value % 5) == 0 ? value.toString() : '';
        },
        margin: 5,
      ),
    );
  }

  FlGridData _gridData() {
    return FlGridData(
      show: true,
      drawHorizontalLine: true,
      getDrawingHorizontalLine: (value) {
        return (value % 5.0) == 0.0
            ? FlLine(
                color: CalaColors.grey[400],
                strokeWidth: 1,
              )
            : FlLine(
                strokeWidth: 0,
              );
      },
      drawVerticalLine: true,
      getDrawingVerticalLine: (value) {
        for (var title in _data) {
          if (value == title['value'])
            return FlLine(
              color: CalaColors.grey[400],
              strokeWidth: 1,
            );
        }
        return FlLine(strokeWidth: 0);
      },
    );
  }

  FlBorderData _borderData() {
    return FlBorderData(
      show: true,
      border: Border(
          left: BorderSide(color: const Color(0xff37434d), width: 1),
          bottom: BorderSide(color: const Color(0xff37434d), width: 1)),
    );
  }

  LineChartBarData _lineBarData(bool peso) {
    return LineChartBarData(
      spots: _spots(peso),
      isCurved: true,
      colors: CalaColors.orangeGradientColors,
      barWidth: 5,
      belowBarData: BarAreaData(
        show: true,
        colors: CalaColors.orangeGradientColors
            .map((color) => color.withOpacity(0.3))
            .toList(),
      ),
    );
  }

  List<FlSpot> _spots(bool peso) {
    return _data
        .map((mapeo) =>
            FlSpot(mapeo['value'], peso ? mapeo['peso'] : mapeo['porcGrasa']))
        .toList();
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showAddOBG();
      },
      child: CalaIcons.addIcon,
      backgroundColor: CalaColors.green,
    );
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
                child: CalaContents.subtitle2(
                  text: 'Peso',
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
              CalaContents.caption(
                text: 'kg.',
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CalaContents.subtitle2(
                  text: 'Grasa corporal',
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
              CalaContents.caption(
                text: '%',
              ),
            ],
          )
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: CalaContents.headline5(text: "Nuevo pesaje."),
        content: form,
        actions: <Widget>[
          TextButton(
            child: CalaContents.button(text: 'OK'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                var peso = double.parse(pesoCtl.text);
                var gras = double.parse(grasCtl.text);
                CalaDialogs.showWaitingDiag(
                    context: context, message: 'Agregando pesaje...');
                var success = await _dbHelper.addPesaje(Pesaje(
                    fecha: FormatHelper.today(), peso: peso, porcGrasa: gras));
                Navigator.pop(context);
                if (success) {
                  Navigator.pop(context);
                  await CalaDialogs.showSuccessDiag(context: context);
                } else {
                  Navigator.pop(context);
                  CalaDialogs.showFailDiag(
                      context: context,
                      errorMessage: 'No se pudo agregar el pesaje.',
                      onAccept: () {
                        Navigator.pop(context);
                      });
                }
              }
            },
          ),
          TextButton(
            child: CalaContents.button(text: 'Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
