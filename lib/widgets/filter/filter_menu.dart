import 'package:flutter/material.dart';
import 'distance_options.dart';
import 'fuel_type_options.dart';
import 'sort_by_options.dart';

enum FilterType {
  SORT_BY,
  FUEL_TYPE,
  DISTANCE,
}

class FilterMenu extends StatefulWidget {
  const FilterMenu({Key? key}) : super(key: key);

  @override
  _FilterMenuState createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu>
    with SingleTickerProviderStateMixin {
  late double screenWidth;
  late double buttonWidth;

  static const _animationDuration = Duration(milliseconds: 450);

  bool openSortBy = false;
  bool openFuelType = false;
  bool openDistance = false;

  bool isAnythingOpen() {
    return openSortBy || openFuelType || openDistance;
  }

  void closeAllFilters() {
    setState(() {
      openSortBy = false;
      openFuelType = false;
      openDistance = false;
    });
  }

  double getWidth(FilterType filterType) {
    switch (filterType) {
      case FilterType.SORT_BY:
        if (openSortBy) {
          return screenWidth;
        } else if (openFuelType || openDistance) {
          return 0;
        } else {
          return buttonWidth;
        }
      case FilterType.FUEL_TYPE:
        if (openFuelType) {
          return screenWidth;
        } else if (openSortBy || openDistance) {
          return 0;
        } else {
          return buttonWidth;
        }
      case FilterType.DISTANCE:
        if (openDistance) {
          return screenWidth;
        } else if (openSortBy || openFuelType) {
          return 0;
        } else {
          return buttonWidth;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width - 30;
    buttonWidth = screenWidth / 3.0 - 10;

    return Row(
      mainAxisAlignment: isAnythingOpen()
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              openSortBy = true;
            });
          },
          child: AnimatedContainer(
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: isAnythingOpen() ? Colors.transparent : Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(10)),
            width: getWidth(FilterType.SORT_BY),
            height: 50,
            duration: _animationDuration,
            child: openSortBy
                ? SortByOptions(onTapClose: closeAllFilters)
                : Center(
                    child: Text(
                    'Sort by',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                  )),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              openFuelType = true;
            });
          },
          child: AnimatedContainer(
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: isAnythingOpen() ? Colors.transparent : Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(10)),
            width: getWidth(FilterType.FUEL_TYPE),
            height: 50,
            duration: _animationDuration,
            child: openFuelType
                ? FuelTypeOptions(onTapClose: closeAllFilters)
                : Center(
                    child: Text(
                    'Fuel type',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  )),
          ),
        ),
        GestureDetector(
            onTap: () {
              setState(() {
                openDistance = true;
              });
            },
            child: AnimatedContainer(
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: isAnythingOpen() ? Colors.transparent : Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10)),
              width: getWidth(FilterType.DISTANCE),
              height: 50,
              duration: _animationDuration,
              child: openDistance
                  ? DistanceOptions(onTapClose: closeAllFilters)
                  : Center(
                      child: Text(
                      'Distance',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    )),
            )),
      ],
    );
  }
}
