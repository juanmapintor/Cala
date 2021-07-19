import 'package:cala/helpers/DBHelper.dart';
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
        child: Text('Agregar' + (comida ? ' comida.' : ' ingesta.')),
      ),
    );
  }
}
