import 'package:cala/widgets/configs/CalaColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class MainPageContent extends StatefulWidget {
  @override
  _MainPageContentState createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Text(
            'Macros',
            style: TextStyle(
                color: CalaColors.textDark,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 250,
                  child: FAProgressBar(
                    maxValue: 1000,
                    currentValue: 750,
                    direction: Axis.vertical,
                    verticalDirection: VerticalDirection.up,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    border:
                        Border.all(color: Colors.red, style: BorderStyle.solid),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 250,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                child: Container(
                  height: 250,
                  color: Colors.yellow,
                ),
              ),
              Expanded(
                child: Container(
                  height: 250,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Calorias',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Carbohidratos',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Proteinas',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Grasas',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
