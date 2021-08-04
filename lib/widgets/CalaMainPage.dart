// Helpers
import 'package:cala/helpers/DBHelper.dart';
import 'package:cala/helpers/FormatHelper.dart';
import 'package:cala/helpers/datamodel/ObjetosNutricionales.dart';
import 'package:cala/widgets/contents/CalaAgregar.dart';

// Contents
import 'package:cala/widgets/contents/CalaContents.dart';
import 'package:cala/widgets/contents/CalaDialogs.dart';

// Configs
import 'package:cala/widgets/configs/CalaFonts.dart';
import 'package:cala/widgets/configs/CalaColors.dart';
import 'package:cala/widgets/configs/CalaIcons.dart';

// Dependencies
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CalaMainPage extends StatefulWidget {
  final DBHelper _dbHelper;
  CalaMainPage(this._dbHelper);

  @override
  _CalaMainPageState createState() => _CalaMainPageState(_dbHelper);
}

class _CalaMainPageState extends State<CalaMainPage> {
  final DBHelper _dbHelper;

  late ObjetivoDiario _objetivoDiario;
  late UnidadNutricional _totalesActual;
  late UnidadNutricional _totalesPorcentuales;

  var _loaded = false;

  _CalaMainPageState(this._dbHelper) {
    _update();
    _dbHelper.broadcastStream.listen((event) {
      if (event == 'updMain' && mounted) _update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CalaContents.headline5(text: 'Cala', light: true),
        backgroundColor: CalaColors.mainTealColor,
      ),
      drawer: _calaDrawer(),
      body: _loaded ? _carousel() : CalaContents.waitingWidget(),
      floatingActionButton: _multipleAddFAB(),
    );
  }

  _calaDrawer() {
    _calaDrawerHeader() {
      return DrawerHeader(
        decoration: BoxDecoration(
          color: CalaColors.orange,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Image.asset(
                'lib/assets/cala_icon.png',
              ),
            ),
            Expanded(
              flex: 3,
              child: CalaContents.headline5(
                text: 'Cala',
                light: true,
              ),
            ),
          ],
        ),
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _calaDrawerHeader(),
          ListTile(
            leading: CalaIcons.histIcon,
            title: CalaContents.body2(text: 'Historial de comidas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/historial');
            },
          ),
          ListTile(
            leading: CalaIcons.catalogIcon,
            title: CalaContents.body2(text: 'Catalogo de Comidas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/catalogo');
            },
          ),
          ListTile(
            leading: CalaIcons.progressIcon,
            title: CalaContents.body2(text: 'Mi Progreso'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/progreso');
            },
          ),
          ListTile(
            leading: CalaIcons.objetivIcon,
            title: CalaContents.body2(text: 'Mis Objetivos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/objetivos');
            },
          )
        ],
      ),
    );
  }

  _paginaMacro() {
    _verticalProgressBar(
        {required int maxValue,
        required int currentValue,
        required Color color,
        required String tag}) {
      return Expanded(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: 30,
                  child: FAProgressBar(
                    animatedDuration: Duration(seconds: 2),
                    maxValue: maxValue,
                    currentValue: currentValue < 10
                        ? (maxValue * 0.1).toInt()
                        : currentValue,
                    direction: Axis.vertical,
                    verticalDirection: VerticalDirection.up,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    border: Border.all(color: color, style: BorderStyle.solid),
                    progressColor: color,
                  ),
                ),
              ),
              SizedBox(
                height: 9,
              ),
              CalaContents.overline(text: tag),
              SizedBox(
                height: 9,
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: currentValue > maxValue
                        ? CalaColors.red[700]
                        : CalaColors.transparent,
                    borderRadius: BorderRadius.circular(10)),
                child: CalaContents.body1(
                    text: '$currentValue', light: currentValue > maxValue),
              ),
              Container(
                child: CalaContents.body1(text: '/$maxValue'),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        CalaContents.headline4(text: 'Macronutrientes'),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: CalaContents.body2(
              text:
                  'Macronutrientes consumidos, del total disponible, durante el dia.'),
        ),
        _objetivoDiario.calorias != 0
            ? Expanded(
                child: Row(
                  children: [
                    _verticalProgressBar(
                        maxValue: _objetivoDiario.calorias.toInt(),
                        currentValue: _totalesActual.calorias.toInt(),
                        color: CalaColors.blue,
                        tag: 'Calorias'),
                    _verticalProgressBar(
                        maxValue: _objetivoDiario.carbohidratos.toInt(),
                        currentValue: _totalesActual.carbohidratos.toInt(),
                        color: CalaColors.red,
                        tag: 'Hidratos'),
                    _verticalProgressBar(
                        maxValue: _objetivoDiario.proteinas.toInt(),
                        currentValue: _totalesActual.proteinas.toInt(),
                        color: CalaColors.green,
                        tag: 'Proteinas'),
                    _verticalProgressBar(
                        maxValue: _objetivoDiario.grasas.toInt(),
                        currentValue: _totalesActual.grasas.toInt(),
                        color: CalaColors.orange,
                        tag: 'Grasas'),
                  ],
                ),
              )
            : Expanded(
                child: Center(
                  child: CalaContents.body1(
                      text:
                          'Comience agregando objetivos en la pestaña objetivos.'),
                ),
              ),
      ],
    );
  }

  _paginaPorcentual() {
    _pieChart() {
      return PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: CalaColors.red,
              value: _totalesPorcentuales.carbohidratos,
              radius: 50,
              title:
                  _totalesPorcentuales.carbohidratos.toStringAsFixed(2) + '%',
              titleStyle: CalaFonts.pacificoFontLight.bodyText2,
            ),
            PieChartSectionData(
              color: CalaColors.green,
              value: _totalesPorcentuales.proteinas,
              radius: 50,
              title: _totalesPorcentuales.proteinas.toStringAsFixed(2) + '%',
              titleStyle: CalaFonts.pacificoFontLight.bodyText2,
            ),
            PieChartSectionData(
              color: CalaColors.orange,
              value: _totalesPorcentuales.grasas,
              radius: 50,
              title: _totalesPorcentuales.grasas.toStringAsFixed(2) + '%',
              titleStyle: CalaFonts.pacificoFontLight.bodyText2,
            ),
          ],
        ),
      );
    }

    _boxy(double size, Color color, bool isSquare) => Container(
          width: size,
          height: size,
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        );

    _indicator() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _boxy(30, CalaColors.red, false),
                Container(
                  width: 100,
                  padding: EdgeInsets.only(left: 4),
                  child: CalaContents.overline(text: 'Hidratos'),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _boxy(30, CalaColors.green, false),
                Container(
                  width: 100,
                  padding: EdgeInsets.only(left: 4),
                  child: CalaContents.overline(text: 'Proteinas'),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _boxy(30, CalaColors.orange, false),
                Container(
                  width: 100,
                  padding: EdgeInsets.only(left: 4),
                  child: CalaContents.overline(text: 'Grasas'),
                ),
              ],
            ),
          ],
        );

    return Column(
      children: [
        CalaContents.headline4(text: 'Macronutrientes'),
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: CalaContents.body2(
              text:
                  'Desglose porcentual de los macronutrientes consumidos durante el dia.'),
        ),
        _totalesActual.carbohidratos != 0
            ? Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        child: AspectRatio(
                      aspectRatio: 1,
                      child: _pieChart(),
                    )),
                    Container(
                      child: _indicator(),
                    )
                  ],
                ),
              )
            : Expanded(
                child: Center(
                  child: CalaContents.body1(
                      text:
                          'Comience agregando ingestas en el boton inferior.'),
                ),
              ),
      ],
    );
  }

  _carousel() {
    _carouselCard(Widget child) => Container(
          decoration: BoxDecoration(
            color: CalaColors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
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
          _carouselCard(_paginaMacro()),
          _carouselCard(_paginaPorcentual()),
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

  Widget _multipleAddFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: CalaIcons.addIconWhite,
          backgroundColor: CalaColors.green,
          onTap: () {
            CalaAgregar.showAddIngesta(dbHelper: _dbHelper, context: context);
          },
          label: 'Agregar ingesta.',
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: CalaColors.white,
            fontSize: 16.0,
          ),
          labelBackgroundColor: CalaColors.green,
        ),
        SpeedDialChild(
          child: CalaIcons.addIconWhite,
          backgroundColor: CalaColors.orange,
          onTap: () {
            CalaAgregar.showAddComida(dbHelper: _dbHelper, context: context);
          },
          label: 'Agregar comida',
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

  void _update() async {
    if (mounted) {
      setState(() {
        _loaded = false;
      });
    }

    _objetivoDiario = await _dbHelper.getObjetivoDiario();

    var _listaIngestas = await _dbHelper.getListaIngestas(FormatHelper.today());

    _totalesActual = UnidadNutricional(
        calorias: 0, carbohidratos: 0, proteinas: 0, grasas: 0);

    for (var ingesta in _listaIngestas) {
      _totalesActual.calorias += ingesta.calorias;
      _totalesActual.carbohidratos += ingesta.carbohidratos;
      _totalesActual.proteinas += ingesta.proteinas;
      _totalesActual.grasas += ingesta.grasas;
    }

    var _tot = _totalesActual.carbohidratos +
        _totalesActual.proteinas +
        _totalesActual.grasas;

    _totalesPorcentuales = UnidadNutricional(
        calorias: 0,
        carbohidratos: (_totalesActual.carbohidratos * 100) / _tot,
        proteinas: (_totalesActual.proteinas * 100) / _tot,
        grasas: (_totalesActual.grasas * 100) / _tot);

    if (mounted) {
      setState(() {
        _loaded = true;
      });
    }
  }
}
