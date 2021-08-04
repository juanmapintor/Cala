import 'dart:async';
import 'package:cala/helpers/datamodel/ObjetosNutricionales.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  late StreamController<String> _controller;
  late Stream broadcastStream;
  late final Future<Database> database;

  DBHelper() {
    _controller = new StreamController<String>();
    broadcastStream = _controller.stream.asBroadcastStream();
  }

  Future<bool> createDB() async {
    database = openDatabase(join(await getDatabasesPath(), 'cala_database.db'),
        onCreate: _onCreate, onConfigure: _onConfigure, version: 1);

    return (await database).isOpen;
  }

  static Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_key = ON');
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE UnidadNutricional(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      calorias REAL, 
      carbohidratos REAL, 
      proteinas REAL, 
      grasas REAL);
    ''');

    await db.execute('''
    CREATE TABLE UnidadNutricionalCuantificada(
      id INTEGER PRIMARY KEY, 
      cantidad REAL, 
      FOREIGN KEY (id) 
        REFERENCES UnidadNutricional(id) 
          ON DELETE CASCADE 
          ON UPDATE CASCADE
    );
    ''');

    await db.execute('''
    CREATE TABLE ObjetivoDiario(
      id INTEGER PRIMARY KEY, 
      FOREIGN KEY (id) 
        REFERENCES UnidadNutricional(id) 
          ON DELETE CASCADE 
          ON UPDATE CASCADE
    );
    ''');

    await db.execute('''
    CREATE TABLE Comida(
      id INTEGER PRIMARY KEY,
      nombre TEXT,
      FOREIGN KEY (id) 
        REFERENCES UnidadNutricionalCuantificada(id) 
          ON DELETE CASCADE 
          ON UPDATE CASCADE
    );
    ''');

    await db.execute('''
    CREATE TABLE Ingesta(
      idIngesta INTEGER PRIMARY KEY AUTOINCREMENT,
      idComida INTEGER NOT NULL,
      fecha TEXT,
      hora TEXT,
      cantidadIngesta REAL,
      FOREIGN KEY (idComida) 
        REFERENCES Comida(id) 
          ON DELETE CASCADE 
          ON UPDATE CASCADE
    );
    ''');

    await db.execute('''
    CREATE TABLE UnidadPesaje(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      peso REAL,
      porcGrasa REAL
    );
    ''');

    await db.execute('''
    CREATE TABLE ObjetivoGeneral(
      id INTEGER PRIMARY KEY, 
      FOREIGN KEY (id) 
        REFERENCES UnidadPesaje(id) 
          ON DELETE CASCADE 
          ON UPDATE CASCADE
    );
    ''');

    await db.execute('''
    CREATE TABLE Pesaje(
      id INTEGER PRIMARY KEY,
      fecha TEXT,
      FOREIGN KEY (id) 
        REFERENCES UnidadPesaje(id) 
          ON DELETE CASCADE 
          ON UPDATE CASCADE
    );
    ''');

    await db.execute('''
    CREATE TABLE Usuario(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      altura REAL
    );
    ''');

    await db.execute('PRAGMA foreign_key = ON');

    var _listaComidas = await _loadCSV();
    _listaComidas.forEach((infoComida) async {
      Comida comida = Comida(
        nombre: infoComida[0].toString(),
        cantidad:
            double.parse(infoComida[1].toString().replaceAll(RegExp(','), '.')),
        calorias:
            double.parse(infoComida[2].toString().replaceAll(RegExp(','), '.')),
        carbohidratos:
            double.parse(infoComida[3].toString().replaceAll(RegExp(','), '.')),
        proteinas:
            double.parse(infoComida[4].toString().replaceAll(RegExp(','), '.')),
        grasas:
            double.parse(infoComida[5].toString().replaceAll(RegExp(','), '.')),
      );
      final int uniNutriID = await db.rawInsert('''
    INSERT INTO UnidadNutricional(calorias, carbohidratos, proteinas, grasas) VALUES (?, ?, ?, ?);
    ''', [
        comida.calorias,
        comida.carbohidratos,
        comida.proteinas,
        comida.grasas
      ]);

      final int uniNutriCuantID = await db.rawInsert('''
    INSERT INTO UnidadNutricionalCuantificada(id, cantidad) VALUES (?, ?);
    ''', [uniNutriID, comida.cantidad]);

      await db.rawInsert('''
    INSERT INTO Comida(id, nombre) VALUES (?, ?)
    ''', [uniNutriCuantID, comida.nombre]);
    });
  }

  Future<List<Comida>> getListaComidas() async {
    final db = await database;
    final List<Map<String, dynamic>> comidaList = await db.rawQuery('''
        SELECT * FROM Comida 
        INNER JOIN UnidadNutricionalCuantificada 
          ON Comida.id = UnidadNutricionalCuantificada.id
        INNER JOIN UnidadNutricional
          ON UnidadNutricionalCuantificada.id = UnidadNutricional.id;
        ''');
    return comidaList
        .map((mapeo) => Comida.ided(
            id: mapeo['id'],
            nombre: mapeo['nombre'],
            cantidad: mapeo['cantidad'],
            calorias: mapeo['calorias'],
            carbohidratos: mapeo['carbohidratos'],
            proteinas: mapeo['proteinas'],
            grasas: mapeo['grasas']))
        .toList();
  }

  Future<Comida> getComida(int id) async {
    final db = await database;
    final Map<String, dynamic> comida = (await db.rawQuery('''
        SELECT * FROM Comida 
        INNER JOIN UnidadNutricionalCuantificada 
          ON Comida.id = UnidadNutricionalCuantificada.id
        INNER JOIN UnidadNutricional
          ON UnidadNutricionalCuantificada.id = UnidadNutricional.id
        WHERE Comida.id = ?;
        ''', [id])).first;

    return Comida(
        nombre: comida['nombre'],
        cantidad: comida['cantidad'],
        calorias: comida['calorias'],
        carbohidratos: comida['carbohidratos'],
        proteinas: comida['proteinas'],
        grasas: comida['grasas']);
  }

  Future<bool> addComida(Comida comida) async {
    final db = await database;
    final int uniNutriID = await db.rawInsert('''
    INSERT INTO UnidadNutricional(calorias, carbohidratos, proteinas, grasas) VALUES (?, ?, ?, ?);
    ''', [
      comida.calorias,
      comida.carbohidratos,
      comida.proteinas,
      comida.grasas
    ]);

    final int uniNutriCuantID = await db.rawInsert('''
    INSERT INTO UnidadNutricionalCuantificada(id, cantidad) VALUES (?, ?);
    ''', [uniNutriID, comida.cantidad]);

    final int comidaID = await db.rawInsert('''
    INSERT INTO Comida(id, nombre) VALUES (?, ?)
    ''', [uniNutriCuantID, comida.nombre]);

    _updateAll();

    return comidaID != 0;
  }

  Future<bool> deleteComida(int id) async {
    final db = await database;

    final int affRow =
        await db.delete('UnidadNutricional', where: 'id = ?', whereArgs: [id]);

    _updateAll();

    return affRow != 0;
  }

  Future<List<Ingesta>> getListaIngestas(String fecha) async {
    final db = await database;

    final List<Map<String, dynamic>> ingestaList = (await db.rawQuery('''
        SELECT * FROM Ingesta
        INNER JOIN Comida
          ON Ingesta.idComida = Comida.id
        INNER JOIN UnidadNutricionalCuantificada 
          ON Comida.id = UnidadNutricionalCuantificada.id
        INNER JOIN UnidadNutricional
          ON UnidadNutricionalCuantificada.id = UnidadNutricional.id
        WHERE Ingesta.fecha = ?;
        ''', [fecha]));

    return ingestaList
        .map(
          (mapeo) => Ingesta(
              id: mapeo['idIngesta'],
              nombre: mapeo['nombre'],
              cantidadIngesta: mapeo['cantidadIngesta'],
              fecha: mapeo['fecha'],
              hora: mapeo['hora'],
              calorias: (mapeo['cantidadIngesta'] * mapeo['calorias']) /
                  mapeo['cantidad'],
              carbohidratos:
                  (mapeo['cantidadIngesta'] * mapeo['carbohidratos']) /
                      mapeo['cantidad'],
              proteinas: (mapeo['cantidadIngesta'] * mapeo['proteinas']) /
                  mapeo['cantidad'],
              grasas: (mapeo['cantidadIngesta'] * mapeo['grasas']) /
                  mapeo['cantidad']),
        )
        .toList();
  }

  Future<bool> addIngesta(
      {required String comidaID, required double cantIngesta}) async {
    final db = await database;

    final int ingestID = await db.rawInsert('''
    INSERT INTO 
      Ingesta(idComida, fecha, hora, cantidadIngesta) 
    VALUES 
      (?, ?, ?, ?);
    ''', [
      comidaID,
      DateFormat('dd-MM-yyyy').format(DateTime.now()),
      DateFormat('Hm').format(DateTime.now()),
      cantIngesta
    ]);

    _updateAll();

    return ingestID != 0;
  }

  Future<bool> deleteIngesta(int id) async {
    final db = await database;

    final int affRow =
        await db.delete('Ingesta', where: 'idIngesta = ?', whereArgs: [id]);

    _updateAll();

    return affRow != 0;
  }

  Future<ObjetivoDiario> getObjetivoDiario() async {
    final db = await database;
    final objetivosList = await db.rawQuery('''
    SELECT * FROM ObjetivoDiario 
    INNER JOIN UnidadNutricional
      ON ObjetivoDiario.id = UnidadNutricional.id;
    ''');
    if (objetivosList.isEmpty)
      return ObjetivoDiario(
        calorias: 0,
        carbohidratos: 0,
        proteinas: 0,
        grasas: 0,
      );

    final Map<String, dynamic> mapeo = objetivosList.last;
    return ObjetivoDiario(
      calorias: mapeo['calorias'],
      carbohidratos: mapeo['carbohidratos'],
      proteinas: mapeo['proteinas'],
      grasas: mapeo['grasas'],
    );
  }

  Future<bool> addObjetivoDiario(ObjetivoDiario objetivo) async {
    final db = await database;

    final int uniNutriID = await db.rawInsert('''
    INSERT INTO UnidadNutricional(calorias, carbohidratos, proteinas, grasas) VALUES (?, ?, ?, ?);
    ''', [
      objetivo.calorias,
      objetivo.carbohidratos,
      objetivo.proteinas,
      objetivo.grasas
    ]);

    final int objID = await db.rawInsert('''
    INSERT INTO ObjetivoDiario(id) VALUES (?)
    ''', [uniNutriID]);

    _updateAll();
    return objID != 0;
  }

  Future<ObjetivoGeneral> getObjetivoGral() async {
    final db = await database;

    var listUsr = await db.query('Usuario');

    if (listUsr.isNotEmpty) {
      Map<String, dynamic> info = listUsr.last;
      final double altura = info['altura'];
      var listObj = await db.rawQuery('''
      SELECT * FROM ObjetivoGeneral
      INNER JOIN UnidadPesaje
        ON ObjetivoGeneral.id = UnidadPesaje.id;
      ''');
      if (listObj.isNotEmpty) {
        Map<String, dynamic> objetivo = listObj.last;
        return ObjetivoGeneral(
          peso: objetivo['peso'],
          imc: objetivo['peso'] / ((altura / 100) * (altura / 100)),
          porcGrasa: objetivo['porcGrasa'],
        );
      }
    }

    return ObjetivoGeneral(peso: 0, imc: 0, porcGrasa: 0);
  }

  Future<bool> addObjetivoGral(
      double peso, double altura, double porcGrasa) async {
    final db = await database;

    await db.rawInsert('''
    INSERT INTO Usuario(altura) VALUES (?);
    ''', [altura]);

    var uniPesID = await db.rawInsert('''
    INSERT INTO UnidadPesaje(peso, porcGrasa) VALUES (?, ?);
    ''', [peso, porcGrasa]);

    var objGralID = await db.rawInsert('''
    INSERT INTO ObjetivoGeneral(id) VALUES (?);
    ''', [uniPesID]);

    _updateAll();

    return objGralID != 0;
  }

  Future<bool> addPesaje(Pesaje pesaje) async {
    final db = await database;

    var uniPesID = await db.rawInsert('''
    INSERT INTO UnidadPesaje(peso, porcGrasa) VALUES (?, ?);
    ''', [pesaje.peso, pesaje.porcGrasa]);

    var pesID = await db.rawInsert('''
    INSERT INTO Pesaje(id, fecha) VALUES (?, ?);
    ''', [uniPesID, pesaje.fecha]);

    _updateAll();

    return pesID != 0;
  }

  Future<List<Pesaje>> getPesajes(int cantLast) async {
    final db = await database;

    final List<Map<String, dynamic>> listPesaje = await db.rawQuery('''
    SELECT * FROM Pesaje 
    INNER JOIN UnidadPesaje
      ON Pesaje.id = UnidadPesaje.id
    ORDER BY Pesaje.id DESC LIMIT ?;
    ''', [cantLast]);

    return listPesaje
        .map((mapeo) => Pesaje(
              fecha: mapeo['fecha'],
              peso: mapeo['peso'],
              porcGrasa: mapeo['porcGrasa'],
            ))
        .toList();
  }

  static Future<List<List<dynamic>>> _loadCSV() async {
    final _rawData = await rootBundle.loadString("lib/assets/datacomidas.csv");
    return CsvToListConverter().convert(_rawData);
  }

  void _updateAll() {
    _updateCatalogo();
    _updateMain();
    _updateObjetivos();
    _updateProgreso();
  }

  void _updateCatalogo() {
    _controller.add('updCat');
  }

  void _updateMain() {
    _controller.add('updMain');
  }

  void _updateObjetivos() {
    _controller.add('updObj');
  }

  void _updateProgreso() {
    _controller.add('updProg');
  }
}
