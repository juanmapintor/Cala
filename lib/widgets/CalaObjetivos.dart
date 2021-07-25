import 'package:cala/helpers/DBHelper.dart';
import 'package:cala/widgets/configs/CalaIcons.dart';
import 'package:flutter/material.dart';

import 'package:cala/widgets/configs/CalaColors.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CalaObjetivos extends StatefulWidget {
  final DBHelper _dbHelper;
  CalaObjetivos(this._dbHelper);
  @override
  _CalaObjetivosState createState() => _CalaObjetivosState(_dbHelper);
}

class _CalaObjetivosState extends State<CalaObjetivos> {
  final DBHelper _dbHelper;

  var _gottenDaily = 0;
  var _gottenGral = 0;

  List<double> objetivosDaily = [];
  List<double> objetivosGral = [];

  _CalaObjetivosState(this._dbHelper) {
    update(true);
    _dbHelper.broadcastStream.listen((msg) {
      if (msg == 'updObj') {
        update(false);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    ListView mainList = ListView(
      padding: EdgeInsets.all(10),
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          'Objetivos diarios',
          style: TextStyle(
              color: CalaColors.textDark,
              fontSize: 25,
              fontWeight: FontWeight.w300),
        ),
        SizedBox(
          height: 20,
        ),
        getDaily(),
        SizedBox(
          height: 20,
        ),
        Text(
          'Objetivos generales',
          style: TextStyle(
              color: CalaColors.textDark,
              fontSize: 25,
              fontWeight: FontWeight.w300),
        ),
        SizedBox(
          height: 20,
        ),
        getGeneral()
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Objetivos'),
        backgroundColor: CalaColors.teal,
      ),
      body: mainList,
      floatingActionButton: _getFAB(),
    );
  }

  void update(bool constructor) {
    if (!constructor) {
      setState(() {
        _gottenDaily = _gottenGral = 0;
      });
    }
    _dbHelper.getObjetivosMVals().then((obj) {
      objetivosDaily = obj;
      setState(() {
        _gottenDaily = obj[0] != 0 ? 1 : 2;
      });
    });
    _dbHelper.getLatestObjetivosGral().then((obj) {
      objetivosGral = obj;
      setState(() {
        _gottenGral = obj[0] != 0 ? 1 : 2;
      });
    });
  }

  Row makeInfoRow(String header, double data, MaterialColor color) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2),
            child: Container(
              color: color[600],
              padding: EdgeInsets.symmetric(vertical: 9, horizontal: 0),
              child: Center(
                child: Text(
                  header,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2),
            child: Container(
              color: color[200],
              padding: EdgeInsets.symmetric(vertical: 9, horizontal: 0),
              child: Center(
                child: Text(
                  data.toStringAsFixed(2),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getGeneral() {
    switch (_gottenGral) {
      case 0:
        return new Align(
          child: new Container(
            width: 70.0,
            height: 70.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          ),
          alignment: FractionalOffset.center,
        );
      case 1:
        return Column(children: [
          makeInfoRow('Peso: ', objetivosGral[0], CalaColors.orange),
          makeInfoRow('IMC: ', objetivosGral[1], CalaColors.orange),
          makeInfoRow(
              'Grasa corporal (%): ', objetivosGral[2], CalaColors.orange),
          makeInfoRow('Brazos (cm): ', objetivosGral[3], CalaColors.orange),
          makeInfoRow('Pecho (cm): ', objetivosGral[4], CalaColors.orange),
          makeInfoRow('Cintura (cm): ', objetivosGral[5], CalaColors.orange),
          makeInfoRow('Cadera (cm): ', objetivosGral[6], CalaColors.orange),
          makeInfoRow('Muslos (cm): ', objetivosGral[7], CalaColors.orange),
        ]);
      case 2:
        return Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              'Nada que mostrar...',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 17,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        );
      default:
        return Container();
    }
  }

  Widget getDaily() {
    switch (_gottenDaily) {
      case 0:
        return new Align(
          child: new Container(
            width: 70.0,
            height: 70.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          ),
          alignment: FractionalOffset.center,
        );
      case 1:
        return Column(children: [
          makeInfoRow('Calorias: ', objetivosDaily[0], CalaColors.orange),
          makeInfoRow('Carbohidratos: ', objetivosDaily[1], CalaColors.orange),
          makeInfoRow('Proteinas: ', objetivosDaily[2], CalaColors.orange),
          makeInfoRow('Grasas: ', objetivosDaily[3], CalaColors.orange),
        ]);
      case 2:
        return Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              'Nada que mostrar...',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 17,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        );
      default:
        return Container();
    }
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: CalaIcons.addIconWhite,
          backgroundColor: CalaColors.orange,
          onTap: () {
            showAddOBD();
          },
          label: 'Cambiar objetivo diario',
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 16.0,
          ),
          labelBackgroundColor: CalaColors.orange,
        ),
        SpeedDialChild(
          child: CalaIcons.addIconWhite,
          backgroundColor: CalaColors.orange,
          onTap: () {
            showAddOBG();
          },
          label: 'Cambiar objetivo general',
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 16.0,
          ),
          labelBackgroundColor: CalaColors.orange,
        )
      ],
    );
  }

  void showAddOBD() {
    var calCtl = TextEditingController();
    var carbCtl = TextEditingController();
    var protCtl = TextEditingController();
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
                  'Calorias',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: calCtl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? 'Ingrese calorias'
                        : null;
                  },
                ),
              ),
              Text(
                'kcal',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Carbohidratos',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: carbCtl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return (value == null ||
                            value.isEmpty ||
                            double.parse(value) > 100)
                        ? 'Ingrese porcentaje de carbohidratos'
                        : null;
                  },
                ),
              ),
              Text(
                '%',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Proteinas',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: protCtl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return (value == null ||
                            value.isEmpty ||
                            double.parse(value) > 100)
                        ? 'Ingrese porcentaje de proteinas'
                        : null;
                  },
                ),
              ),
              Text(
                '%',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Grasas',
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
                        ? 'Ingrese porcentaje de grasas'
                        : null;
                  },
                ),
              ),
              Text(
                '%',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("Objetivo diario."),
        content: form,
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                var carbper = double.parse(carbCtl.text);
                var protper = double.parse(protCtl.text);
                var grasper = double.parse(grasCtl.text);
                var tot = carbper + protper + grasper;

                if (tot < 100 || tot > 101) {
                  showInfoDiag('Los porcentajes no igualan el 100%');
                } else {
                  var cal = double.parse(calCtl.text);
                  var carb = (cal * (carbper / 100)) / 4;
                  var prot = (cal * (protper / 100)) / 4;
                  var gras = (cal * (grasper / 100)) / 9;
                  showWaiting('Agregando...');
                  var success =
                      await _dbHelper.addObjetivoDiario(cal, carb, prot, gras);

                  if (success) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    showInfoDiag('Agregado correctamente!');
                  } else {
                    Navigator.of(context).pop();
                    showInfoDiag('No se pudo agregar.');
                  }
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

  void showAddOBG() {
    var pesoCtl = TextEditingController();
    var altCtl = TextEditingController();
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
                  'Altura',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: altCtl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? 'Ingrese una altura'
                        : null;
                  },
                ),
              ),
              Text(
                'cm',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Grasas',
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
                        ? 'Ingrese porcentaje de grasas'
                        : null;
                  },
                ),
              ),
              Text(
                '%',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("Objetivo general."),
        content: form,
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                var peso = double.parse(pesoCtl.text);
                var alt = double.parse(altCtl.text);
                var gras = double.parse(grasCtl.text);
                showWaiting('Agregando...');
                var success = await _dbHelper.addObjetivoGral(peso, alt, gras);
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
}
