import 'package:flutter/material.dart';
import 'package:maptec/models/audiovisual_model.dart';
import 'package:maptec/models/cubiculo_model.dart';
import 'package:maptec/models/laboratorio_model.dart';
import 'package:maptec/repositories/data_service.dart';
import 'package:maptec/models/departamento_model.dart';

enum HomeState { initial, loading, loaded, error }

class DataApiBloc extends ChangeNotifier {
  static int count = 1;
  HomeState _homeState = HomeState.initial;
  List<Departamento> departamentos = [];
  List<Laboratorio> laboratorios = [];
  List<Audiovisual> salasAudiovisuales = [];
  List<Cubiculo> cubiculos = [];
  String messageError = "";

  DataApiBloc() {
    fetchData();
  }

  HomeState get homeState => _homeState;

  Future<void> fetchData() async {
    _homeState = HomeState.loading;
    try {
      final dataApi = await DataAPIService.getData();
      departamentos = dataApi[0];
      laboratorios = dataApi[1];
      salasAudiovisuales = dataApi[2];
      cubiculos = dataApi[3];

      _homeState = HomeState.loaded;
    } catch (e) {
      messageError = e.toString();
      _homeState = HomeState.error;
    }
    count++;
    notifyListeners();
  }
}
