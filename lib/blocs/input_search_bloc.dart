import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maptec/models/audiovisual_model.dart';
import 'package:maptec/models/cubiculo_model.dart';
import 'package:maptec/models/departamento_model.dart';
import 'package:maptec/models/laboratorio_model.dart';

class InputSearchBloc extends ChangeNotifier {
  dynamic data;
  List<dynamic> searchedData;
  dynamic selectedData;
  int typeSearch;
  String messageError;

  //Constructor
  InputSearchBloc(
      {this.data = const [],
      this.selectedData,
      this.searchedData = const [],
      this.messageError = "ninguno",
      this.typeSearch = 1});

  //Método de busqueda
  FutureOr<List<dynamic>> search(String value) {
    dynamic auxFiltered = [];

    //Si el input está vacío
    if (value == "") {
      selectedData = null;
      messageError = "";

      return searchedData;
    }

    //Si hay datos en data
    if (data.isNotEmpty) {
      //Buscar entidad por nombre
      auxFiltered = data[typeSearch - 1]
          .where((entity) =>
              entity.nombre.toLowerCase().contains(value.toLowerCase())
                  ? true
                  : false)
          .toList();

      //Asignar a searchedData el resultado de la busqueda segun el tipo de entida
      switch (typeSearch) {
        case 1:
          searchedData = List<Departamento>.from(auxFiltered);
          break;
        case 2:
          searchedData = List<Laboratorio>.from(auxFiltered);
          break;
        case 3:
          searchedData = List<Audiovisual>.from(auxFiltered);
          break;
        case 4:
          searchedData = List<Cubiculo>.from(auxFiltered);
          break;
      }

      if (searchedData.isEmpty) {
        messageError = "No hay resultados";
      } else {
        messageError = "ninguno";
      }
    } else {
      switch (typeSearch) {
        case 1:
          messageError = "No hay departamentos para buscar";
          break;
        case 2:
          messageError = "No hay laboratorios para buscar";
          break;
        case 3:
          messageError = "No hay salas audiovisuales para buscar";
          break;
        case 4:
          messageError = "No hay cubículos para buscar";
          break;
        default:
          messageError = "No hay datos para buscar";
      }
    }

    return searchedData;
  }

  setSelectedEntity(dynamic entity) {
    selectedData = entity;
    notifyListeners();
  }

  setTypeSearch(int type) {
    typeSearch = type;
    notifyListeners();
  }

  setSearchedData(List<dynamic> sD) {
    searchedData = sD;
    notifyListeners();
  }
}
