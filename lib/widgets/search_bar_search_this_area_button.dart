import 'package:flutter/material.dart';
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/model/current_location_model.dart';
import '../utils/app_colors.dart' as appColors;
import 'package:fuel_opt/model/search_options.dart';
import 'package:fuel_opt/model/stations_data_model.dart';
import 'package:provider/provider.dart';

class SearchBarSearchThisAreaButton extends StatelessWidget {
  const SearchBarSearchThisAreaButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: appColors.PrimaryBlue,
        primary: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () async {
        FuelStationDataService fuelStationDataService =
            FuelStationDataService();

        List<Station> stations = [];

        final currentLatLngBounds =
            Provider.of<CurrentLocationModel>(context, listen: false)
                .getLatLngBounds();

        stations =
            await fuelStationDataService.getStations(currentLatLngBounds);

        final searchResultModel =
            Provider.of<SearchResultModel>(context, listen: false);
        searchResultModel.setSearchResult(stations);
      },
      child: const Text('Search this area'),
    );
  }
}
