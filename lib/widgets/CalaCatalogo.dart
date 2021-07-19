import 'package:cala/helpers/DBHelper.dart';
import 'package:flutter/material.dart';

import 'package:cala/widgets/configs/CalaColors.dart';

class CalaCatalogo extends StatelessWidget {
  final DBHelper dbHelper;
  CalaCatalogo(this.dbHelper);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalogo'),
        backgroundColor: CalaColors.mainTealColor,
      ),
      body: Center(
        child: Text('Catalogo'),
      ),
    );
  }
}
