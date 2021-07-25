import 'dart:async';
import 'dart:math';

import 'package:cala/helpers/IngestaHistorial.dart';
import 'package:cala/helpers/Tuple.dart';

class DBHelper {
  late StreamController<String> _controller;
  late Stream broadcastStream;

  DBHelper() {
    _controller = new StreamController<String>();
    broadcastStream = _controller.stream.asBroadcastStream();
  }

  Future<List<Tuple<String, String>>> getComidasNameID() async {
    print('Comidas pedidas');
    return Future.delayed(
      Duration(seconds: 3),
      () => [
        Tuple('id1', 'Comida 1'),
        Tuple('id2', 'Comida 2'),
        Tuple('id3', 'Comida 3'),
      ],
    );
  }

  Future<List<IngestaHistorial>> getIngestas(String fecha) {
    var ingestas = <IngestaHistorial>[];

    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random _rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    for (int i = 0; i < 15; i++) {
      ingestas.add(IngestaHistorial(
          getRandomString(5),
          _rnd.nextInt(23).toString() + ':' + _rnd.nextInt(59).toString(),
          getRandomString(10),
          _rnd.nextDouble() * 100,
          _rnd.nextDouble() * 100,
          _rnd.nextDouble() * 100,
          _rnd.nextDouble() * 100,
          _rnd.nextDouble() * 100));
    }

    return Future.delayed(Duration(seconds: 3), () => ingestas);
  }

  Future<List<IngestaHistorial>> getComidas() {
    var ingestas = <IngestaHistorial>[];

    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random _rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    for (int i = 0; i < 15; i++) {
      ingestas.add(IngestaHistorial(
          getRandomString(5),
          'NA',
          getRandomString(10),
          _rnd.nextDouble() * 100,
          _rnd.nextDouble() * 100,
          _rnd.nextDouble() * 100,
          _rnd.nextDouble() * 100,
          _rnd.nextDouble() * 100));
    }

    return Future.delayed(Duration(seconds: 3), () => ingestas);
  }

  Future<List<double>> getMVals(String id) {
    print('Pedidos MVals de comida id: $id');
    var random = Random();
    return Future.delayed(
      Duration(seconds: 3),
      () => [
        random.nextDouble() * 100,
        random.nextDouble() * 1000,
        random.nextDouble() * 500,
        random.nextDouble() * 500,
        random.nextDouble() * 500
      ],
    );
  }

  Future<List<double>> getObjetivosMVals() {
    var random = Random();
    return Future.delayed(
      Duration(seconds: 3),
      () => [
        random.nextDouble() * 1000,
        random.nextDouble() * 500,
        random.nextDouble() * 500,
        random.nextDouble() * 500
      ],
    );
  }

  Future<bool> addComida(
      {required String nom,
      required double cant,
      required double cal,
      required double carb,
      required double prot,
      required double gras}) async {
    return Future.delayed(Duration(seconds: 3), () {
      print('Comida agregada.');
      print('Nombre: $nom');
      print('Cantidad: $cant');
      print('Calorias: $cal');
      print('Carbohidratos: $carb');
      print('Proteinas: $prot');
      print('Grasa: $gras');
      _controller.add('updCat');
      return true;
    });
  }

  Future<bool> addIngesta(
      {required String id,
      required double cant,
      required double cal,
      required double carb,
      required double prot,
      required double gras}) async {
    return Future.delayed(Duration(seconds: 3), () {
      print('Ingesta agregada.');
      print('Comida id: $id');
      print('Cantidad: $cant');
      print('Calorias: $cal');
      print('Carbohidratos: $carb');
      print('Proteinas: $prot');
      print('Grasa: $gras');
      _controller.add('updMain');
      return true;
    });
  }

  Future<bool> addObjetivoDiario(
      double cal, double carb, double prot, double gras) {
    return Future.delayed(Duration(seconds: 3), () {
      print('Objetivo diario agregado');
      print('Calorias: $cal');
      print('Carbohidratos: $carb');
      print('Proteinas: $prot');
      print('Grasa: $gras');
      _controller.add('updObj');
      return true;
    });
  }

  Future<bool> addObjetivoGral(double peso, double alt, double gras) {
    return Future.delayed(Duration(seconds: 3), () {
      print('Objetivo general agregado');
      print('Peso: $peso');
      print('Altura: $alt');
      print('Grasa: $gras');
      _controller.add('updObj');
      return true;
    });
  }

  Future<bool> addPesaje(double peso, double gras) {
    return Future.delayed(Duration(seconds: 3), () {
      print('Pesaje agregado');
      print('Fecha: ' + DateTime.now().toLocal().toString());
      print('Peso: $peso');
      print('Grasa: $gras');
      _controller.add('updProg');
      return true;
    });
  }

  Future<bool> deleteIngesta(String id) async =>
      Future.delayed(Duration(seconds: 3), () {
        print('Eliminada ingesta id: $id');
        return true;
      });
  Future<bool> deleteComida(String id) async =>
      Future.delayed(Duration(seconds: 3), () {
        print('Eliminada ingesta id: $id');
        return true;
      });

  Future<List<double>> getLatestObjetivosGral() {
    var random = Random();
    return Future.delayed(
      Duration(seconds: 3),
      () => [80, random.nextDouble() * 150, random.nextDouble() * 100],
    );
  }

  Future<List<Tuple<double, DateTime>>> getPesos(int dias) {
    return Future.delayed(Duration(seconds: 1), () {
      List<Tuple<double, DateTime>> list = [
        Tuple(114, DateTime(2021, 2, 9)),
        Tuple(110, DateTime(2021, 2, 16)),
        Tuple(108, DateTime(2021, 2, 27)),
        Tuple(102, DateTime(2021, 3, 14)),
        Tuple(100, DateTime(2021, 3, 19)),
        Tuple(96, DateTime(2021, 3, 27)),
        Tuple(96, DateTime(2021, 4, 6)),
        Tuple(96, DateTime(2021, 4, 10)),
        Tuple(96, DateTime(2021, 4, 16)),
      ];

      return list;
    });
  }

  Future<List<Tuple<double, DateTime>>> getPorcentajesGrasa(int dias) {
    return Future.delayed(Duration(seconds: 1), () {
      var random = Random();
      DateTime initial = DateTime.now();
      List<Tuple<double, DateTime>> list = [
        Tuple(random.nextDouble() * 100, initial)
      ];
      for (int i = 1; i < 6; i++) {
        DateTime nDT = initial.add(Duration(days: i * 7));
        list.add(Tuple(random.nextDouble() * 100, nDT));
        initial = nDT;
      }
      return list;
    });
  }

  Future<List<Tuple<double, DateTime>>> getIMCs(int dias) {
    return Future.delayed(Duration(seconds: 1), () {
      var random = Random();
      DateTime initial = DateTime.now();
      List<Tuple<double, DateTime>> list = [
        Tuple(random.nextDouble() * 50, initial)
      ];
      for (int i = 1; i < 6; i++) {
        DateTime nDT = initial.add(Duration(days: i * 7));
        list.add(Tuple(random.nextDouble() * 50, nDT));
        initial = nDT;
      }
      return list;
    });
  }
}
