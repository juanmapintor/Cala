import 'package:cala/helpers/DBHelper.dart';
import 'package:cala/helpers/datamodel/ObjetosNutricionales.dart';
import 'package:cala/widgets/configs/CalaFonts.dart';
import 'package:cala/widgets/contents/CalaAgregar.dart';
import 'package:cala/widgets/contents/CalaContents.dart';
import 'package:cala/widgets/contents/CalaDialogs.dart';
import 'package:flutter/material.dart';

import 'configs/CalaColors.dart';
import 'configs/CalaIcons.dart';

class CalaCatalogo extends StatefulWidget {
  final DBHelper _dbHelper;

  CalaCatalogo(this._dbHelper);

  @override
  _CalaCatalogoState createState() => _CalaCatalogoState(_dbHelper);
}

class _CalaCatalogoState extends State<CalaCatalogo> {
  final DBHelper _dbHelper;

  var _loaded = false;

  List<Comida> _listaComidas = [];

  var _searchedTerm = '';

  _CalaCatalogoState(this._dbHelper) {
    _update();
    _dbHelper.broadcastStream.listen((event) {
      if (event == 'updCat') _update();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CalaContents.headline5(text: 'Catalogo', light: true),
        backgroundColor: CalaColors.mainTealColor,
      ),
      body: _mainBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CalaAgregar.showAddComida(dbHelper: _dbHelper, context: context);
        },
        child: CalaIcons.addIcon,
        backgroundColor: CalaColors.green,
      ),
    );
  }

  Widget _mainBody() {
    var _lista = _listaComidas.isNotEmpty
        ? _getComidasColumn(_searchedTerm)
        : Center(
            child: CalaContents.body1(text: 'Nada que mostrar...'),
          );
    var _infoShow = _loaded ? _lista : CalaContents.waitingWidget();
    var _searchBar = Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
            hintText: "Buscar",
            hintStyle: CalaFonts.pacificoFontDark.bodyText2,
            border: OutlineInputBorder(),
            icon: Icon(Icons.search)),
        onChanged: (value) {
          setState(() {
            _searchedTerm = value;
          });
        },
      ),
    );
    return Container(
      child: Column(
        children: [
          _searchBar,
          Expanded(
            child: _infoShow,
          ),
          SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }

  void _update() async {
    if (mounted) {
      setState(() {
        _loaded = false;
      });
    }
    _listaComidas = await _dbHelper.getListaComidas();

    if (mounted) {
      setState(() {
        _loaded = true;
      });
    }
  }

  Widget _getComidasColumn(String searchedTerm) {
    List<Comida> _listaGenerada = [];

    if (searchedTerm.isNotEmpty) {
      _listaComidas.forEach((comida) {
        if (comida.nombre.toLowerCase().contains(searchedTerm.toLowerCase())) {
          _listaGenerada.add(comida);
        }
      });
    } else {
      _listaGenerada = _listaComidas;
    }
    return ListView(
      children: _listaGenerada
          .map(
            (comida) => CalaContents.itemCuantificado(
              nombre: comida.nombre,
              cantidad: comida.cantidad.toStringAsFixed(0),
              calorias: comida.calorias.toStringAsFixed(0),
              carbohidratos: comida.carbohidratos.toStringAsFixed(0),
              proteinas: comida.proteinas.toStringAsFixed(0),
              grasas: comida.grasas.toStringAsFixed(0),
              onPressedDelete: () async {
                CalaDialogs.showWaitingDiag(
                    context: context, message: 'Eliminando comida');
                var success = await _dbHelper.deleteComida(comida.id);
                Navigator.pop(context);
                if (success) {
                  await CalaDialogs.showSuccessDiag(context: context);
                } else {
                  CalaDialogs.showFailDiag(
                      context: context,
                      errorMessage:
                          'No se pudo eliminar la comida. Intentelo de nuevo más tarde.',
                      onAccept: () {
                        Navigator.pop(context);
                      });
                }
              },
            ),
          )
          .toList(),
    );
  }
}
