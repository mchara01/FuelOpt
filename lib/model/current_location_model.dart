import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationModel extends ChangeNotifier {
  late LatLng _latLng;
  late LatLngBounds _latLngBounds;

  void setLatLng(LatLng latLng) {
    _latLng = latLng;
    notifyListeners();
  }

  void setMapBounds(LatLngBounds latLngBounds) {
    _latLngBounds = latLngBounds;
    notifyListeners();
  }

  LatLng getLatLng() {
    return _latLng;
  }

  LatLngBounds getLatLngBounds() {
    return _latLngBounds;
  }
}