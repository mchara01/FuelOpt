import 'package:flutter/material.dart';
import 'package:fuel_opt/model/filter_enums.dart';
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
    final fuelTypePreference = Provider.of<FuelTypePreferenceModel>(context);

    return SliverList(
        delegate: SliverChildBuilderDelegate((context, i) {
      return Container(
          color: Colors.white,
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        StationsDetail(stationResultList[i])));
              },
              child: Row(children: [
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.blueGrey,
                  child: Icon(
                    Icons.local_gas_station_sharp,
                    size: 30,
                    // color: Colors.white,
                  ),
                ),
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
                          Icon(
                            Icons.timer,
                            size: 15,
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      Row(children: [
                        Icon(
                          Icons.attach_money,
                          size: 15,
                        ),
                        SizedBox(width: 5),
                        Visibility(
                            // visible: true,
                            visible:
                                fuelTypePreference.fuelTypePreference.string ==
                                    'unleaded',
                            child: Text(
                              stationResultList[i]
                                      .price
                                      .unleadedPrice
                                      .toString() +
                                  'p',
                              style: TextStyle(
                                fontSize: 15,
                                color: appColors.PrimaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        Visibility(
                            visible:
                                fuelTypePreference.fuelTypePreference.string ==
                                    'super_unleaded',
                            child: Text(
                              stationResultList[i]
                                      .price
                                      .superUnleadedPrice
                                      .toString() +
                                  'p',
                              style: TextStyle(
                                fontSize: 15,
                                color: appColors.PrimaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        Visibility(
                            visible:
                                fuelTypePreference.fuelTypePreference.string ==
                                    'diesel',
                            child: Text(
                              stationResultList[i]
                                      .price
                                      .dieselPrice
                                      .toString() +
                                  'p',
                              style: TextStyle(
                                fontSize: 15,
                                color: appColors.PrimaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        Visibility(
                            visible:
                                fuelTypePreference.fuelTypePreference.string ==
                                    'premium_diesel',
                            child: Text(
                              stationResultList[i]
                                      .price
                                      .premiumDieselPrice
                                      .toString() +
                                  'p',
                              style: TextStyle(
                                fontSize: 15,
                                color: appColors.PrimaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ])
                    ],
                  ),
                ))
              ])));
    }, childCount: stationResultList.length));
  }
}
