import 'package:flutter/material.dart';
import 'package:fuel_opt/model/filter_enums.dart';
import 'package:fuel_opt/model/fuelprice_model.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/screens/stations_detail.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart' as appColors;

class SearchResultList extends StatelessWidget {
  final List<StationResult> stationResultList;

  const SearchResultList({Key? key, required this.stationResultList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, i) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return StationsDetail(stationResultList[i]);
          }));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(children: [
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stationResultList[i].name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 7),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: appColors.PrimaryBlue,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                            Text(
                              stationResultList[i].street,
                              style: TextStyle(
                                fontSize: 15,
                                color: appColors.PrimaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7),
                        Row(
                          children: [
                            if(stationResultList[i].duration != null) ...[
                              Icon(
                                Icons.timer,
                                size: 15,
                              ),
                              Text(stationResultList[i].duration!),
                            ],
                            if(stationResultList[i].emission != null) ...[
                              const Icon(
                                Icons.eco_outlined,
                                size: 15,
                              ),
                              Text(stationResultList[i].emission!)
                            ]
                          ],
                        ),
                      ],
                    ),
                  )),
                  Consumer<FuelTypePreferenceModel>(
                      builder: (context, fuelTypePreferenceModel, childWidget) {
                    return Text(getPriceForPreference(stationResultList[i].price,
                        fuelTypePreferenceModel.fuelTypePreference) ?? '--');
                  })
                ]),
              )),
        ),
      );
    }, childCount: stationResultList.length));
  }
}

String? getPriceForPreference(FuelPrice price, FuelTypePreference preference) {
  switch (preference) {
    case FuelTypePreference.UNLEADED:
      return price.unleadedPrice;
    case FuelTypePreference.DIESEL:
      return price.dieselPrice;
    case FuelTypePreference.PREMIUM_DIESEL:
      return price.premiumDieselPrice;
    case FuelTypePreference.SUPER_UNLEADED:
      return price.superUnleadedPrice;
    case FuelTypePreference.NONE:
      return '';
  }
}
