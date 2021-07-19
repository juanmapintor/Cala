import 'package:cala/helpers/DBHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import 'package:cala/widgets/configs/CalaColors.dart';
import 'package:pie_chart/pie_chart.dart';

class MainPageContent extends StatefulWidget {
  final DBHelper dbHelper;
  MainPageContent(this.dbHelper);
  @override
  _MainPageContentState createState() => _MainPageContentState(dbHelper);
}

class _MainPageContentState extends State<MainPageContent> {
  var calCVal = 500;
  var calMVal = 1000;

  var carbCVal = 500;
  var carbMVal = 1000;

  var protCVal = 500;
  var protMVal = 1000;

  var grasCVal = 500;
  var grasMVal = 1000;

  _MainPageContentState(DBHelper dbHelper) {
    dbHelper.mainPageStream.listen((event) {
      //Aca hacemos el update cuando hubieron cambios en DBHelper
      update();
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> data = new Map();
    data.addAll({
      'Carbohidratos': carbCVal.toDouble(),
      'Proteinas': protCVal.toDouble(),
      'Grasas': grasCVal.toDouble()
    });
    List<Color> _colors = [Colors.blue, Colors.orange, Colors.green];

    return Container(
      child: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Text(
            'Macros',
            style: TextStyle(
                color: CalaColors.textDark,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 150,
                  margin: EdgeInsets.all(30),
                  child: FAProgressBar(
                    maxValue: calMVal,
                    currentValue: calCVal,
                    direction: Axis.vertical,
                    verticalDirection: VerticalDirection.up,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border:
                        Border.all(color: Colors.red, style: BorderStyle.solid),
                    progressColor: Colors.red,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 150,
                  margin: EdgeInsets.all(30),
                  child: FAProgressBar(
                    maxValue: carbMVal,
                    currentValue: carbCVal,
                    direction: Axis.vertical,
                    verticalDirection: VerticalDirection.up,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(
                        color: Colors.blue, style: BorderStyle.solid),
                    progressColor: Colors.blue,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 150,
                  margin: EdgeInsets.all(30),
                  child: FAProgressBar(
                    maxValue: protMVal,
                    currentValue: protCVal,
                    direction: Axis.vertical,
                    verticalDirection: VerticalDirection.up,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(
                        color: Colors.orange, style: BorderStyle.solid),
                    progressColor: Colors.orange,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 150,
                  margin: EdgeInsets.all(30),
                  child: FAProgressBar(
                    maxValue: grasMVal,
                    currentValue: grasCVal,
                    direction: Axis.vertical,
                    verticalDirection: VerticalDirection.up,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(
                        color: Colors.green, style: BorderStyle.solid),
                    progressColor: Colors.green,
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
                      '$calCVal',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: calCVal < calMVal
                            ? CalaColors.textDarker
                            : Colors.red,
                      ),
                    ),
                    Text('/$calMVal' + 'kcal'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '$carbCVal',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: carbCVal < carbMVal
                            ? CalaColors.textDarker
                            : Colors.red,
                      ),
                    ),
                    Text('/$carbMVal' + 'gr'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '$protCVal',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: protCVal < protMVal
                            ? CalaColors.textDarker
                            : Colors.red,
                      ),
                    ),
                    Text('/$protMVal' + 'gr'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '$grasCVal',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: grasCVal < grasMVal
                            ? CalaColors.textDarker
                            : Colors.red,
                      ),
                    ),
                    Text('/$grasMVal' + 'gr'),
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
                fontWeight: FontWeight.bold),
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
              chartRadius: MediaQuery.of(context).size.width / 2,
              chartValuesOptions: ChartValuesOptions(
                  decimalPlaces: 2,
                  showChartValuesInPercentage: true,
                  chartValueBackgroundColor: Colors.transparent,
                  chartValueStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              legendOptions: LegendOptions(
                showLegendsInRow: true,
                legendPosition: LegendPosition.bottom,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void update() {
    print('Actualizado MainPageContent');
  }
}
