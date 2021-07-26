class UnidadNutricional {
  double calorias;
  double carbohidratos;
  double proteinas;
  double grasa;

  UnidadNutricional(
      this.calorias, this.carbohidratos, this.proteinas, this.grasa);
}

class UnidadNutricionalCuantificada extends UnidadNutricional {
  double cantidad;

  UnidadNutricionalCuantificada(this.cantidad, double calorias,
      double carbohidratos, double proteinas, double grasa)
      : super(calorias, carbohidratos, proteinas, grasa);
}

class Comida extends UnidadNutricionalCuantificada {
  int id;
  String nombre;

  Comida(this.id, this.nombre, double cantidad, double calorias,
      double carbohidratos, double proteinas, double grasa)
      : super(cantidad, calorias, carbohidratos, proteinas, grasa);
}

class Ingesta extends Comida {
  String horario;

  Ingesta(int id, String nombre, this.horario, double cantidad, double calorias,
      double carbohidratos, double proteinas, double grasa)
      : super(id, nombre, cantidad, calorias, carbohidratos, proteinas, grasa);
}

class UnidadPesaje {
  double peso;
  double porcGrasa;
  UnidadPesaje(this.peso, this.porcGrasa);
}

class Pesaje extends UnidadPesaje {
  DateTime fecha;

  Pesaje(this.fecha, double peso, double porcGrasa) : super(peso, porcGrasa);
}
