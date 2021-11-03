import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/model/stations_model.dart';
import 'package:fuel_opt/utils/location_manager.dart';
import 'package:fuel_opt/utils/map_marker_generator.dart';
import 'package:fuel_opt/widgets/fuel_stations_bottom_sheet.dart';
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
    zoom: 10,
  );

  final Set<Marker> _markers = <Marker>{};

  int _markerIdCounter = 1;

  late BitmapDescriptor fuelStationIcon;

  @override
  void initState() {
    super.initState();
    createFuelStationIcon('assets/gas_station.png', const Color(0xFF002060))
        .then((BitmapDescriptor icon) {
      fuelStationIcon = icon;
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId('0'),
            position: LatLng(51.5074, 0.1278),
            icon: fuelStationIcon));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (GoogleMapController controller) async {
              mapController = controller;
              // await _locationManager.checkAndRequestService();
              // await _locationManager.checkAndRequestPermission();
              // _locationManager.setOnLocationChanged((LocationData newLocation) {
              //   print('location changed');
              //   print('lat' + newLocation.latitude.toString());
              //   print('long' + newLocation.longitude.toString());
              //   mapController.animateCamera(CameraUpdate.newCameraPosition(
              //       CameraPosition(target: LatLng(newLocation.latitude as double,
              //           newLocation.longitude as double), zoom: 15)));
              // });
              // LocationData? locationData = await _locationManager.getLocation();
              // if (locationData != null) {
              //   mapController.animateCamera(CameraUpdate.newCameraPosition(
              //       CameraPosition(
              //           target: LatLng(locationData.latitude as double,
              //               locationData.longitude as double),
              //           zoom: 15)));
              // }
              FuelStationDataService fuelStationDataService =
                  FuelStationDataService();
              LatLngBounds mapBounds = await mapController.getVisibleRegion();
              List<Station>? stations =
                  await fuelStationDataService.getStations(mapBounds);
              if (stations != null) {
                stations.forEach((station) {
                  final String _markerIdValue = 'marker_id_$_markerIdCounter';
                  _markerIdCounter++;
                  _markers.add(Marker(
                      markerId: MarkerId(_markerIdValue),
                      position: LatLng(station.latitude, station.longitude),
                      icon: fuelStationIcon));
                });
                print(stations.length);
                setState(() {});
              }
              _controller.complete(controller);
            },
            markers: _markers,
          ),
          const FuelStationsBottomSheet()
        ],
      ),
    );
  }
}
