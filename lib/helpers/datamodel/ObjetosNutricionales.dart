class UnidadNutricional {
  var id = -1;
  late double calorias;
  late double carbohidratos;
  late double proteinas;
  late double grasas;

  UnidadNutricional({
    required this.calorias,
    required this.carbohidratos,
    required this.proteinas,
    required this.grasas,
  });

  UnidadNutricional.ided({
    required this.id,
    required this.calorias,
    required this.carbohidratos,
    required this.proteinas,
    required this.grasas,
  });

  @override
  String toString() {
    return id != -1
        ? 'UnidadNutricional {id: $id, calorias: $calorias, carbohidratos: $carbohidratos, proteinas: $proteinas, grasas: $grasas}'
        : 'UnidadNutricional {calorias: $calorias, carbohidratos: $carbohidratos, proteinas: $proteinas, grasas: $grasas}';
  }
}

class ObjetivoDiario extends UnidadNutricional {
  ObjetivoDiario({
    required double calorias,
    required double carbohidratos,
    required double proteinas,
    required double grasas,
  }) : super(
          calorias: calorias,
          carbohidratos: carbohidratos,
          proteinas: proteinas,
          grasas: grasas,
        );
}

class UnidadNutricionalCuantificada extends UnidadNutricional {
  late double cantidad;

  UnidadNutricionalCuantificada({
    required this.cantidad,
    required double calorias,
    required double carbohidratos,
    required double proteinas,
    required double grasas,
  }) : super(
          calorias: calorias,
          carbohidratos: carbohidratos,
          proteinas: proteinas,
          grasas: grasas,
        );

  UnidadNutricionalCuantificada.ided({
    required int id,
    required this.cantidad,
    required double calorias,
    required double carbohidratos,
    required double proteinas,
    required double grasas,
  }) : super.ided(
          id: id,
          calorias: calorias,
          carbohidratos: carbohidratos,
          proteinas: proteinas,
          grasas: grasas,
        );

  @override
  String toString() {
    return id != -1
        ? 'UnidadNutricionalCuantificada {id: $id, cantidad: $cantidad, calorias: $calorias, carbohidratos: $carbohidratos, proteinas: $proteinas, grasas: $grasas}'
        : 'UnidadNutricionalCuantificada {cantidad: $cantidad, calorias: $calorias, carbohidratos: $carbohidratos, proteinas: $proteinas, grasas: $grasas}';
  }
}

class Comida extends UnidadNutricionalCuantificada {
  late String nombre;

  Comida({
    required this.nombre,
    required double cantidad,
    required double calorias,
    required double carbohidratos,
    required double proteinas,
    required double grasas,
  }) : super(
          cantidad: cantidad,
          calorias: calorias,
          carbohidratos: carbohidratos,
          proteinas: proteinas,
          grasas: grasas,
        );

  Comida.ided({
    required int id,
    required this.nombre,
    required double cantidad,
    required double calorias,
    required double carbohidratos,
    required double proteinas,
    required double grasas,
  }) : super.ided(
          id: id,
          cantidad: cantidad,
          calorias: calorias,
          carbohidratos: carbohidratos,
          proteinas: proteinas,
          grasas: grasas,
        );
  @override
  String toString() {
    return nombre;
    /*
    return id != -1
        ? 'Comida {id: $id, nombre: $nombre, cantidad: $cantidad, calorias: $calorias, carbohidratos: $carbohidratos, proteinas: $proteinas, grasas: $grasas}'
        : 'Comida {nombre: $nombre, cantidad: $cantidad, calorias: $calorias, carbohidratos: $carbohidratos, proteinas: $proteinas, grasas: $grasas}';
    */
  }
}

class Ingesta {
  late int id;
  late String nombre;
  late double cantidadIngesta;
  late String fecha;
  late String hora;
  late double calorias;
  late double carbohidratos;
  late double proteinas;
  late double grasas;

  Ingesta(
      {required this.id,
      required this.nombre,
      required this.cantidadIngesta,
      required this.fecha,
      required this.hora,
      required this.calorias,
      required this.carbohidratos,
      required this.proteinas,
      required this.grasas});

  @override
  String toString() {
    return id != -1
        ? 'Ingesta {id: $id, nombre: $nombre, fecha: $fecha, hora: $hora, cantidad: $cantidadIngesta, calorias: $calorias, carbohidratos: $carbohidratos, proteinas: $proteinas, grasas: $grasas}'
        : 'Ingesta {nombre: $nombre, fecha: $fecha, hora: $hora, cantidad: $cantidadIngesta, calorias: $calorias, carbohidratos: $carbohidratos, proteinas: $proteinas, grasas: $grasas}';
  }
}

class UnidadPesaje {
  var id = -1;
  late double peso;
  late double porcGrasa;

  UnidadPesaje({
    required this.peso,
    required this.porcGrasa,
  });

  UnidadPesaje.ided({
    required this.id,
    required this.peso,
    required this.porcGrasa,
  });

  @override
  String toString() {
    return id != -1
        ? 'UnidadPesaje {id: $id, peso: $peso, porcGrasa: $porcGrasa}'
        : 'UnidadPesaje {peso: $peso, porcGrasa: $porcGrasa}';
  }
}

class ObjetivoGeneral extends UnidadPesaje {
  late double imc;
  ObjetivoGeneral({
    required double peso,
    required this.imc,
    required double porcGrasa,
  }) : super(
          peso: peso,
          porcGrasa: porcGrasa,
        );
}

class Pesaje extends UnidadPesaje {
  late String fecha;

  Pesaje({
    required this.fecha,
    required double peso,
    required double porcGrasa,
  }) : super(
          peso: peso,
          porcGrasa: porcGrasa,
        );

  Pesaje.ided({
    required int id,
    required this.fecha,
    required double peso,
    required double porcGrasa,
  }) : super.ided(
          id: id,
          peso: peso,
          porcGrasa: porcGrasa,
        );

  @override
  String toString() {
    return id != -1
        ? 'Pesaje {id: $id, fecha: $fecha, peso: $peso, porcGrasa: $porcGrasa}'
        : 'Pesaje {fecha: $fecha, peso: $peso, porcGrasa: $porcGrasa}';
  }
}
