import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class Equatable {
  static bool equalsPosition(Position? position1, Position? position2) {
    if (position1!.latitude == position2!.latitude &&
        position1.longitude == position2.longitude) {
      return true;
    }
    return false;
  }
}

class Rectangle {
  LatLng point1;
  LatLng point2;
  LatLng point3;
  LatLng point4;

  Rectangle(this.point1, this.point2, this.point3, this.point4);

  bool contains(LatLng p) {
    // Convertimos las coordenadas de latitud y longitud a unidades cartesianas.
    double x = cos(p.latitude) * cos(p.longitude);
    double y = cos(p.latitude) * sin(p.longitude);

    // Convertimos las coordenadas de latitud y longitud de los puntos del rectángulo a unidades cartesianas.
    double x1 = cos(point1.latitude) * cos(point1.longitude);
    double y1 = cos(point1.latitude) * sin(point1.longitude);
    double x2 = cos(point3.latitude) * cos(point3.longitude);
    double y2 = cos(point3.latitude) * sin(point3.longitude);

    // Verificamos si la coordenada x del punto está entre las coordenadas x de los puntos 1 y 3 del rectángulo.
    bool xBetween = (x >= x1 && x <= x2) || (x >= x2 && x <= x1);

    // Verificamos si la coordenada y del punto está entre las coordenadas y de los puntos 1 y 2 del rectángulo.
    bool yBetween = (y >= y1 && y <= y2) || (y >= y2 && y <= y1);

    return xBetween && yBetween;
  }
}
