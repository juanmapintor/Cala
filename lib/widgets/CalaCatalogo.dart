import 'package:cala/helpers/DBHelper.dart';
import 'package:cala/helpers/IngestaHistorial.dart';
import 'package:flutter/material.dart';

import 'package:cala/widgets/configs/CalaColors.dart';

import 'configs/CalaIcons.dart';
import 'contents/TableContents.dart';

class CalaCatalogo extends StatefulWidget {
  final DBHelper _dbHelper;
  CalaCatalogo(this._dbHelper);
  @override
  _CalaCatalogoState createState() => _CalaCatalogoState(_dbHelper);
}

class _CalaCatalogoState extends State<CalaCatalogo> {
  late DBHelper _dbHelper;
  var _load = true;
  var _gotten = false;
  late List<IngestaHistorial> _ingestas;

  _CalaCatalogoState(this._dbHelper) {
    update(true);
    _dbHelper.broadcastStream.listen((msg) {
      update(false);
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            width: 70.0,
            height: 70.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          )
        : new Container();

    ListView mainList = ListView(
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
                      color: Colors.grey[500],
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
        title: Text('Catalogo'),
        backgroundColor: CalaColors.mainTealColor,
      ),
      body: mainList,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/agregarComida');
        },
        child: CalaIcons.addIcon,
        backgroundColor: Colors.green,
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

    _dbHelper.getComidas().then((value) {
      _ingestas = value;
      setState(() {
        _load = false;
        _gotten = _ingestas.isNotEmpty;
      });
    });
  }

  Container makeFoodShower(IngestaHistorial comida) {
    return Container(
      padding: EdgeInsets.only(left: 5, top: 5, right: 5),
      child: Column(
        children: [
          TableContents.makeTableRow(
              true, ['Nombre', 'Cantidad'], Colors.orange),
          TableContents.makeTableRow(
              false,
              [comida.nombre, comida.cant.toStringAsFixed(2)],
              CalaColors.orange),
          TableContents.makeInfoRow(
              'Calorias: ', comida.cals, CalaColors.orange),
          TableContents.makeInfoRow(
              'Proteinas: ', comida.prot, CalaColors.orange),
          TableContents.makeInfoRow(
              'Carbohidratos: ', comida.carb, CalaColors.orange),
          TableContents.makeInfoRow('Grasas: ', comida.gras, CalaColors.orange),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  _gotten = false;
                  _load = true;
                });
                await _dbHelper.deleteComida(comida.id);
                update(false);
              },
              child: Icon(Icons.delete, color: Colors.white),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                primary: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
