import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuel_opt/model/filter_enums.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:fuel_opt/model/stations_data_model.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart' as appColors;
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
    final searchQuery = Provider.of<SearchQueryModel>(context);
    final sortByPreference = Provider.of<SortByPreferenceModel>(context);
    final fuelTypePreference = Provider.of<FuelTypePreferenceModel>(context);
    final distancePreference = Provider.of<DistancePreferenceModel>(context);
    final facilitiesPreference =
        Provider.of<FacilitiesPreferenceModel>(context);
    final searchResult = Provider.of<SearchResultModel>(context);

    return FractionallySizedBox(
      widthFactor: 0.8,
      heightFactor: 0.6,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Color(0xffdbdbdb)),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(child: Consumer<SearchQueryModel>(
              builder: (context, searchQueryModel, childWidget) {
                print(searchQueryModel.searchQuery);
                _textEditingController.text = searchQueryModel.searchQuery;
                _textEditingController.selection = TextSelection.fromPosition(
                    TextPosition(
                        affinity: TextAffinity.downstream,
                        offset: _textEditingController.text.length));
                return TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                      hintText: 'Gas stations near...',
                      border: InputBorder.none),
                  onTap: widget.searchOnTap,
                  onChanged: (value) {
                    searchQueryModel.setSearchQuery(value);
                  },
                );
              },
            )),
            IconButton(
                padding: const EdgeInsets.all(8.0),
                constraints: const BoxConstraints(),
                onPressed: () async {
                  if (sortByPreference.sortByPreference.string == 'price' &&
                      fuelTypePreference.fuelTypePreference.string.isEmpty) {
                    Fluttertoast.showToast(msg: "Please select a fuel type");
                  } else {
                    FuelStationDataService fuelStationDataService =
                        FuelStationDataService();
                    List coordinates =
                        await fuelStationDataService.address2Coordinates(
                            searchQuery.searchQuery.toString());
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
                        searchQuery.searchQuery.toString(),
                        sortByPreference.sortByPreference.string,
                        fuelTypePreference.fuelTypePreference.string,
                        distancePreference.distancePreference.toString(),
                        facilitiesPreference.facilitiesPreference.toString(),
                      );
                      searchResult.setSearchResult(stations);
                      Navigator.pop(context);
                    }
                  }
                },
                icon: const Icon(
                  Icons.search,
                  color: appColors.PrimaryBlue,
                ))
          ],
        ),
      ),
    );
  }
}
