import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/main.dart';
import 'package:fuel_opt/model/stations_model.dart';
import 'package:fuel_opt/utils/location_manager.dart';
import 'package:fuel_opt/utils/map_marker_generator.dart';
import 'package:fuel_opt/widgets/dialog.dart';
import 'package:fuel_opt/widgets/fuel_stations_bottom_sheet.dart';
import 'package:fuel_opt/widgets/navigation_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:fuel_opt/widgets/options_button.dart';
import '../utils/appColors.dart' as appColors;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

  // set initial position at imperial college london
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(51.498843, -0.177153),
    zoom: 13,
  );

  final Set<Marker> _markers = <Marker>{};

  int _markerIdCounter = 0;

  late BitmapDescriptor fuelStationIcon;

  @override
  void initState() {
    super.initState();
    createFuelStationIcon('assets/gas_station.png', const Color(0xFF002060))
        .then((BitmapDescriptor icon) {
      fuelStationIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      resizeToAvoidBottomInset: false,
      body: ChangeNotifierProvider(
        create: (context) => SearchResultModel(),
        child: Stack(
          children: [
            Consumer<SearchResultModel>(
              builder: (context, searchResult, childWidget) {
                _markerIdCounter = 0;
                _markers.clear();
                List<Station> stations = searchResult.stations;
                if(stations is List<Top3StationResult>) {
                  List<Top3StationResult> top3ResultList = stations.cast<Top3StationResult>();
                  for (var top3Result in top3ResultList) {
                    for (var station in top3Result.top3Stations) {
                      final String _markerIdValue = 'marker_id_$_markerIdCounter';
                      _markerIdCounter++;
                      _markers.add(Marker(
                          markerId: MarkerId(_markerIdValue),
                          position: LatLng(
                              station.latitude, station.longitude),
                          icon: fuelStationIcon));
                    }
                  }
                }
                else{
                  List<StationResult> top3ResultList = stations.cast<StationResult>();
                  for (var station in top3ResultList) {
                    final String _markerIdValue = 'marker_id_$_markerIdCounter';
                    _markerIdCounter++;
                    _markers.add(Marker(
                        markerId: MarkerId(_markerIdValue),
                        position: LatLng(
                            station.latitude, station.longitude),
                        icon: fuelStationIcon));
                  }
                }
                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) async {
                    mapController = controller;

                    // ask for permission for location
                    await _locationManager.checkAndRequestService();
                    await _locationManager.checkAndRequestPermission();

                    // if permission given, move to user's position
                    LocationData? locationData = await _locationManager.getLocation();
                    if (locationData != null) {
                      mapController.animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                              target: LatLng(locationData.latitude as double,
                                  locationData.longitude as double),
                              zoom: 13)));
                    }
                    _controller.complete(controller);
                  },
                  markers: _markers,
                  markers: _markers,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  tiltGesturesEnabled: true,
                  minMaxZoomPreference: MinMaxZoomPreference(12, 20),
                  trafficEnabled: true,
                  onCameraIdle: () async {
                    FuelStationDataService fuelStationDataService =
                    FuelStationDataService();
                    LatLngBounds mapBounds = await mapController
                        .getVisibleRegion();
                    List<StationResult>? stations =
                    await fuelStationDataService.getStations(mapBounds);
                    Provider.of<SearchResultModel>(context, listen: false).setSearchResult(
                        stations);
                  }
                );
              }
            ),
            const FuelStationsBottomSheet(),
            Builder(builder: (context) {
              return Positioned(
                top: 20,
                width: size.width * 0.2,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: appColors.PrimaryBlue,
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              );
            }),
            Builder(builder: (context) {
              return Positioned(
                top: 70,
                width: size.width * 0.2,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: appColors.PrimaryBlue,
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.my_location,
                    color: appColors.COLOR_White,
                  ),
                  onPressed: () async {
                    LocationData? locationData =
                    await _locationManager.getLocation();
                    if (locationData != null) {
                      mapController.animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                              target: LatLng(locationData.latitude as double,
                                  locationData.longitude as double),
                              zoom: 13)));
                    }
                  },
                ),
              );
            }),
            const DialogWidget()
          ],
        ),
      ),
    );
  }
}
