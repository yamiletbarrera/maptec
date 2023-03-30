class Laboratorio {
  String? idLaboratorio;
  String? nombre;
  Edificio? edificio;

  Laboratorio({this.idLaboratorio, this.nombre, this.edificio});

  Laboratorio.fromJson(Map<String, dynamic> json) {
    idLaboratorio = json['id_laboratorio'];
    nombre = json['nombre'];
    edificio = json['edificicio'] != null
        ? Edificio.fromJson(json['edificicio'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id_laboratorio'] = idLaboratorio;
    data['nombre'] = nombre;
    if (edificio != null) {
      data['edificicio'] = edificio!.toJson();
    }
    return data;
  }
}

class Edificio {
  String? idEdificio;
  String? nombre;
  String? numaulas;

  //Método constructor
  Edificio({this.idEdificio, this.nombre, this.numaulas});

  //Método para convertir de Maps a Objetos de Clase
  Edificio.fromJson(Map<String, dynamic> json) {
    idEdificio = json['id_edificio'];
    nombre = json['nombre'];
    numaulas = json['numaulas'];
  }

  //Método para convertir de Objetos de Clase a Maps
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id_edificio'] = idEdificio;
    data['nombre'] = nombre;
    data['numaulas'] = numaulas;
    return data;
  }
}
