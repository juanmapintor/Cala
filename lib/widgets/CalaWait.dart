import 'package:flutter/material.dart';

class CalaWait extends StatelessWidget {
  const CalaWait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Align(
          child: new Container(
            width: 70.0,
            height: 70.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          ),
          alignment: FractionalOffset.center,
        ),
      ),
    );
  }
}
