import 'dart:async';
/*import 'dart:convert';
import 'dart:ffi';
import 'dart:isolate';
import 'dart:ui';
import 'dart:io';*/

import 'package:background_location_tracker/background_location_tracker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maptec/blocs/input_search_bloc.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:maptec/blocs/shared_preferences_bloc.dart';
import 'package:maptec/blocs/data_api_bloc.dart';
import 'package:maptec/blocs/gps_bloc.dart';
import 'package:maptec/blocs/theme_bloc.dart';
import 'package:maptec/blocs/connectivity_bloc.dart';
import 'package:maptec/presentation/pages/splash_screen.dart';

//import 'package:map_tec/models/departamento_model.dart';

//Objeto Global con la funcionalidad de checar el status de la conexión a internet
final internetChecker = CheckInternetConnection();

geo.Position? currentPosition = null;

bool isRunningBackService = false;

bool stopByUser = false;

PackageInfo packageInfo = PackageInfo(
  appName: 'Unknown',
  packageName: 'Unknown',
  version: 'Unknown',
  buildNumber: 'Unknown',
  buildSignature: 'Unknown',
  installerStore: 'Unknown',
);

//Función que funcionara en segundo plano
@pragma('vm:entry-point')
void backgroundCallback() {
  BackgroundLocationTrackerManager.handleBackgroundUpdated(
      (data) => Repo().update(data));
}

Future<void> main() async {
  //Block the landscape orientation of the app
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //Obtener la información de la app
  packageInfo = await PackageInfo.fromPlatform();

  //Codigo para el funcionamiento del Tracking en Segundo plano
  await BackgroundLocationTrackerManager.initialize(
    backgroundCallback,
    config: const BackgroundLocationTrackerConfig(
      loggingEnabled: true,
      androidConfig: AndroidConfig(
        notificationIcon: 'logodark',
        trackingInterval: Duration(seconds: 10),
        distanceFilterMeters: null,
        cancelTrackingActionText: "Detener seguimiento",
        notificationBody:
            "Iniciamos seguimiento de ubicación en segundo plano.\nDale tap para regresar a la aplicación 📲",
        //enableNotificationLocationUpdates: true
      ),
      iOSConfig: IOSConfig(
        activityType: ActivityType.FITNESS,
        distanceFilterMeters: null,
        restartAfterKill: true,
      ),
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeBloc(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityBloc(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => GPSBloc(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => DataApiBloc(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => SharedPreferencesBloc(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => InputSearchBloc(),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class Repo {
  static Repo? _instance;

  Repo._();

  factory Repo() => _instance ??= Repo._();

  Future<void> update(BackgroundLocationUpdateData data) async {
    DateTime t = DateTime.now();
    String shour;
    String sminute;
    String ssecond;

    currentPosition = await geo.Geolocator.getCurrentPosition(
      desiredAccuracy: geo.LocationAccuracy.high,
    );

    if (t.hour < 10 || t.hour == 0) {
      shour = "0${t.hour}";
    } else {
      shour = t.hour.toString();
    }

    if (t.minute < 10 || t.minute == 0) {
      sminute = "0${t.minute}";
    } else {
      sminute = t.minute.toString();
    }

    if (t.second < 10 || t.second == 0) {
      ssecond = "0${t.second}";
    } else {
      ssecond = t.second.toString();
    }

    String strAhora =
        "${t.day}-${t.month}-${t.year} ⏳ $shour:$sminute:$ssecond";
    //final text = '🗓 $strAhora\n🧭 Lat: ${data.lat}, Lon: ${data.lon}';
    final text =
        '🗓 $strAhora\n🧭 Lat: ${currentPosition?.latitude}, Lon: ${currentPosition?.longitude}';
    print(text); // ignore: avoid_print
    sendNotification(text);
    print("Se agrego una nueva position(Main): ${currentPosition.toString()}");
  }
}

//Funcion para enviar notificaciones
void sendNotification(String text) {
  const settings = InitializationSettings(
    android: AndroidInitializationSettings('logodark'),
    iOS: IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    ),
  );
  FlutterLocalNotificationsPlugin().initialize(
    settings,
    onSelectNotification: (data) async {
      print('ON CLICK $data'); // ignore: avoid_print
    },
  );
  FlutterLocalNotificationsPlugin().show(
    1,
    'Nueva ubicación recibida',
    text,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'test_notification',
        'Background Tracking',
        color: Color(0xFF1550AF),
        playSound: false,
        enableVibration: false,
      ),
      iOS: IOSNotificationDetails(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> checkGPS() async {
    return await geo.Geolocator.isLocationServiceEnabled();
  }

  void onStart(GPSBloc gpsState) async {
    if (gpsState.isAllGranted) {
      await BackgroundLocationTrackerManager.startTracking();
      isRunningBackService = true;
    }
  }

  void onStop() async {
    await BackgroundLocationTrackerManager.stopTracking();
    isRunningBackService = false;
  }

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final gpsState = Provider.of<GPSBloc>(context);
    //Checar si el GPS esta activado
    checkGPS().then((value) => gpsState.setIsGPSEnabled(value));

    //Inicia el servicio de localización en segundo plano
    if (gpsState.isAllGranted &&
        isRunningBackService == false &&
        stopByUser == false) {
      onStart(gpsState);
    }

    return const MaterialAppWithTheme();
  }

  Future<void> _getTrackingStatus() async {
    isRunningBackService = await BackgroundLocationTrackerManager.isTracking();
  }

  Future<void> _requestLocationPermission() async {
    final result = await Permission.locationAlways.request();
    if (result == PermissionStatus.granted) {
      print('GRANTED'); // ignore: avoid_print
    } else {
      print('NOT GRANTED'); // ignore: avoid_print
    }
  }

  Future<void> _requestNotificationPermission() async {
    final result = await Permission.notification.request();
    if (result == PermissionStatus.granted) {
      print('GRANTED'); // ignore: avoid_print
    } else {
      print('NOT GRANTED'); // ignore: avoid_print
    }
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeBloc>(context);
    return MaterialApp(
      title: 'MapTec',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: theme.getTheme(),
    );
  }
}
