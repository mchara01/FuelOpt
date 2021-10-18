import 'package:location/location.dart';

class LocationManager {
  Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  Future<void> checkAndRequestService() async {
    _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }
  }

  Future<void> checkAndRequestPermission() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }
  }

  Future<LocationData?> getLocation() async {
    if(_serviceEnabled && _permissionGranted == PermissionStatus.granted) {
      return await location.getLocation();
    }
    else{
      return Future.value(null);
    }
  }

  void setOnLocationChanged(Function onLocationChangedCallback) {
    location.onLocationChanged.listen((event) {
      onLocationChangedCallback(event);
    });
  }
}