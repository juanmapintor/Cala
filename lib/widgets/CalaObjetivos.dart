import 'package:cala/helpers/DBHelper.dart';
import 'package:flutter/material.dart';

import 'package:cala/widgets/configs/CalaColors.dart';

class CalaObjetivos extends StatelessWidget {
  final DBHelper dbHelper;
  CalaObjetivos(this.dbHelper);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Objetivos'),
        backgroundColor: CalaColors.mainTealColor,
      ),
      body: Center(
        child: Text('Objetivos'),
      ),
    );
  }
}
