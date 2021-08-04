import 'package:cala/helpers/DBHelper.dart';
import 'package:cala/helpers/datamodel/ObjetosNutricionales.dart';
import 'package:cala/widgets/configs/CalaIcons.dart';
import 'package:cala/widgets/contents/CalaContents.dart';
import 'package:cala/widgets/contents/CalaDialogs.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
      if (msg == 'updObj' && mounted) update(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CalaContents.headline6(text: 'Objetivos', light: true),
        backgroundColor: CalaColors.teal,
      ),
      body: _carousel(),
      floatingActionButton: _getFAB(),
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
          _carouselCard(_paginaGeneral()),
          _carouselCard(_paginaDiarios()),
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

  Widget _paginaGeneral() {
    return Column(
      children: [
        CalaContents.headline5(
          text: 'Objetivos generales',
        ),
        Expanded(
          child: getGeneral(),
        ),
      ],
    );
  }

  Widget _paginaDiarios() {
    return Column(
      children: [
        CalaContents.headline5(
          text: 'Objetivos diarios',
        ),
        Expanded(
          child: getDaily(),
        ),
      ],
    );
  }

  void update(bool constructor) {
    if (!constructor) {
      setState(() {
        _gottenDaily = _gottenGral = 0;
      });
    }
    _dbHelper.getObjetivoDiario().then((obj) {
      objetivosDaily = [
        obj.calorias,
        obj.carbohidratos,
        obj.proteinas,
        obj.grasas
      ];
      setState(() {
        _gottenDaily = obj.calorias != 0 ? 1 : 2;
      });
    });
    _dbHelper.getObjetivoGral().then((obj) {
      objetivosGral = [obj.peso, obj.imc, obj.porcGrasa];
      setState(() {
        _gottenGral = obj.peso != 0 ? 1 : 2;
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
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color[600],
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 9, horizontal: 0),
              child: Center(
                child: CalaContents.subtitle2(text: header, light: true),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2),
            child: Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color[900],
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 9, horizontal: 0),
              child: Center(
                child: CalaContents.body1(
                    text: data.toStringAsFixed(2), light: true),
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
        return CalaContents.waitingWidget();
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            makeInfoRow('Peso: ', objetivosGral[0], CalaColors.orange),
            makeInfoRow('IMC: ', objetivosGral[1], CalaColors.orange),
            makeInfoRow('% Grasa: ', objetivosGral[2], CalaColors.orange),
          ],
        );
      case 2:
        return Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: CalaContents.body1(
              text: 'Nada que mostrar...',
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
        return CalaContents.waitingWidget();
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            makeInfoRow('Calorias: ', objetivosDaily[0], CalaColors.orange),
            makeInfoRow(
                'Carbohidratos: ', objetivosDaily[1], CalaColors.orange),
            makeInfoRow('Proteinas: ', objetivosDaily[2], CalaColors.orange),
            makeInfoRow('Grasas: ', objetivosDaily[3], CalaColors.orange),
          ],
        );
      case 2:
        return Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: CalaContents.body1(
              text: 'Nada que mostrar...',
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
            color: CalaColors.white,
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
            color: CalaColors.white,
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
                child: CalaContents.subtitle2(
                  text: 'Calorias',
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
              CalaContents.caption(
                text: 'kcal',
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CalaContents.subtitle2(
                  text: 'Carbohidratos',
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
              CalaContents.caption(
                text: '%',
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CalaContents.subtitle2(
                  text: 'Proteinas',
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
              CalaContents.caption(
                text: '%',
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CalaContents.subtitle2(
                  text: 'Grasas',
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
              CalaContents.caption(
                text: '%',
              ),
            ],
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: CalaContents.headline5(text: "Objetivo diario."),
        content: form,
        actions: <Widget>[
          TextButton(
            child: CalaContents.button(text: 'OK'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                var carbper = double.parse(carbCtl.text);
                var protper = double.parse(protCtl.text);
                var grasper = double.parse(grasCtl.text);
                var tot = carbper + protper + grasper;

                if (tot < 100 || tot > 101) {
                  CalaDialogs.showInfoDiag(
                      context: context,
                      message: 'Los porcentajes no igualan el 100%');
                } else {
                  var cal = double.parse(calCtl.text);
                  var carb = (cal * (carbper / 100)) / 4;
                  var prot = (cal * (protper / 100)) / 4;
                  var gras = (cal * (grasper / 100)) / 9;
                  CalaDialogs.showWaitingDiag(
                      context: context, message: 'Agregando...');
                  Navigator.of(context).pop();
                  var success = await _dbHelper.addObjetivoDiario(
                      ObjetivoDiario(
                          calorias: cal,
                          carbohidratos: carb,
                          proteinas: prot,
                          grasas: gras));

                  if (success) {
                    Navigator.of(context).pop();
                    await CalaDialogs.showSuccessDiag(context: context);
                  } else {
                    CalaDialogs.showFailDiag(
                        context: context,
                        errorMessage: 'No se pudo agregar.',
                        onAccept: () {
                          Navigator.of(context).pop();
                        });
                  }
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
                  text: 'Altura',
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
              CalaContents.caption(
                text: 'cm',
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CalaContents.subtitle2(
                  text: 'Grasas',
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
              CalaContents.caption(
                text: '%',
              ),
            ],
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: CalaContents.headline5(text: "Objetivo general."),
        content: form,
        actions: <Widget>[
          TextButton(
            child: CalaContents.button(text: 'OK'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                var peso = double.parse(pesoCtl.text);
                var alt = double.parse(altCtl.text);
                var gras = double.parse(grasCtl.text);
                CalaDialogs.showWaitingDiag(
                    context: context, message: 'Agregando...');
                var success = await _dbHelper.addObjetivoGral(peso, alt, gras);
                Navigator.of(context).pop();
                if (success) {
                  Navigator.of(context).pop();
                  await CalaDialogs.showSuccessDiag(context: context);
                } else {
                  CalaDialogs.showFailDiag(
                      context: context,
                      errorMessage: 'No se pudo agregar.',
                      onAccept: () {
                        Navigator.of(context).pop();
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
