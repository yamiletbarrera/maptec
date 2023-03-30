import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:maptec/blocs/data_api_bloc.dart';
import 'package:maptec/blocs/input_search_bloc.dart';
import 'package:maptec/blocs/shared_preferences_bloc.dart';
import 'package:maptec/blocs/theme_bloc.dart';
import 'package:maptec/blocs/connectivity_bloc.dart';

class OfflineBottomBar extends StatelessWidget {
  const OfflineBottomBar({super.key});

  fetchData(DataApiBloc dataAPI) async {
    await dataAPI.fetchData();
    print("Se cargo la data despues de recuperar la conexión");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final network = Provider.of<ConnectivityBloc>(context);
    final dataAPI = Provider.of<DataApiBloc>(context);
    final input = Provider.of<InputSearchBloc>(context);
    final themeBloc = Provider.of<ThemeBloc>(context);
    final spDB = Provider.of<SharedPreferencesBloc>(context);

    //Cargamos los datos por primera vez si es que la app no tenia acceso a internet hasta este momento.
    if (network.status == NetworkStatus.online) {
      if ((dataAPI.departamentos.isEmpty ||
              dataAPI.laboratorios.isEmpty ||
              dataAPI.salasAudiovisuales.isEmpty ||
              dataAPI.cubiculos.isEmpty) &&
          DataApiBloc.count == 2) {
        //Pedimos los datos del servidor web
        Future.delayed(Duration.zero, () {
          fetchData(dataAPI);
        });
      } else {
        //Guardamos los datos en el input y la bd si no contienen nada.
        if (input.data.isEmpty) {
          if (dataAPI.departamentos.isNotEmpty ||
              dataAPI.laboratorios.isNotEmpty ||
              dataAPI.salasAudiovisuales.isNotEmpty ||
              dataAPI.cubiculos.isNotEmpty) {
            final List<dynamic> listDataAPI = [
              dataAPI.departamentos,
              dataAPI.laboratorios,
              dataAPI.salasAudiovisuales,
              dataAPI.cubiculos
            ];

            input.data = listDataAPI;
            print("input - cargando datos de la API - offline_status");

            //Guardamos la data en la base de datos local
            if (spDB.sharedPreferencesDB.isNotEmpty) {
              //Checamos si la data de la API es diferente a la data de la base de datos local
              //Si es diferente, entonces guardamos la data de la API en la base de datos local.
              if (spDB.sharedPreferencesDB[0].data !=
                  json.encode(listDataAPI)) {
                print("guardando en la base de datos - offline_status");
                spDB.addSharedPreferences(
                    1, themeBloc.getIsDark(), json.encode(listDataAPI));
              }
            } else {
              print(
                  "guardando en la base de datos por primera vez - offline_status");
              spDB.addSharedPreferences(
                  1, themeBloc.getIsDark(), json.encode(listDataAPI));
            }
          }
        }
      }
    }

    return Visibility(
      visible: network.status == NetworkStatus.offline,
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 40,
        color: theme.colorScheme.error,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Icon(Icons.wifi_off, color: theme.colorScheme.onError),
          Text('Estás sin conexión a internet',
              style: theme.textTheme.labelLarge
                  ?.copyWith(color: theme.colorScheme.onError))
        ]),
      ),
    );
  }
}
