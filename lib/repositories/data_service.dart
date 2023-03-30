import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maptec/models/audiovisual_model.dart';
import 'package:maptec/models/cubiculo_model.dart';
import 'package:maptec/models/departamento_model.dart';
import 'package:maptec/models/laboratorio_model.dart';

class DataAPIService {
  //Declaramos la url base de la api
  static const _scheme = 'https';
  static const _host = 'administrador-mapa-virtual-itc.000webhostapp.com';

  //Declaramos las rutas que consumiremos
  static const _path1 = '/api/departamentos.php';
  static const _path2 = '/api/laboratorio.php';
  static const _path3 = '/api/audiovisual.php';
  static const _path4 = '/api/cubiculo.php';

  //Creamos las urls con los paths antes declarados
  static final Uri _url1 = Uri(
    scheme: _scheme,
    host: _host,
    path: _path1,
  );

  static final Uri _url2 = Uri(
    scheme: _scheme,
    host: _host,
    path: _path2,
  );

  static final Uri _url3 = Uri(
    scheme: _scheme,
    host: _host,
    path: _path3,
  );

  static final Uri _url4 = Uri(
    scheme: _scheme,
    host: _host,
    path: _path4,
  );

  //Creamos el metodo que nos permitira consumir la api
  static Future<List<dynamic>> getData() async {
    //Hacemos las peticiones a la api
    final response1 = await http.get(_url1);
    final response2 = await http.get(_url2);
    final response3 = await http.get(_url3);
    final response4 = await http.get(_url4);

    //Verificamos que las peticiones se hayan realizado correctamente
    if (response1.statusCode == 200 ||
        response2.statusCode == 200 ||
        response3.statusCode == 200 ||
        response4.statusCode == 200) {
      //Convertimos los bodies de las respuestas a jsons
      final json1 = jsonDecode(response1.body);

      final json2 = jsonDecode(response2.body);

      final json3 = jsonDecode(response3.body);

      final json4 = jsonDecode(response4.body);

      final results1 = json1;
      final results2 = json2;
      final results3 = json3;
      final results4 = json4;

      //Convertimos los jsons a lista de objetos de cada modelo
      final resDepartamento = results1
          .map<Departamento>((json) => Departamento.fromJson(json))
          .toList();
      final resLaboratorio = results2
          .map<Laboratorio>((json) => Laboratorio.fromJson(json))
          .toList();
      final resAudiovisual = results3
          .map<Audiovisual>((json) => Audiovisual.fromJson(json))
          .toList();
      final resCubiculo =
          results4.map<Cubiculo>((json) => Cubiculo.fromJson(json)).toList();

      //Retornamos una lista con las listas de objetos de cada modelo
      return [resDepartamento, resLaboratorio, resAudiovisual, resCubiculo];
    } else {
      throw Exception('Failed to load the data');
    }
  }
}
