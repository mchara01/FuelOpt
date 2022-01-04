import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuel_opt/model/current_location_model.dart';
import 'package:fuel_opt/model/filter_enums.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:fuel_opt/model/stations_data_model.dart';
import 'package:fuel_opt/widgets/search_bar_search_this_area_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fuel_opt/api/api.dart';

class SearchBar extends StatefulWidget {
  final void Function() searchOnTap;

  const SearchBar({Key? key, required this.searchOnTap}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchBar> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final searchQueryModel = Provider.of<SearchQueryModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        children: [
          Flexible(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: const Color(0xffdbdbdb)),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                      hintText: 'Gas stations near...', border: InputBorder.none),
                      onTap: widget.searchOnTap,
                      onChanged: (value) {
                    searchQueryModel.setSearchQuery(value);
                      },
                    ),
                  ),
                  IconButton(
                      padding: const EdgeInsets.all(8.0),
                      constraints: const BoxConstraints(),
                      disabledColor: Colors.grey,
                      color: Theme.of(context).primaryColor,
                      onPressed: Provider.of<SearchQueryModel>(context).searchQuery.isEmpty ? null : () async {

                        final currentSearchQuery = Provider.of<SearchQueryModel>(context, listen: false);
                        final sortByPreference = Provider.of<SortByPreferenceModel>(context, listen: false);
                        final fuelTypePreference = Provider.of<FuelTypePreferenceModel>(context, listen: false);
                        final distancePreference = Provider.of<DistancePreferenceModel>(context, listen: false);
                        final facilitiesPreference =
                        Provider.of<FacilitiesPreferenceModel>(context, listen: false);
                        final searchResult = Provider.of<SearchResultModel>(context, listen: false);
                        final currentLocation = Provider.of<CurrentLocationModel>(context, listen: false);


                        FuelStationDataService fuelStationDataService =
                            FuelStationDataService();
                        List coordinates = [];
                        if (currentSearchQuery.searchQuery.isEmpty) {
                          coordinates = [
                            currentLocation.getLatLng().latitude,
                            currentLocation.getLatLng().longitude
                          ];
                        } else {
                          List coordinates1 =
                              await fuelStationDataService.address2Coordinates(
                                  currentSearchQuery.searchQuery.toString());
                          List coordinates2 =
                              await fuelStationDataService.postcode2Coordinates(
                                  currentSearchQuery.searchQuery.toString());
                          coordinates =
                              coordinates2.isNotEmpty ? coordinates2 : coordinates1;
                        }
                        if (coordinates.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please input a valid location");
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => Center(
                              child: Container(
                                width: 60.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: CupertinoActivityIndicator(),
                                ),
                              ),
                            ),
                          );
                          List<Station> stations =
                              await fuelStationDataService.getSearchResults(
                            _textEditingController.text,
                            sortByPreference.sortByPreference.string,
                            fuelTypePreference.fuelTypePreference.string,
                            distancePreference.distancePreference.toString(),
                            facilitiesPreference.facilitiesPreference.toString(),
                            '',
                            '',
                          );
                          searchResult.setSearchResult(stations);
                          currentLocation.animateCameraToPosition(LatLng(double.parse(coordinates[0]), double.parse(coordinates[1])));
                          Navigator.pop(context);
                        }
                        // }
                      },
                      icon: const Icon(
                        Icons.search,
                      ))
                ],
              ),
            ),
          ),
          SizedBox(width: 5,),
          Flexible(flex: 1, child: const SearchBarSearchThisAreaButton())
        ],
      ),
    );
  }
}
