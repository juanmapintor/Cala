import 'package:cala/widgets/configs/CalaColors.dart';
import 'package:cala/widgets/contents/CalaContents.dart';
import 'package:flutter/material.dart';

class CalaWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CalaColors.mainTealColor,
      body: Center(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Expanded(
                child: Image.asset(
                  'lib/assets/cala_icon.png',
                  height: 200,
                ),
              ),
              Expanded(
                child: Center(
                  child: CalaContents.headline1(
                    text: 'Cala',
                    light: true,
                  ),
                ),
              ),
              Expanded(
                child: CalaContents.waitingWidget(light: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
