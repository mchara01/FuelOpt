import 'package:flutter/material.dart';
import 'package:fuel_opt/model/filter_enums.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/widgets/search_result_list.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart' as appColors;
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/model/stations_model.dart';

class SearchBar extends StatefulWidget {
  final void Function() searchOnTap;

  const SearchBar({required this.searchOnTap});

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
    final searchResult = Provider.of<SearchResultModel>(context);

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
                        hintText: 'Current Location', border: InputBorder.none),
                    onTap: widget.searchOnTap,
                    onChanged: (value) {
                      searchQueryModel.setSearchQuery(value);
                    },
                  );
                },
              )),
              TextButton(
                  onPressed: () async {
                    FuelStationDataService fuelStationDataService =
                        FuelStationDataService();
                    List<StationResult> stations =
                        await fuelStationDataService.getSearchResults(
                            searchQuery.searchQuery.toString(),
                            sortByPreference.sortByPreference.string,
                            fuelTypePreference.fuelTypePreference.string,
                            distancePreference.distancePreference.toString());
                    // searchResult.stations = stations;
                    searchResult.setSearchResult(stations);
                    // return Center(child: SearchResultList(stations: stations));
                    // print(stations);
                    // await Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) =>
                    //       SearchResultList(stations: stations),
                    // ));
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
