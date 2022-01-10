import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationModel extends ChangeNotifier {
  late LatLng _latLng;
  late LatLngBounds _latLngBounds;
  late Future<void> Function(LatLng latLng) _animateMapCamera;
  late LatLng _userLocation;

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

  void setAnimateCameraFunction(
      Future<void> Function(LatLng latLng) animateCameraFunction) {
    _animateMapCamera = animateCameraFunction;
  }

  void animateCameraToPosition(LatLng latLng) {
    _animateMapCamera(latLng);
  }

  void setUserLocation(LatLng latLng) {
    _userLocation = latLng;
  }

  LatLng getCurrentUserLocation() {
    return _userLocation;
  }
}
