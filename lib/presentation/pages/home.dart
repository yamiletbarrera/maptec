import 'dart:convert';
import 'package:background_location_tracker/background_location_tracker.dart';
import 'package:flutter/material.dart';
import 'package:maptec/main.dart';
import 'package:maptec/presentation/pages/user_manual.dart';
import 'package:provider/provider.dart';
import 'package:maptec/blocs/theme_bloc.dart';
import 'package:maptec/blocs/gps_bloc.dart';
import 'package:maptec/blocs/data_api_bloc.dart';
import 'package:maptec/blocs/shared_preferences_bloc.dart';
import 'package:maptec/presentation/widgets/bottom_sheet_modal.dart';
import 'package:maptec/presentation/widgets/gps_access.dart';
import 'package:maptec/presentation/widgets/offline_status.dart';
import 'package:maptec/presentation/widgets/input_search.dart';

class Home extends StatelessWidget {
  Route _createRouteWithAnimation() {
    return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            UserManual(
              pdfAssetPath: 'assets/pdf/manual.pdf',
            ),
        transitionDuration: const Duration(milliseconds: 700),
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
    final gpsState = Provider.of<GPSBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('MapTec'),
          actions: [
            IconButton(
              onPressed: () => changeTheme(theme, context),
              icon:
                  Icon(theme.getIsDark() ? Icons.light_mode : Icons.dark_mode),
              tooltip: "Cambiar el tema",
            ),
          ],
        ),
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.7,
          backgroundColor: themeScheme.surface,
          child: ListView(
            children: [
              DrawerHeader(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Image(
                      image: AssetImage(theme.getIsDark()
                          ? "assets/image/logoDark.png"
                          : "assets/image/logo.png"),
                      width: 80,
                      height: 80,
                    ),
                    title: const Text("MapTec"),
                    subtitle: Text(packageInfo.version),
                  ),
                ],
              )),
              ListTile(
                  leading: const Icon(Icons.book),
                  title: const Text("Manual de usuario"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, _createRouteWithAnimation());
                  }),
              Visibility(
                visible: isRunningBackService == false &&
                    gpsState.isGPSEnabled == true,
                child: ListTile(
                  leading: const Icon(Icons.gps_fixed),
                  title: const Text("Activar el seguimiento de GPS"),
                  onTap: () async {
                    await BackgroundLocationTrackerManager.startTracking();
                    isRunningBackService = true;
                    stopByUser = false;
                    Navigator.pop(context);
                  },
                ),
              ),
              Visibility(
                visible: isRunningBackService == true &&
                    gpsState.isGPSEnabled == true,
                child: ListTile(
                  leading: const Icon(Icons.gps_off),
                  title: const Text("Desactivar seguimiento de GPS"),
                  onTap: () async {
                    await BackgroundLocationTrackerManager.stopTracking();
                    currentPosition = null;
                    isRunningBackService = false;
                    stopByUser = true;
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const OfflineBottomBar(),
            Container(
              padding: const EdgeInsets.only(
                top: 20,
                right: 16,
                bottom: 20,
                left: 16,
              ),
              child: InputSearch(),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                ),
                width: double.infinity,
                child: gpsState.isAllGranted
                    ? BottomSheetModal()
                    : const GPSAccess(),
              ),
            ),
          ],
        ));
  }

  changeTheme(ThemeBloc theme, BuildContext context) {
    final dataAPI = Provider.of<DataApiBloc>(context, listen: false);
    final spDB = Provider.of<SharedPreferencesBloc>(context, listen: false);
    dynamic dataToSave = [];
    final List<dynamic> listDataAPI = [
      dataAPI.departamentos,
      dataAPI.laboratorios,
      dataAPI.salasAudiovisuales,
      dataAPI.cubiculos
    ];

    //check the data to save in the database
    if (listDataAPI[0].isEmpty &&
        listDataAPI[1].isEmpty &&
        listDataAPI[2].isEmpty &&
        listDataAPI[3].isEmpty) {
      dataToSave = spDB.sharedPreferencesDB.isEmpty
          ? "[]"
          : spDB.sharedPreferencesDB[0].data;
    } else {
      dataToSave = json.encode(listDataAPI);
    }

    theme.setTheme(!theme.getIsDark());
    spDB.sharedPreferencesDB.isEmpty
        ? spDB.addSharedPreferences(1, theme.getIsDark(), dataToSave)
        : spDB.updateSharedPreferencesDB(1, theme.getIsDark(), dataToSave);
  }
}
