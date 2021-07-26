import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  late StreamController<String> _controller;
  late Stream broadcastStream;
  late final Database db;

  DBHelper() {
    _controller = new StreamController<String>();
    broadcastStream = _controller.stream.asBroadcastStream();
  }

  Future<bool> createDB() async {
    db = await openDatabase(join(await getDatabasesPath(), 'cala_database.db'),
        onCreate: (dbV, version) {
      return dbV.execute(
          'CREATE TABLE UnidadNutricional(id INTEGER PRIMARY KEY AUTOINCREMENT, calorias REAL, carbohidratos REAL, proteinas REAL, grasas REAL)');
    }, version: 1);
    return db.isOpen;
  }
}
