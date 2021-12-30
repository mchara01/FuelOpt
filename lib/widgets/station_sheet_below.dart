import 'package:flutter/material.dart';
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/model/fuelprice_model.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/model/top_3_station_result.dart';
import 'package:fuel_opt/widgets/filter/filter_menu.dart';
import '../model/filter_enums.dart';

class StationSheetBelow extends StatelessWidget {
  const StationSheetBelow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder<List<Top3StationResult>>(
        future: FuelStationDataService().getTopThreeStationsLocal(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Top3StationResult>> asyncSnapShot) {
          if (asyncSnapShot.connectionState == ConnectionState.done &&
              asyncSnapShot.hasData) {
            return CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                const SliverAppBar(
                  expandedHeight: 50,
                  collapsedHeight: 50,
                  toolbarHeight: 50,
                  floating: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: FilterMenu(),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  List<Top3StationResult>? top3StationResults =
                      asyncSnapShot.data;
                  FuelTypePreference fuelTypePreference = top3StationResults![index].fuelTypePreference;
                  List<StationResult> stationResults =
                      top3StationResults[index].top3Stations;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(fuelTypePreference.displayString, style: Theme.of(context).textTheme.headline6,),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          StationResult stationResult = stationResults[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                        Text(stationResult.name, overflow: TextOverflow.ellipsis,),
                                        const SizedBox(height: 5,),
                                        Row(children: [
                                          const Icon(Icons.location_pin),
                                          Text(stationResult.street + ' · ' + stationResult.distance!,)
                                        ]),
                                        const SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            const Icon(Icons.timer),
                                            Text(stationResult.duration!),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.eco_outlined),
                                            Text(stationResult.emission!)
                                          ],
                                        )
                                      ]),
                                    ),
                                    Text(getPriceForPreference(stationResult.price, fuelTypePreference).toString()),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: stationResults.length,
                      )
                    ],
                  );
                }, childCount: asyncSnapShot.data!.length))
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  color: Theme.of(context).primaryColor,
                  size: 100,
                ),
                const Text(
                  'No results to display',
                  style: TextStyle(
                    color: Colors.black12,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}

String? getPriceForPreference(FuelPrice price, FuelTypePreference preference) {
  switch(preference) {
    case FuelTypePreference.UNLEADED:
      return price.unleadedPrice;
    case FuelTypePreference.DIESEL:
      return price.dieselPrice;
    case FuelTypePreference.PREMIUM_DIESEL:
      return price.premiumDieselPrice;
    case FuelTypePreference.SUPER_UNLEADED:
      return price.superUnleadedPrice;
    case FuelTypePreference.NONE:
      break;
  }
}