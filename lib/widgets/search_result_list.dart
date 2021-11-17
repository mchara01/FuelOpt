import 'package:flutter/material.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/model/stations_model.dart';
import 'package:fuel_opt/widgets/station_info.dart';
import 'package:provider/provider.dart';
import '../utils/appColors.dart' as appColors;

class SearchResultList extends StatefulWidget {
  final List<StationResult?> stations;
  const SearchResultList({Key? key, required this.stations}) : super(key: key);

  @override
  _SearchResultListState createState() => _SearchResultListState();
}

class _SearchResultListState extends State<SearchResultList> {
  Widget build(BuildContext context) {
    final state = Provider.of<SearchOptions>(context);

    return Center(
      child:
          // Column(mainAxisAlignment: MainAxisAlignment.start, children: <
          //     Widget>[
          widget.stations.isEmpty
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: widget.stations.length,
                  itemBuilder: (context, i) {
                    return Container(
                        child: InkWell(
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SearchInfo(
                                        station: widget.stations[i]);
                                  }));
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.stations[i]!.name,
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
                                            Text(widget.stations[i]!.street),
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
                                            Text(widget.stations[i]!.duration),
                                          ],
                                        ),
                                        SizedBox(height: 7),
                                        Row(children: [
                                          Icon(
                                            Icons.attach_money,
                                            size: 15,
                                          ),
                                          if (state.filterOptions.fuel_type ==
                                              'unleaded')
                                            SizedBox(width: 5),
                                          Text(widget.stations[i]!.price
                                                  .unleadedPrice
                                                  .toString() +
                                              'p'),
                                          if (state.filterOptions.fuel_type ==
                                              'super_unleaded')
                                            SizedBox(width: 5),
                                          Text(widget.stations[i]!.price
                                                  .superUnleadedPrice
                                                  .toString() +
                                              'p'),
                                          if (state.filterOptions.fuel_type ==
                                              'diesel')
                                            SizedBox(width: 5),
                                          Text(widget.stations[i]!.price
                                                  .dieselPrice
                                                  .toString() +
                                              'p'),
                                          if (state.filterOptions.fuel_type ==
                                              'premium_iesel')
                                            SizedBox(width: 5),
                                          Text(widget.stations[i]!.price
                                                  .premiumDieselPrice
                                                  .toString() +
                                              'p'),
                                        ])
                                      ],
                                    ),
                                  ))
                                ]))));
                  }),
      // ])
    );
  }
}
