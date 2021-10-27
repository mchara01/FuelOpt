import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fuel_opt/utils/location_manager.dart';
import 'package:fuel_opt/widgets/search_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

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

  final SnappingSheetController snappingSheetController = SnappingSheetController();

  double? bottomSheetPosition;

  late StreamSubscription<bool> keyboardSubscription;

  bool isKeyboardVisible = false;

  bool programmaticBottomSheetMovement = false;

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible = visible;
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
              await _locationManager.checkAndRequestService();
              await _locationManager.checkAndRequestPermission();
              _locationManager.setOnLocationChanged((LocationData newLocation) {
                mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: LatLng(newLocation.latitude as double,
                        newLocation.longitude as double), zoom: 15)));
              });
              _controller.complete(controller);
            },
          ),
          SnappingSheet(
            controller: snappingSheetController,
            grabbing: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(blurRadius: 20.0, color: Colors.black.withOpacity(0.2))
                ],
              ),
              child: SizedBox(height: 100, width: 100, child: SearchBar(searchOnTap: () {
                programmaticBottomSheetMovement = true;
                snappingSheetController.snapToPosition(SnappingPosition.factor(positionFactor: 0.7)).then((value) {
                  bottomSheetPosition = snappingSheetController.currentPosition;
                  programmaticBottomSheetMovement = false;
                });

                },),),
            ),
            grabbingHeight: 80,
            sheetBelow: SnappingSheetContent(child: Container(height: 100, width: 100, color: Colors.green), draggable: true),
            initialSnappingPosition: const SnappingPosition.factor(positionFactor: 0.4),
            snappingPositions: const [
              SnappingPosition.factor(positionFactor: 0.0, grabbingContentOffset: GrabbingContentOffset.top),
              SnappingPosition.factor(positionFactor: 0.4),
              SnappingPosition.factor(positionFactor: 0.7)
            ],
            onSheetMoved: (sheetPositionData) {
              if(!programmaticBottomSheetMovement && isKeyboardVisible) {
                  if ((sheetPositionData.pixels - bottomSheetPosition!).abs() > 30) {
                    FocusScope.of(context).unfocus();
                  }
              }
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }
}

