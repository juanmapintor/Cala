import 'package:cala/helpers/DBHelper.dart';
import 'package:flutter/material.dart';

import 'package:cala/widgets/configs/CalaColors.dart';

class CalaProgreso extends StatelessWidget {
  final DBHelper dbHelper;
  CalaProgreso(this.dbHelper);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progreso'),
        backgroundColor: CalaColors.mainTealColor,
      ),
      body: Center(
        child: Text('Progreso'),
      ),
    );
  }
}
