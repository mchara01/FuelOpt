import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/model/current_location_model.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/model/stations_data_model.dart';
import 'package:fuel_opt/model/top_3_station_result.dart';
import 'package:fuel_opt/screens/stations_detail.dart';
import 'package:fuel_opt/utils/location_manager.dart';
import 'package:fuel_opt/utils/map_marker_generator.dart';
import 'package:fuel_opt/widgets/dialog.dart';
import 'package:fuel_opt/widgets/fuel_stations_bottom_sheet.dart';
import 'package:fuel_opt/widgets/navigation_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../utils/appColors.dart' as appColors;
import '../widgets/search_bar_search_this_area_button.dart';

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

  Future<void> moveCamera(LatLng latLng) async {
    await mapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  Future<void> addMarker(LatLng latLng) async {
    // mapController.addMarker(CameraUpdate.newLatLng(latLng));
  }

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
    final currentLocation = Provider.of<CurrentLocationModel>(context);

    return Scaffold(
      drawer: NavigationDrawerWidget(),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Consumer<SearchResultModel>(
              builder: (context, searchResult, childWidget) {
            _markerIdCounter = 0;
            _markers.clear();
            List<Station> stations = searchResult.stations;
            if (stations is List<Top3StationResult>) {
              var top3ResultList = stations.cast<Top3StationResult>();
              for (var top3Result in top3ResultList) {
                for (var station in top3Result.top3Stations) {
                  final String _markerIdValue = 'marker_id_$_markerIdCounter';
                  _markerIdCounter++;
                  _markers.add(Marker(
                      markerId: MarkerId(_markerIdValue),
                      position: LatLng(station.latitude, station.longitude),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return StationsDetail(station);
                        }));
                      },
                      icon: fuelStationIcon));
                }
              }
            } else {
              List<StationResult> top3ResultList =
                  stations.cast<StationResult>();
              for (var station in top3ResultList) {
                final String _markerIdValue = 'marker_id_$_markerIdCounter';
                _markerIdCounter++;
                _markers.add(Marker(
                    markerId: MarkerId(_markerIdValue),
                    position: LatLng(station.latitude, station.longitude),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return StationsDetail(station);
                      }));
                    },
                    icon: fuelStationIcon));
              }
            }
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (GoogleMapController controller) async {
                mapController = controller;

                Provider.of<CurrentLocationModel>(context, listen: false)
                    .setLatLng(_initialCameraPosition.target);
                Provider.of<CurrentLocationModel>(context, listen: false)
                    .setAnimateCameraFunction(moveCamera);
                // ask for permission for location
                await _locationManager.checkAndRequestService();
                await _locationManager.checkAndRequestPermission();

                final currentLocationModel =
                    Provider.of<CurrentLocationModel>(context, listen: false);

                // if permission given, move to user's position
                LocationData? locationData =
                    await _locationManager.getLocation();
                if (locationData != null) {
                  await mapController.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                          target: LatLng(locationData.latitude as double,
                              locationData.longitude as double),
                          zoom: 13)));

                  currentLocationModel.setLatLng(
                      LatLng(locationData.latitude!, locationData.longitude!));
                }

                  // _markers.add(Marker(
                  //     markerId: MarkerId("currentLocation"),
                  //     position: currentLocationModel.getLatLng()));

                await Future.delayed(const Duration(seconds: 3));

                FuelStationDataService fuelStationDataService =
                    FuelStationDataService();
                LatLngBounds mapBounds = await mapController.getVisibleRegion();
                currentLocationModel.setMapBounds(mapBounds);
                List<StationResult>? stations =
                    await fuelStationDataService.getStations(mapBounds);
                Provider.of<SearchResultModel>(context, listen: false)
                    .setSearchResult(stations);
                _controller.complete(controller);
              },
              markers: _markers,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: true,
              minMaxZoomPreference: MinMaxZoomPreference(12, 20),
              trafficEnabled: true,
              onCameraMove: (CameraPosition cameraPosition) async {
                Provider.of<CurrentLocationModel>(context, listen: false)
                    .setLatLng(cameraPosition.target);
                LatLngBounds mapBounds = await mapController.getVisibleRegion();
                Provider.of<CurrentLocationModel>(context, listen: false)
                    .setMapBounds(mapBounds);
              },
            );
          }),
          const FuelStationsBottomSheet(),
          Positioned(
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
          ),
          // Positioned(
          //   top: 30,
          //   left: 130,
          //   width: 130,
          //   child: TextButton(
          //     style: TextButton.styleFrom(
          //       backgroundColor: appColors.PrimaryBlue,
          //       primary: Colors.white,
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10)),
          //     ),
          //     onPressed: () {},
          //     child: const Text('Search this area'),
          //   ),
          // ),
          Positioned(
            top: 30,
            left: 130,
            width: 130,
            child: const SearchBarSearchThisAreaButton(),
          ),
          Positioned(
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
          ),
          const DialogWidget()
        ],
      ),
    );
  }
}
