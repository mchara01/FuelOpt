import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuel_opt/utils/location_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Map();
  }
}

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MapState();
}

class MapState extends State<Map> {
  final Completer<GoogleMapController> _controller = Completer();

  late GoogleMapController mapController;
  final LocationManager _locationManager = LocationManager();

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(51.5074, 0.1278),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    LocationManager _locationManager = LocationManager();
    await _locationManager.checkAndRequestService();
    await _locationManager.checkAndRequestPermission();
    await _locationManager.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          _locationManager.setOnLocationChanged((LocationData newLocation) {
            mapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: LatLng(newLocation.latitude as double,
                    newLocation.longitude as double), zoom: 15)));
          });
          _controller.complete(controller);
        },
      ),
    );
  }
    final logOutButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: appColors.PrimaryBlue,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            logout(context);
          },
          child: Text(
            "Logout",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}