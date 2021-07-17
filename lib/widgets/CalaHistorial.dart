import 'package:flutter/material.dart';

import 'package:cala/widgets/configs/CalaColors.dart';

class CalaHistorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial'),
        backgroundColor: CalaColors.mainTealColor,
      ),
      body: Center(
        child: Text('Historial'),
      ),
    );
  }
}
