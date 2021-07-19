import 'dart:async';

import 'package:cala/main.dart';

class DBHelper {
  late StreamController<String> _controller;
  late Stream mainPageStream;

  DBHelper() {
    _controller = new StreamController<String>();
    mainPageStream = _controller.stream;
  }

  void hacerAlgo(String s) {
    _controller.add(s);
  }
}
