import 'package:maptec/utils/static_data.dart';

class Departamento {
  String? idDepartamento;
  String? nombre;
  Edificio? edificio;
  JefeDepartamento? jefeDepartamento;
  String? linkInfo;
  Cita? cita;
  Video? video;

  //Método constructor
  Departamento(
      {this.idDepartamento,
      this.nombre,
      this.edificio,
      this.jefeDepartamento,
      this.linkInfo,
      this.cita,
      this.video});

  //Método para convertir de Maps a Objetos de Clase
  Departamento.fromJson(Map<String, dynamic> json) {
    idDepartamento = json['id_departamento'];
    nombre = json['nombre'];
    edificio = json['edificicio'] != null
        ? Edificio.fromJson(json['edificicio'])
        : null;
    jefeDepartamento = json['JefeDepartamento'] != null
        ? JefeDepartamento.fromJson(json['JefeDepartamento'])
        : null;
    cita = json['cita'] != null ? Cita.fromJson(json['cita']) : null;
    video = json['video'] != null ? Video.fromJson(json['video']) : null;
    if (linksDepartamentos.containsKey("${json["nombre"]}")) {
      linkInfo = linksDepartamentos["${json['nombre']}"];
    } else {
      linkInfo = null;
    }
  }

  //Método para convertir de Objetos de Clase a Maps
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id_departamento'] = idDepartamento;
    data['nombre'] = nombre;
    if (edificio != null) {
      data['edificicio'] = edificio!.toJson();
    }
    if (jefeDepartamento != null) {
      data['JefeDepartamento'] = jefeDepartamento!.toJson();
    }
    if (cita != null) {
      data['cita'] = cita!.toJson();
    }
    if (video != null) {
      data['video'] = video!.toJson();
    }

    data['linkInfo'] = linkInfo;
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

class JefeDepartamento {
  String? idJefeDepartamento;
  String? nombre;
  String? correo;

  //Método constructor
  JefeDepartamento({this.idJefeDepartamento, this.nombre, this.correo});

  //Método para convertir de Maps a Objetos de Clase
  JefeDepartamento.fromJson(Map<String, dynamic> json) {
    idJefeDepartamento = json['id_jefeDepartamento'];
    nombre = json['nombre'];
    correo = json['correo'];
  }

  //Método para convertir de Objetos de Clase a Maps
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id_jefeDepartamento'] = idJefeDepartamento;
    data['nombre'] = nombre;
    data['correo'] = correo;
    return data;
  }
}

class Cita {
  String? urlCita;

  //Método constructor
  Cita({this.urlCita});

  //Método para convertir de Maps a Objetos de Clase
  Cita.fromJson(Map<String, dynamic> json) {
    urlCita = json['url_cita'];
  }

  //Método para convertir de Objetos de Clase a Maps
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url_cita'] = urlCita;
    return data;
  }
}

class Video {
  String? urlVideo;

  //Método constructor
  Video({this.urlVideo});

  //Método para convertir de Maps a Objetos de Clase
  Video.fromJson(Map<String, dynamic> json) {
    urlVideo = json['url_video'];
  }

  //Método para convertir de Objetos de Clase a Maps
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url_video'] = urlVideo;
    return data;
  }
}
