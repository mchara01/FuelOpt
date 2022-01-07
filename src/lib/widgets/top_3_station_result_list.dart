import 'package:flutter/material.dart';
import 'package:fuel_opt/model/fuelprice_model.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/model/top_3_station_result.dart';
import 'package:fuel_opt/screens/stations_detail.dart';
import '../model/filter_enums.dart';

class Top3StationResultList extends StatelessWidget {
  final List<Top3StationResult> top3StationResultList;

  const Top3StationResultList({Key? key, required this.top3StationResultList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          FuelTypePreference fuelTypePreference = top3StationResultList[index]
              .fuelTypePreference;
          List<StationResult> stationResults =
              top3StationResultList[index].top3Stations;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(fuelTypePreference.displayString, style: Theme
                    .of(context)
                    .textTheme
                    .headline6,),
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  StationResult stationResult = stationResults[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return StationsDetail(stationResult);
                      }));
                    },
                    child: Padding(
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
                                      Text(stationResult.name,
                                        overflow: TextOverflow.ellipsis,),
                                      const SizedBox(height: 5,),
                                      Row(children: [
                                        const Icon(Icons.location_pin),
                                        Text(stationResult.street + ' · ' +
                                            stationResult.distance!,)
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
                              Text(getPriceForPreference(
                                  stationResult.price, fuelTypePreference)
                                  .toString()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: stationResults.length,
              )
            ],
          );
        }, childCount: top3StationResultList.length));
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