import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:maptec/blocs/data_api_bloc.dart';
import 'package:maptec/blocs/shared_preferences_bloc.dart';
import 'package:maptec/models/audiovisual_model.dart';
import 'package:maptec/models/cubiculo_model.dart';
import 'package:maptec/models/laboratorio_model.dart';
import 'package:maptec/presentation/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:maptec/blocs/theme_bloc.dart';
import 'package:maptec/blocs/input_search_bloc.dart';
import 'package:maptec/models/departamento_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    //Wait 7 seconds and then navigate to Home Page
    Future.delayed(
        const Duration(seconds: 7),
        () => Navigator.pushReplacement(
              context,
              _createRouteWithAnimation(),
            ));
  }

  Route _createRouteWithAnimation() {
    return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            Home(),
        transitionDuration: const Duration(milliseconds: 1500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curveAnimation =
              CurvedAnimation(parent: animation, curve: Curves.easeInOut);
          return SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                    .animate(curveAnimation),
            child: child,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeBloc>(context);
    final themeScheme = Theme.of(context).colorScheme;
    final dataAPI = Provider.of<DataApiBloc>(context);
    final spDB = Provider.of<SharedPreferencesBloc>(context);
    final input = Provider.of<InputSearchBloc>(context);

    //Cuando la app cargo la data exitosamente de la API
    if (dataAPI.homeState == HomeState.loaded) {
      //Guardamos tambien la data en el estado global en el InputSearchBloc
      //para poderlo usar despues en las busquedas del input.

      //DONE: hacer una validación por si el input.data no esta vacio, entonces no sobreescribirlo.
      if (input.data.isEmpty) {
        final List<dynamic> listDataAPI = [
          dataAPI.departamentos,
          dataAPI.laboratorios,
          dataAPI.salasAudiovisuales,
          dataAPI.cubiculos
        ];
        input.data = listDataAPI;
        print("input - cargando datos de la API - sc");
        //print("input - data: ${input.data}");
        //Guardamos la data en la base de datos local
        if (spDB.sharedPreferencesDB.isNotEmpty) {
          //Checamos si la data de la API es diferente a la data de la base de datos local
          //Si es diferente, entonces guardamos la data de la API en la base de datos local.
          if (spDB.sharedPreferencesDB[0].data != json.encode(listDataAPI)) {
            print("guardando en la base de datos");
            spDB.addSharedPreferences(
                1, theme.getIsDark(), json.encode(listDataAPI));
          }

          //Si no cargo los datos de la API, entonces cargamos los datos de la base de datos local
          if (input.data.isEmpty) {
            print("input - cargando datos de la base de datos - sc");
            input.data = json.decode(spDB.sharedPreferencesDB[0].data);

            for (var i = 0; i < input.data.length; i++) {
              for (var j = 0; j < input.data[i].length; j++) {
                switch (i) {
                  case 0:
                    input.data[i][j] = Departamento.fromJson(input.data[i][j]);
                    break;
                  case 1:
                    input.data[i][j] = Laboratorio.fromJson(input.data[i][j]);
                    break;
                  case 2:
                    input.data[i][j] = Audiovisual.fromJson(input.data[i][j]);
                    break;
                  case 3:
                    input.data[i][j] = Cubiculo.fromJson(input.data[i][j]);
                    break;
                }
              }
            }
          }
        } else {
          print("guardando en la base de datos por primera vez");
          spDB.addSharedPreferences(
              1, theme.getIsDark(), json.encode(listDataAPI));
        }
      }
    }

    //Cuando la app no puede obtener la data de la API
    if (dataAPI.homeState == HomeState.error ||
        (dataAPI.homeState == HomeState.loading && DataApiBloc.count == 1)) {
      if (spDB.sharedPreferencesDB.isNotEmpty && input.data.isEmpty) {
        print("input - sharedPreferencesDB - sc");

        input.data = json.decode(spDB.sharedPreferencesDB[0].data);

        for (var i = 0; i < input.data.length; i++) {
          for (var j = 0; j < input.data[i].length; j++) {
            switch (i) {
              case 0:
                input.data[i][j] = Departamento.fromJson(input.data[i][j]);
                break;
              case 1:
                input.data[i][j] = Laboratorio.fromJson(input.data[i][j]);
                break;
              case 2:
                input.data[i][j] = Audiovisual.fromJson(input.data[i][j]);
                break;
              case 3:
                input.data[i][j] = Cubiculo.fromJson(input.data[i][j]);
                break;
            }
          }
        }
      }
    }

    //Definimos las preferencias del usuario en el tema
    Future.delayed(Duration.zero, () {
      if (spDB.sharedPreferencesDB.isNotEmpty) {
        theme.setTheme(spDB.sharedPreferencesDB[0].isDark);
      }
    });

    return Scaffold(
        backgroundColor: themeScheme.background,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                image: AssetImage(theme.getIsDark()
                    ? "assets/image/logoDark.png"
                    : "assets/image/logo.png"),
                width: 280,
              ),
              const SizedBox(
                height: 28,
              ),
              SpinKitFadingCube(
                color: themeScheme.primary,
                size: 50.0,
                duration: const Duration(milliseconds: 800),
              ),
            ],
          ),
        ));
  }
}
