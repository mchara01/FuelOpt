import 'package:flutter/material.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:provider/provider.dart';
import '../utils/appColors.dart' as appColors;
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/model/stations_model.dart';

class SearchBar extends StatefulWidget {
  final void Function() searchOnTap;

  const SearchBar({required this.searchOnTap});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchBar> {
  var _location;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SearchOptions>(context);

    return FractionallySizedBox(
      widthFactor: 0.8,
      heightFactor: 0.6,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Color(0xffdbdbdb)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: TextField(
                decoration: const InputDecoration(
                    hintText: 'Current Location', border: InputBorder.none),
                onTap: widget.searchOnTap,
                onChanged: (value) {
                  _location = value;
                  state.location = _location;
                },
              )),
              TextButton(
                  onPressed: () async {
                    print(state.location);
                    print(state.filterOptions.sort_by);
                    print(state.filterOptions.fuel_type);
                    print(state.filterOptions.distance);
                    FuelStationDataService fuelStationDataService =
                        FuelStationDataService();
                    List<Station>? stations = await fuelStationDataService
                        .getSearchResults(_location, state.filterOptions);
                    ;
                    print(stations);
                  },
                  child: Icon(
                    Icons.search,
                    color: appColors.PrimaryBlue,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
