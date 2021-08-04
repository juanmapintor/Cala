import 'package:cala/helpers/DBHelper.dart';
import 'package:cala/helpers/datamodel/ObjetosNutricionales.dart';
import 'package:cala/widgets/contents/CalaContents.dart';
import 'package:cala/widgets/contents/CalaDialogs.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CalaAgregar {
  static showAddComida(
      {required DBHelper dbHelper, required BuildContext context}) {
    final _addForm = _CalaAgregarComida(dbHelper);
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: CalaContents.headline5(text: 'Agregar comida'),
            content: _addForm,
            actions: [
              TextButton(
                onPressed: () async {
                  _addForm.add(context);
                },
                child: CalaContents.button(text: 'Agregar'),
              ),
              TextButton(
                onPressed: () {
                  // Cancelar
                  Navigator.pop(context);
                },
                child: CalaContents.button(text: 'Cancelar'),
              )
            ],
          );
        });
  }

  static showAddIngesta(
      {required DBHelper dbHelper, required BuildContext context}) async {
    var _listaComidas = await _obtenerComidas(dbHelper, context);
    if (_listaComidas.isNotEmpty) {
      final GlobalKey<__CalaAgregarIngestaState> _formKey =
          GlobalKey<__CalaAgregarIngestaState>();
      final _addForm = _CalaAgregarIngesta(_formKey, _listaComidas, dbHelper);
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: CalaContents.headline5(text: 'Agregar Ingesta'),
              content: _addForm,
              actions: [
                TextButton(
                  onPressed: () async {
                    _formKey.currentState!.add(context);
                  },
                  child: CalaContents.button(text: 'Agregar'),
                ),
                TextButton(
                  onPressed: () {
                    // Cancelar
                    Navigator.pop(context);
                  },
                  child: CalaContents.button(text: 'Cancelar'),
                )
              ],
            );
          });
    }
  }

  static Future<List<Comida>> _obtenerComidas(
      DBHelper dbHelper, BuildContext context) async {
    List<Comida> _listaComidas = [];

    // Muestro Waiting
    CalaDialogs.showWaitingDiag(
        context: context, message: 'Obteniendo comidas');

    _listaComidas = await dbHelper.getListaComidas();

    // Saca Waiting
    Navigator.pop(context);

    if (_listaComidas.isEmpty) {
      // Muestro el error
      CalaDialogs.showFailDiag(
          context: context,
          errorMessage:
              'No hay comidas para agregar. Empiece agregando una comida.',
          onAccept: () {
            // Salgo del error
            Navigator.pop(context);
          });
    }

    return _listaComidas;
  }
}

class _CalaAgregarComida extends StatelessWidget {
  final DBHelper _dbHelper;

  final _nombreCtl = TextEditingController();
  final _cantidadCtl = TextEditingController();
  final _caloriasCtl = TextEditingController();
  final _carbohidratosCtl = TextEditingController();
  final _grasasCtl = TextEditingController();
  final _proteinasCtl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  _CalaAgregarComida(this._dbHelper);
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CalaContents.subtitle2(text: 'Nombre'),
            TextFormField(
              controller: _nombreCtl,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: (value) {
                return (value == null || value.isEmpty)
                    ? 'Ingrese un nombre'
                    : null;
              },
            ),
            SizedBox(height: 10),
            CalaContents.subtitle2(text: 'Cantidad'),
            TextFormField(
              controller: _cantidadCtl,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: (value) {
                return (value == null || value.isEmpty)
                    ? 'Ingrese una cantidad'
                    : null;
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CalaContents.subtitle2(text: 'Calorias'),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _caloriasCtl,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return (value == null || value.isEmpty)
                          ? 'Ingrese las calorias'
                          : null;
                    },
                  ),
                ),
                CalaContents.caption(text: 'kcal.')
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CalaContents.subtitle2(text: 'Hidratos'),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _carbohidratosCtl,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return (value == null || value.isEmpty)
                          ? 'Ingrese los carbohidratos'
                          : null;
                    },
                  ),
                ),
                CalaContents.caption(text: 'gr.')
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CalaContents.subtitle2(text: 'Proteinas'),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _proteinasCtl,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return (value == null || value.isEmpty)
                          ? 'Ingrese las proteinas'
                          : null;
                    },
                  ),
                ),
                CalaContents.caption(text: 'gr.')
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CalaContents.subtitle2(text: 'Grasas'),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _grasasCtl,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return (value == null || value.isEmpty)
                          ? 'Ingrese las grasas'
                          : null;
                    },
                  ),
                ),
                CalaContents.caption(text: 'gr.')
              ],
            ),
          ],
        ),
      ),
    );
  }

  void add(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final nuevaComida = Comida(
        nombre: _nombreCtl.text,
        cantidad: double.parse(_cantidadCtl.text),
        calorias: double.parse(_caloriasCtl.text),
        carbohidratos: double.parse(_carbohidratosCtl.text),
        proteinas: double.parse(_proteinasCtl.text),
        grasas: double.parse(_grasasCtl.text),
      );
      CalaDialogs.showWaitingDiag(
          context: context, message: 'Agregando comida.');
      final success = await _dbHelper.addComida(nuevaComida);
      // Saco el waiting
      Navigator.pop(context);

      if (success) {
        // Saco el form porque se agregó exitosamente
        Navigator.pop(context);
        await CalaDialogs.showSuccessDiag(context: context);
      } else {
        // NO saco el Form porque no se agregó exitosamente, muestro el error
        CalaDialogs.showFailDiag(
            context: context,
            errorMessage:
                'No se pudo agregar la nueva comida. Intentelo de nuevo más tarde.',
            onAccept: () {
              Navigator.pop(context);
            });
      }
    }
  }
}

class _CalaAgregarIngesta extends StatefulWidget {
  final List<Comida> listaComidas;
  final DBHelper dbHelper;

  _CalaAgregarIngesta(Key? key, this.listaComidas, this.dbHelper)
      : super(key: key);

  @override
  __CalaAgregarIngestaState createState() =>
      __CalaAgregarIngestaState(listaComidas, dbHelper);
}

class __CalaAgregarIngestaState extends State<_CalaAgregarIngesta> {
  final List<Comida> _listaComidas;
  final DBHelper _dbHelper;

  var _selectedComida = Comida(
      nombre: '',
      cantidad: 1,
      calorias: 0,
      carbohidratos: 0,
      proteinas: 0,
      grasas: 0);

  var _unidadValues = UnidadNutricional(
    calorias: 0,
    carbohidratos: 0,
    proteinas: 0,
    grasas: 0,
  );

  var _cantidad = 0.0;

  final _formKey = GlobalKey<FormState>();
  final _cantidadCtl = TextEditingController();

  __CalaAgregarIngestaState(this._listaComidas, this._dbHelper);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CalaContents.subtitle2(text: 'Seleccione la comida...'),
            _dropdown(),
            SizedBox(height: 10),
            CalaContents.subtitle2(text: 'Cantidad'),
            TextFormField(
              controller: _cantidadCtl,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: (value) {
                return (value == null || value.isEmpty)
                    ? 'Ingrese una cantidad'
                    : null;
              },
              onChanged: (value) {
                _cantidad = value.isNotEmpty ? double.parse(value) : 0;
                _updateCuentas();
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CalaContents.subtitle2(text: 'Calorias'),
                ),
                Expanded(
                  child: CalaContents.body1(
                      text: _unidadValues.calorias.toStringAsFixed(0)),
                ),
                CalaContents.caption(text: 'kcal.')
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CalaContents.subtitle2(text: 'Hidratos'),
                ),
                Expanded(
                  child: CalaContents.body1(
                      text: _unidadValues.carbohidratos.toStringAsFixed(2)),
                ),
                CalaContents.caption(text: 'gr.')
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CalaContents.subtitle2(text: 'Proteinas'),
                ),
                Expanded(
                  child: CalaContents.body1(
                      text: _unidadValues.proteinas.toStringAsFixed(2)),
                ),
                CalaContents.caption(text: 'gr.')
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CalaContents.subtitle2(text: 'Grasas'),
                ),
                Expanded(
                  child: CalaContents.body1(
                      text: _unidadValues.grasas.toStringAsFixed(2)),
                ),
                CalaContents.caption(text: 'gr.')
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdown() {
    return DropdownSearch<Comida>(
      mode: Mode.DIALOG,
      items: _listaComidas,
      selectedItem: _selectedComida,
      onChanged: (value) {
        _selectedComida = value!;
        if (_cantidad != 0) _updateCuentas();
      },
      showSearchBox: true,
      validator: (value) {
        return (value!.id == -1) ? 'Seleccione una comida' : null;
      },
      searchFieldProps: TextFieldProps(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
          labelText: "Buscar...",
        ),
      ),
      popupShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );
  }

  void _updateCuentas() {
    setState(() {
      _unidadValues.calorias =
          _cantidad * _selectedComida.calorias / _selectedComida.cantidad;
      _unidadValues.carbohidratos =
          _cantidad * _selectedComida.carbohidratos / _selectedComida.cantidad;
      _unidadValues.proteinas =
          _cantidad * _selectedComida.proteinas / _selectedComida.cantidad;
      _unidadValues.grasas =
          _cantidad * _selectedComida.grasas / _selectedComida.cantidad;
    });
  }

  void add(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      CalaDialogs.showWaitingDiag(
          context: context, message: 'Agregando ingesta.');
      var success = await _dbHelper.addIngesta(
          comidaID: _selectedComida.id.toString(), cantIngesta: _cantidad);
      // Saco el waiting
      Navigator.pop(context);

      if (success) {
        // Saco el form porque se agregó exitosamente
        Navigator.pop(context);
        await CalaDialogs.showSuccessDiag(context: context);
      } else {
        // NO saco el Form porque no se agregó exitosamente, muestro el error
        CalaDialogs.showFailDiag(
            context: context,
            errorMessage:
                'No se pudo agregar la nueva comida. Intentelo de nuevo más tarde.',
            onAccept: () {
              Navigator.pop(context);
            });
      }
    }
  }
}
