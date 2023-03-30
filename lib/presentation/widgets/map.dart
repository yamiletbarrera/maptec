import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:maptec/blocs/connectivity_bloc.dart';
import 'package:maptec/blocs/gps_bloc.dart';
import 'package:maptec/blocs/input_search_bloc.dart';
import 'package:maptec/main.dart';
import 'package:maptec/utils/geo_functions.dart';
import 'package:provider/provider.dart';

class _MyLocationMarker extends AnimatedWidget {
  const _MyLocationMarker(Animation<double> animation, {Key? key})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final value = (listenable as Animation<double>).value;
    final newValue = lerpDouble(0.5, 1.0, value)!;
    const size = 40;
    return Center(
      child: Stack(
        children: [
          Center(
            child: Container(
              width: size * newValue,
              height: size * newValue,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                )),
          ),
        ],
      ),
    );
  }
}

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  Timer? timer;
  int openVentana = 0;
  bool isInsideOnMap = true;

  void checkUserLocationOnMap() {
    final p1 = LatLng(18.825631209, -98.924489132);
    final p3 = LatLng(18.830948948, -98.913428235);

    final p2 = LatLng(18.825631209, -98.913428235);
    final p4 = LatLng(18.830948948, -98.924489132);

    Rectangle rectangle = Rectangle(p1, p2, p3, p4);
    //Datos del GPS en el Mapa
    final userL = LatLng(currentPosition!.latitude, currentPosition!.longitude);
    //Dentro del Mapa - debugg
    //final userL = LatLng(18.82885, -98.91875);
    final isInside = rectangle.contains(userL);
    print(
        "El usuario esta dentro del Mapa: $isInside Status Ventana: $openVentana");
    setState(() {
      isInsideOnMap = isInside;
    });
  }

  void startLocationsUpdatesStream() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    });
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _animationController.repeat(reverse: true);
    startLocationsUpdatesStream();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (currentPosition != null) {
      checkUserLocationOnMap();
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final network = Provider.of<ConnectivityBloc>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final gpsState = Provider.of<GPSBloc>(context);

    final position = gpsState.position;
    final input = Provider.of<InputSearchBloc>(context);

    Future.delayed(Duration.zero, () {
      if (isRunningBackService == true && stopByUser == false) {
        if (currentPosition != null) {
          if (Equatable.equalsPosition(currentPosition, gpsState.position) ==
              false) {
            gpsState.setPosition(currentPosition!);
            print("🎈 Se agrego nueva ubicación usando CurrentPosition");
          }
        } else {
          gpsState.getPosition();
          currentPosition = gpsState.position;
          print("✨ Se agrego nueva ubicación y se guardo en CurrentPosition");
        }
      }
    });

    final selectedEdificio = input.selectedData?.edificio;
    final letraEdificio = selectedEdificio?.nombre.split('"')[1];

    return Stack(
      children: <Widget>[
        FlutterMap(
          mapController: MapController(),
          options: MapOptions(
            /*center: network.status == NetworkStatus.offline ? LatLng(18.82797,-98.91868)
                : position != null ? LatLng(position.latitude, position.longitude)
                : LatLng(18.82797,-98.91868),*/
            center: LatLng(18.82797, -98.91868),
            zoom: 17.0,
            rotation: -90,
            maxZoom: 18,
            minZoom: 16.0,
            swPanBoundary: LatLng(18.825631209, -98.924489132),
            nePanBoundary: LatLng(18.830948948, -98.913428235),
            maxBounds: LatLngBounds(
              LatLng(18.825631209, -98.924489132),
              LatLng(18.830948948, -98.913428235),
            ),
          ),
          children: [
            Visibility(
              visible: network.status == NetworkStatus.offline,
              child: TileLayer(
                tileProvider: AssetTileProvider(),
                urlTemplate: 'assets/image/mapa/{z}/{x}/{y}.png',
                maxZoom: 18,
                tms: true,
              ),
            ),
            Visibility(
              visible: network.status == NetworkStatus.online,
              child: TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
            ),
            MarkerLayer(markers: [
              //Localizacion actual del usuario
              Marker(
                width: 80.0,
                height: 80.0,
                point: position != null
                    ? LatLng(position.latitude, position.longitude)
                    : LatLng(18.82885, -98.91875),
                //point: LatLng(18.82885, -98.91875),
                builder: (context) => Visibility(
                    visible: stopByUser != true,
                    child: Tooltip(
                        message:
                            "🧭 Tu ubicación\nLat: ${position?.latitude}\nLon: ${position?.longitude}",
                        child: _MyLocationMarker(_animationController))),
                /*builder: (context) => Container(
                  child: Icon(
                    Icons.radio_button_checked,
                    color: colorScheme.primary,
                    size: 40,
                  ),
                ),*/
              ),
              //Edificio A
              Marker(
                  rotate: true,
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(18.82850, -98.92044),
                  builder: (context) => Visibility(
                        visible: letraEdificio == "A",
                        child: Tooltip(
                          message:
                              "El edificio '$letraEdificio' cuenta con ${selectedEdificio?.numaulas} aulas.",
                          child: Container(
                              child: Icon(
                            Icons.location_on,
                            color: colorScheme.error,
                            size: 40,
                          )),
                        ),
                      )),
              //Edificio B
              Marker(
                  rotate: true,
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(18.82860, -98.92020),
                  builder: (context) => Visibility(
                        visible: letraEdificio == "B",
                        child: Tooltip(
                          message:
                              "El edificio '$letraEdificio' cuenta con ${selectedEdificio?.numaulas} aulas.",
                          child: Container(
                              child: Icon(
                            Icons.location_on,
                            color: colorScheme.error,
                            size: 40,
                          )),
                        ),
                      )),
              //Edificio C
              Marker(
                  rotate: true,
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(18.82875, -98.92025),
                  builder: (context) => Visibility(
                        visible: letraEdificio == "C",
                        child: Tooltip(
                          message:
                              "El edificio '$letraEdificio' cuenta con ${selectedEdificio?.numaulas} aulas.",
                          child: Container(
                              child: Icon(
                            Icons.location_on,
                            color: colorScheme.error,
                            size: 40,
                          )),
                        ),
                      )),
              //Edificio D
              Marker(
                  rotate: true,
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(18.82879, -98.91935),
                  builder: (context) => Visibility(
                        visible: letraEdificio == "D",
                        child: Tooltip(
                          message:
                              "El edificio '$letraEdificio' cuenta con ${selectedEdificio?.numaulas} aulas.",
                          child: Container(
                              child: Icon(
                            Icons.location_on,
                            color: colorScheme.error,
                            size: 40,
                          )),
                        ),
                      )),
              //Edificio E
              Marker(
                  rotate: true,
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(18.82855, -98.91887),
                  builder: (context) => Visibility(
                        visible: letraEdificio == "E",
                        child: Tooltip(
                          message:
                              "El edificio '$letraEdificio' cuenta con ${selectedEdificio?.numaulas} aulas.",
                          child: Container(
                              child: Icon(
                            Icons.location_on,
                            color: colorScheme.error,
                            size: 40,
                          )),
                        ),
                      )),
              //Edificio F
              Marker(
                  rotate: true,
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(18.82837, -98.91800),
                  builder: (context) => Visibility(
                        visible: letraEdificio == "F",
                        child: Tooltip(
                          message:
                              "El edificio '$letraEdificio' cuenta con ${selectedEdificio?.numaulas} aulas.",
                          child: Container(
                              child: Icon(
                            Icons.location_on,
                            color: colorScheme.error,
                            size: 40,
                          )),
                        ),
                      )),
              //Edificio G
              Marker(
                  rotate: true,
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(18.82820, -98.91866),
                  builder: (context) => Visibility(
                        visible: letraEdificio == "G",
                        child: Tooltip(
                          message:
                              "El edificio '$letraEdificio' cuenta con ${selectedEdificio?.numaulas} aulas.",
                          child: Container(
                              child: Icon(
                            Icons.location_on,
                            color: colorScheme.error,
                            size: 40,
                          )),
                        ),
                      )),
              //Edificio H
              Marker(
                  rotate: true,
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(18.82840, -98.91730),
                  builder: (context) => Visibility(
                        visible: letraEdificio == "H",
                        child: Tooltip(
                          message:
                              "El edificio '$letraEdificio' cuenta con ${selectedEdificio?.numaulas} aulas.",
                          child: Container(
                              child: Icon(
                            Icons.location_on,
                            color: colorScheme.error,
                            size: 40,
                          )),
                        ),
                      )),
              //Edificio I
              Marker(
                  rotate: true,
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(18.82808, -98.91735),
                  builder: (context) => Visibility(
                        visible: letraEdificio == "I",
                        child: Tooltip(
                          message:
                              "El edificio '$letraEdificio' cuenta con ${selectedEdificio?.numaulas} aulas.",
                          child: Container(
                              child: Icon(
                            Icons.location_on,
                            color: colorScheme.error,
                            size: 40,
                          )),
                        ),
                      )),
              //Edificio J
              Marker(
                  rotate: true,
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(18.82769, -98.91722),
                  builder: (context) => Visibility(
                        visible: letraEdificio == "J",
                        child: Tooltip(
                          message:
                              "El edificio '$letraEdificio' cuenta con ${selectedEdificio?.numaulas} aulas.",
                          child: Container(
                              child: Icon(
                            Icons.location_on,
                            color: colorScheme.error,
                            size: 40,
                          )),
                        ),
                      )),
              //Edificio K
              Marker(
                  rotate: true,
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(18.82829, -98.91678),
                  builder: (context) => Visibility(
                        visible: letraEdificio == "K",
                        child: Tooltip(
                          message:
                              "El edificio '$letraEdificio' cuenta con ${selectedEdificio?.numaulas} aulas.",
                          child: Container(
                              child: Icon(
                            Icons.location_on,
                            color: colorScheme.error,
                            size: 40,
                          )),
                        ),
                      )),
            ]),
          ],
        ),
        Visibility(
            visible: openVentana == 0 && isInsideOnMap == false,
            child: AlertDialog(
              insetPadding: const EdgeInsets.all(20),
              actionsPadding: const EdgeInsets.fromLTRB(0, 0, 12, 12),
              title: const Text('No estás dentro del Mapa'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      'Tu ubicación no está dentro de los límites del mapa, así que no podemos pintar tu ubicación actual hasta que estés dentro de los límites establecidos.'),
                  const SizedBox(
                    height: 28,
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: _MyLocationMarker(_animationController),
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      openVentana++;
                    });
                    //Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            )),
      ],
    );
  }
}
