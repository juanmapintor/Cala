import 'package:cala/helpers/DBHelper.dart';
import 'package:cala/helpers/Tuple.dart';
import 'package:flutter/material.dart';

import 'package:cala/widgets/configs/CalaColors.dart';

class CalaAgregar extends StatelessWidget {
  final DBHelper dbHelper;
  final bool comida;
  CalaAgregar(this.dbHelper, this.comida);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar' + (comida ? ' comida.' : ' ingesta.')),
        backgroundColor: CalaColors.mainTealColor,
      ),
      body: Center(
        child: CalaForm(comida, dbHelper),
      ),
    );
  }
}

class CalaForm extends StatefulWidget {
  final bool _comida;
  final DBHelper dbHelper;
  CalaForm(this._comida, this.dbHelper);
  @override
  _CalaFormState createState() => _CalaFormState(_comida, dbHelper);
}

class _CalaFormState extends State<CalaForm> {
  final DBHelper dbHelper;
  final bool _comida;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var items = [Tuple('noid', 'Seleccione...')];
  var dropdownValue = 'noid';

  double cantMVal = 0, calMVal = 0, carbMVal = 0, protMVal = 0, grasMVal = 0;
  double cantCVal = 0, calCVal = 0, carbCVal = 0, protCVal = 0, grasCVal = 0;
  late bool _load;

  var _success = false;
  var _fail = false;

  var nomCtl = TextEditingController(),
      cantCtl = TextEditingController(),
      calCtl = TextEditingController(),
      carbCtl = TextEditingController(),
      protCtl = TextEditingController(),
      grasCtl = TextEditingController();

  var colpad = SizedBox(
    width: double.infinity,
    height: 15,
  );
  var rowpad = SizedBox(
    width: 15,
  );

  var contEnabled = false;

  _CalaFormState(this._comida, this.dbHelper) {
    _load = !_comida;
    if (!_comida) getComidas();
  }
  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            color: Colors.grey[300],
            width: 70.0,
            height: 70.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          )
        : new Container();
    Widget successIndicator = _success
        ? new Container(
            color: Colors.green[600],
            width: 70.0,
            height: 70.0,
            child: new Padding(
              padding: const EdgeInsets.all(5.0),
              child: new Center(
                child: Icon(
                  Icons.check_circle,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : new Container();
    Widget failIndicator = _fail
        ? new Container(
            color: Colors.red[700],
            width: 70.0,
            height: 70.0,
            child: new Padding(
              padding: const EdgeInsets.all(5.0),
              child: new Center(
                child: Icon(
                  Icons.block,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : new Container();
    var form = Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey[50]),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            shrinkWrap: true,
            children: [
              _comida
                  ? Text(
                      'Ingrese un nombre.',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  : Text(
                      'Seleccione una comida',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
              colpad,
              _comida
                  ? TextFormField(
                      controller: nomCtl,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return (value == null || value.isEmpty)
                            ? 'Ingrese un nombre para continuar'
                            : null;
                      },
                    )
                  : DropdownButtonFormField<String>(
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          if (newValue != 'noid') {
                            getMVals(newValue);
                            var value = cantCtl.text;
                            if (value.characters.length != 0)
                              setCalculatedValues(value);
                          }
                        });
                      },
                      validator: (value) {
                        return (value == 'noid')
                            ? 'Seleccione una comida para continuar'
                            : null;
                      },
                      items: items.map<DropdownMenuItem<String>>(
                          (Tuple<String, String> value) {
                        return DropdownMenuItem<String>(
                          value: value.r,
                          child: Text(value.s),
                        );
                      }).toList(),
                    ),
              colpad,
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('Cantidad'),
                        TextFormField(
                          textInputAction: _comida
                              ? TextInputAction.next
                              : TextInputAction.done,
                          controller: cantCtl,
                          enabled: _comida ? true : contEnabled,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.characters.length != 0 && !_comida) {
                              setCalculatedValues(value);
                            } else {
                              resetValues();
                            }
                          },
                          onFieldSubmitted: (value) {
                            add(context);
                          },
                          validator: (value) {
                            return (value == null || value.isEmpty)
                                ? 'Ingrese una cantidad'
                                : null;
                          },
                        )
                      ],
                    ),
                  ),
                  rowpad,
                  Expanded(
                    child: Column(
                      children: [
                        Text('Calorias'),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: calCtl,
                          enabled: _comida,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            return (value == null || value.isEmpty)
                                ? 'Ingrese calorias'
                                : null;
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
              colpad,
              colpad,
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('Carbohidratos'),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: carbCtl,
                          enabled: _comida,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            return (value == null ||
                                    value.isEmpty ||
                                    value == '')
                                ? 'Ingrese carbs.'
                                : null;
                          },
                        )
                      ],
                    ),
                  ),
                  rowpad,
                  Expanded(
                    child: Column(
                      children: [
                        Text('Proteinas'),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: protCtl,
                          enabled: _comida,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            return (value == null || value.isEmpty)
                                ? 'Ingrese proteinas'
                                : null;
                          },
                        )
                      ],
                    ),
                  ),
                  rowpad,
                  Expanded(
                    child: Column(
                      children: [
                        Text('Grasas'),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: grasCtl,
                          enabled: _comida,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            return (value == null || value.isEmpty)
                                ? 'Ingrese grasas'
                                : null;
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
              colpad,
              ElevatedButton(
                onPressed: () {
                  add(context);
                },
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: Text('Agregar'),
              ),
            ],
          ),
        ),
      ),
    );

    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.grey[300],
            child: Center(
              child: form,
            ),
          ),
        ),
        Container(
          height: 70,
          color: Colors.grey[300],
          child: Column(
            children: [
              new Align(
                child: loadingIndicator,
                alignment: FractionalOffset.center,
              ),
              new Align(
                child: successIndicator,
                alignment: FractionalOffset.center,
              ),
              new Align(
                child: failIndicator,
                alignment: FractionalOffset.center,
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> getMVals(String id) async {
    setState(() {
      _load = true;
    });
    var vals = await dbHelper.getMVals(id);
    setState(() {
      _load = false;
      contEnabled = true;
    });
    print('MVals recobidos: ');
    print(vals);
    cantMVal = vals[0];
    calMVal = vals[1];
    carbMVal = vals[2];
    protMVal = vals[3];
    grasMVal = vals[4];
  }

  void showSuccess(BuildContext context) {
    setState(() {
      _success = true;
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _success = false;
      });
      Navigator.pop(context);
    });
  }

  void showFail(BuildContext context) {
    setState(() {
      _fail = true;
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _fail = false;
      });
      Navigator.pop(context);
    });
  }

  Future<void> getComidas() async {
    var comidas = await dbHelper.getComidasNameID();
    items.addAll(comidas);
    setState(() {
      _load = false;
    });
  }

  void setCalculatedValues(String value) {
    double val = value.isNotEmpty ? double.parse(value) : 0;
    if (val == 0 || val.isNaN) return;
    cantCVal = val;
    setState(() {
      calCVal = (val * calMVal) / cantMVal;
      calCtl.text = calCVal.toStringAsFixed(2);
      carbCVal = (val * carbMVal) / cantMVal;
      carbCtl.text = carbCVal.toStringAsFixed(2);
      protCVal = (val * protMVal) / cantMVal;
      protCtl.text = protCVal.toStringAsFixed(2);
      grasCVal = (val * grasMVal) / cantMVal;
      grasCtl.text = grasCVal.toStringAsFixed(2);
    });
  }

  void resetValues() {
    calCVal = carbCVal = protCVal = grasCVal = 0;
    calCtl.text = carbCtl.text = protCtl.text = grasCtl.text = '';
  }

  Future<void> add(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _load = true;
      });
      var added = false;
      if (_comida) {
        added = await dbHelper.addComida(
            nom: nomCtl.text,
            cant: double.parse(cantCtl.text),
            cal: double.parse(calCtl.text),
            carb: double.parse(carbCtl.text),
            prot: double.parse(protCtl.text),
            gras: double.parse(grasCtl.text));
      } else {
        added = await dbHelper.addIngesta(
            id: dropdownValue,
            cant: double.parse(cantCtl.text),
            cal: double.parse(calCtl.text),
            carb: double.parse(carbCtl.text),
            prot: double.parse(protCtl.text),
            gras: double.parse(grasCtl.text));
      }
      setState(() {
        _load = false;
      });
      if (added) {
        showSuccess(context);
      } else {
        showFail(context);
      }
    }
  }
}
