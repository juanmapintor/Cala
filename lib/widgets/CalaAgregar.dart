import 'package:cala/helpers/DBHelper.dart';
import 'package:cala/helpers/Tuple.dart';
import 'package:flutter/material.dart';

import 'package:cala/widgets/configs/CalaColors.dart';
import 'package:flutter/scheduler.dart';

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
    if (!_comida) {
      getComidas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(10),
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
                      contEnabled = newValue != 'noid';
                      if (contEnabled) getMVals(newValue);
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
                      textInputAction:
                          _comida ? TextInputAction.next : TextInputAction.done,
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
                        add();
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
                        return (value == null || value.isEmpty || value == '')
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
            onPressed: add,
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child: Text('Agregar'),
          )
        ],
      ),
    );
  }

  void getMVals(String id) {
    var vals = dbHelper.getMVals(id);
    print('MVals recobidos: ');
    print(vals);
    cantMVal = vals[0];
    calMVal = vals[1];
    carbMVal = vals[2];
    protMVal = vals[3];
    grasMVal = vals[4];
  }

  void getComidas() {
    items.addAll(dbHelper.getComidas());
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

  void add() {
    if (_formKey.currentState!.validate()) {
      if (_comida) {
        dbHelper.addComida(
            nom: nomCtl.text,
            cant: double.parse(cantCtl.text),
            cal: double.parse(calCtl.text),
            carb: double.parse(carbCtl.text),
            prot: double.parse(protCtl.text),
            gras: double.parse(grasCtl.text));
      } else {
        dbHelper.addIngesta(
            id: dropdownValue,
            cant: double.parse(cantCtl.text),
            cal: double.parse(calCtl.text),
            carb: double.parse(carbCtl.text),
            prot: double.parse(protCtl.text),
            gras: double.parse(grasCtl.text));
      }
    }
  }
}
