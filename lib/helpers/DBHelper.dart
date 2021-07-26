import 'dart:async';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  late StreamController<String> _controller;
  late Stream broadcastStream;

  DBHelper() {
    _controller = new StreamController<String>();
    broadcastStream = _controller.stream.asBroadcastStream();
  }
}
