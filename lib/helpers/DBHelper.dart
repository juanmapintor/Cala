import 'dart:async';
import 'dart:math';

import 'package:cala/helpers/Tuple.dart';

class DBHelper {
  late StreamController<String> _controller;
  late Stream mainPageStream;

  DBHelper() {
    _controller = new StreamController<String>();
    mainPageStream = _controller.stream;
  }

  List<Tuple<String, String>> getComidas() {
    print('Comidas pedidas');
    return [
      Tuple('id1', 'Comida 1'),
      Tuple('id2', 'Comida 2'),
      Tuple('id3', 'Comida 3')
    ];
  }

  List<double> getMVals(String id) {
    print('Pedidos MVals de comida id: $id');
    var random = Random();
    return [
      random.nextDouble() * 100,
      random.nextDouble() * 1000,
      random.nextDouble() * 500,
      random.nextDouble() * 500,
      random.nextDouble() * 500
    ];
  }

  void addComida(
      {required String nom,
      required double cant,
      required double cal,
      required double carb,
      required double prot,
      required double gras}) {
    print('Comida agregada.');
    print('Nombre: $nom');
    print('Cantidad: $cant');
    print('Calorias: $cal');
    print('Carbohidratos: $carb');
    print('Proteinas: $prot');
    print('Grasa: $gras');
  }

  void addIngesta(
      {required String id,
      required double cant,
      required double cal,
      required double carb,
      required double prot,
      required double gras}) {
    print('Ingesta agregada.');
    print('Comida id: $id');
    print('Cantidad: $cant');
    print('Calorias: $cal');
    print('Carbohidratos: $carb');
    print('Proteinas: $prot');
    print('Grasa: $gras');
  }
}
