import 'package:flutter/material.dart';
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/model/current_location_model.dart';
import 'package:fuel_opt/model/filter_enums.dart';
import '../utils/app_colors.dart' as appColors;
import 'package:fuel_opt/model/search_options.dart';
import 'package:fuel_opt/model/stations_data_model.dart';
import 'package:provider/provider.dart';

class SearchBarSearchThisAreaButton extends StatefulWidget {
  const SearchBarSearchThisAreaButton({Key? key}) : super(key: key);

  @override
  State<SearchBarSearchThisAreaButton> createState() => _SearchBarSearchThisAreaButtonState();
}

class _SearchBarSearchThisAreaButtonState extends State<SearchBarSearchThisAreaButton> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: appColors.PrimaryBlue,
        primary: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () async {
        final sortByPreference = Provider
            .of<SortByPreferenceModel>(context, listen: false)
            .sortByPreference;
        final fuelTypePreference = Provider
            .of<FuelTypePreferenceModel>(context, listen: false)
            .fuelTypePreference;
        final distancePreference = Provider
            .of<DistancePreferenceModel>(context, listen: false)
            .distancePreference;
        final facilitiesPreference = Provider
            .of<FacilitiesPreferenceModel>(context, listen: false)
            .facilitiesPreference;

        FuelStationDataService fuelStationDataService =
        FuelStationDataService();

        setState(() {
          loading = true;
        });

        List<Station> stations = [];

        if (sortByPreference != SortByPreference.NONE ||
            fuelTypePreference != FuelTypePreference.NONE ||
            facilitiesPreference.isNotEmpty) {

          final currentLocationModel = Provider.of<CurrentLocationModel>(
              context, listen: false).getLatLng();

          stations = await fuelStationDataService.getSearchResults(
              '',
              sortByPreference.string,
              fuelTypePreference.string,
              distancePreference.toString(),
              facilitiesPreference.toString(),
              currentLocationModel.latitude.toString(),
              currentLocationModel.longitude.toString());
        }
        else {

          final currentLatLngBounds =
          Provider.of<CurrentLocationModel>(context, listen: false).getLatLngBounds();

          stations = await fuelStationDataService.getStations(currentLatLngBounds);
        }

        Provider.of<SearchResultModel>(context, listen: false).setSearchResult(stations);

        setState(() {
          loading = false;
        });
      },
      child: loading ? const CircularProgressIndicator(color: Colors.white,) : Row(
        children: const [
          Icon(Icons.search, color: Colors.white,),
          Text('Search this area'),
        ],
      ),
    );
  }
}
