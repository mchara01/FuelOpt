import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fuel_opt/widgets/filter/filter_menu.dart';
import 'package:fuel_opt/widgets/search_bar.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:fuel_opt/widgets/search_result.dart';

class FuelStationsBottomSheet extends StatefulWidget {
  const FuelStationsBottomSheet({Key? key}) : super(key: key);

  @override
  _FuelStationsBottomSheetState createState() =>
      _FuelStationsBottomSheetState();
}

class _FuelStationsBottomSheetState extends State<FuelStationsBottomSheet> {
  final SnappingSheetController snappingSheetController =
      SnappingSheetController();

  late StreamSubscription<bool> keyboardSubscription;

  double? bottomSheetPosition;

  bool isKeyboardVisible = false;

  bool programmaticBottomSheetMovement = false;

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      controller: snappingSheetController,
      grabbing: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(blurRadius: 20.0, color: Colors.black.withOpacity(0.2))
          ],
        ),
        child: SizedBox(
          height: 100,
          width: 100,
          child: SearchBar(
            searchOnTap: () {
              programmaticBottomSheetMovement = true;
              snappingSheetController
                  .snapToPosition(
                      const SnappingPosition.factor(positionFactor: 0.7))
                  .then((value) {
                bottomSheetPosition = snappingSheetController.currentPosition;
                programmaticBottomSheetMovement = false;
              });
            },
          ),
        ),
      ),
      grabbingHeight: 80,
      sheetBelow: SnappingSheetContent(
          child: Container(
            height: 100,
            width: 100,
            color: Colors.white,
            child: Column(
              children: [FilterMenu(), SearchResult()],
            ),
            // child: Column(
            //   children: <Widget>[
            //     Filter(),
            //   ],
            // ),
          ),
          draggable: true),
      initialSnappingPosition:
          const SnappingPosition.factor(positionFactor: 0.4),
      snappingPositions: const [
        SnappingPosition.factor(
            positionFactor: 0.0,
            grabbingContentOffset: GrabbingContentOffset.top),
        SnappingPosition.factor(positionFactor: 0.4),
        SnappingPosition.factor(positionFactor: 0.7)
      ],
      onSheetMoved: (sheetPositionData) {
        if (!programmaticBottomSheetMovement && isKeyboardVisible) {
          if ((sheetPositionData.pixels - bottomSheetPosition!).abs() > 30) {
            FocusScope.of(context).unfocus();
          }
        }
      },
    );
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }
}
