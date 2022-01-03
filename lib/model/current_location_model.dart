import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationModel extends ChangeNotifier {
  late LatLng _latLng;

  void setLatLng(LatLng latLng) {
    _latLng = latLng;
    notifyListeners();
  }

  LatLng getLatLng() {
    return _latLng;
  }
}