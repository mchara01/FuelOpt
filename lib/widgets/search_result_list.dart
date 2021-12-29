import 'package:flutter/material.dart';
import 'package:fuel_opt/model/filter_enums.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/model/stations_model.dart';
import 'package:fuel_opt/screens/stations_detail.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart' as appColors;

class SearchResultList extends StatefulWidget {
  @override
  _SearchResultListState createState() => _SearchResultListState();
}

class _SearchResultListState extends State<SearchResultList> {
  Widget build(BuildContext context) {
    final fuelTypePreference = Provider.of<FuelTypePreferenceModel>(context);
    final searchResult = Provider.of<SearchResultModel>(context);

    return SizedBox(
        height: 500,
        child: Consumer<SearchResultModel>(
            builder: (context, searchResultModel, child) {
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: <
              Widget>[
            searchResultModel.stations.isEmpty
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: appColors.PrimaryBlue,
                          size: 100,
                        ),
                        Text(
                          'No results to display',
                          style: TextStyle(
                            color: Colors.black12,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  )
                : Expanded(
                    child: Scrollbar(
                        child: ListView.builder(
                            padding: EdgeInsets.only(top: 50),
                            itemCount: searchResultModel.stations.length,
                            itemBuilder: (context, i) {
                              return Container(
                                  color: Colors.white,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StationsDetail(
                                                            searchResultModel
                                                                .stations[i])));
                                          },
                                          child: Row(children: [
                                            Container(
                                              height: 75,
                                              width: 75,
                                              color: Colors.blueGrey,
                                              child: Icon(
                                                Icons.local_gas_station_sharp,
                                                size: 30,
                                              ),
                                            ),
                                            Flexible(
                                                child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    searchResultModel
                                                        .stations[i].name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 7),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: appColors
                                                            .PrimaryBlue,
                                                        size: 15,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        searchResultModel
                                                            .stations[i].street,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: appColors
                                                              .PrimaryBlue,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                      SizedBox(width: 5),
                                                      Text(
                                                        searchResultModel
                                                            .stations[i]
                                                            .duration,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: appColors
                                                              .PrimaryBlue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Icon(
                                                        Icons
                                                            .add_location_outlined,
                                                        size: 15,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        searchResultModel
                                                            .stations[i]
                                                            .distance,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: appColors
                                                              .PrimaryBlue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Icon(
                                                        Icons.eco_outlined,
                                                        size: 15,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        searchResultModel
                                                            .stations[i]
                                                            .emission,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: appColors
                                                              .PrimaryBlue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
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
                                                        visible: fuelTypePreference
                                                                .fuelTypePreference
                                                                .string ==
                                                            'unleaded',
                                                        child: Text(
                                                          searchResultModel
                                                                  .stations[i]
                                                                  .price
                                                                  .unleadedPrice
                                                                  .toString() +
                                                              'p',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: appColors
                                                                .PrimaryBlue,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )),
                                                    Visibility(
                                                        visible: fuelTypePreference
                                                                .fuelTypePreference
                                                                .string ==
                                                            'super_unleaded',
                                                        child: Text(
                                                          searchResultModel
                                                                  .stations[i]
                                                                  .price
                                                                  .superUnleadedPrice
                                                                  .toString() +
                                                              'p',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: appColors
                                                                .PrimaryBlue,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )),
                                                    Visibility(
                                                        visible: fuelTypePreference
                                                                .fuelTypePreference
                                                                .string ==
                                                            'diesel',
                                                        child: Text(
                                                          searchResultModel
                                                                  .stations[i]
                                                                  .price
                                                                  .dieselPrice
                                                                  .toString() +
                                                              'p',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: appColors
                                                                .PrimaryBlue,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )),
                                                    Visibility(
                                                        visible: fuelTypePreference
                                                                .fuelTypePreference
                                                                .string ==
                                                            'premium_diesel',
                                                        child: Text(
                                                          searchResultModel
                                                                  .stations[i]
                                                                  .price
                                                                  .premiumDieselPrice
                                                                  .toString() +
                                                              'p',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: appColors
                                                                .PrimaryBlue,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )),
                                                  ])
                                                ],
                                              ),
                                            ))
                                          ]))));
                            })))
          ]);
        }));
  }
}
