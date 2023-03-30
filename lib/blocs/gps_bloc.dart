import 'dart:async';
import 'package:background_location_tracker/background_location_tracker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GPSBloc extends ChangeNotifier {
  bool isGPSEnabled = false;
  bool isGPSPermissionGranted = false;
  Position? position;
  late StreamSubscription _connectionSubscription;

  GPSBloc() {
    _init();
  }

  Future<void> _init() async {
    await _checkGPSStatus();
    await _isPermissionGranted();

    //Si el GPS está activado y el permiso de ubicación está activado obtenemos las coordenadas del usuario
    if (this.isAllGranted) {
      await getPosition();
    }

    print(
        "GPS Status: $isGPSEnabled, GPS Permission: $isGPSPermissionGranted, location: ${position}");
    notifyListeners();
  }

  void setPosition(Position? newPosition) {
    if (newPosition != null) {
      position = newPosition;
      print("Se agrego una nueva position");
      notifyListeners();
    }
  }

  void setPositionT(BackgroundLocationUpdateData newPosition) {
    if (newPosition != null) {
      position = Position(
          longitude: newPosition.lon,
          latitude: newPosition.lat,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0);
      print("Se agrego una nueva position");
      notifyListeners();
    }
  }

  bool get isAllGranted => isGPSEnabled && isGPSPermissionGranted;

  void setIsGPSEnabled(bool value) {
    isGPSEnabled = value;
    notifyListeners();
  }

  void setIsGPSPermissionGranted(bool value) {
    isGPSPermissionGranted = value;
    notifyListeners();
  }

  Future<void> getPosition() async {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    notifyListeners();
  }

  Future<void> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    setIsGPSPermissionGranted(isGranted);
  }

  Future<void> _checkGPSStatus() async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();

    _connectionSubscription =
        Geolocator.getServiceStatusStream().listen((status) {
      final isEnabled = status.index == 1 ? true : false;
      print("service status: $isEnabled");
      setIsGPSEnabled(isEnabled);
    });
  }

  Future<void> askGPSAccess() async {
    final status = await Permission.location.request();
    switch (status) {
      case PermissionStatus.granted:
        setIsGPSPermissionGranted(true);
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        setIsGPSPermissionGranted(false);
        openAppSettings();
        break;
    }
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }
}
