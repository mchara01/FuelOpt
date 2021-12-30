import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/model/stations_data_model.dart';
import 'package:fuel_opt/model/top_3_station_result.dart';
import 'package:fuel_opt/utils/location_manager.dart';
import 'package:fuel_opt/utils/map_marker_generator.dart';
import 'package:fuel_opt/widgets/dialog.dart';
import 'package:fuel_opt/widgets/fuel_stations_bottom_sheet.dart';
import 'package:fuel_opt/widgets/navigation_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../utils/appColors.dart' as appColors;

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
                    LatLngBounds mapBounds = await mapController
                        .getVisibleRegion();
                    List<StationResult>? stations =
                    await fuelStationDataService.getStations(mapBounds);
                    Provider.of<SearchResultModel>(context, listen: false).setSearchResult(
                        stations);
                    _controller.complete(controller);
                  },
                  markers: _markers,
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
            const DialogWidget()
          ],
        ),
      ),
    );
  }
}
