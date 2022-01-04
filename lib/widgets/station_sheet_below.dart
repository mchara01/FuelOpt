import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/model/top_3_station_result.dart';
import 'package:fuel_opt/widgets/search_result_list.dart';
import 'package:fuel_opt/widgets/top_3_station_result_list.dart';
import 'package:provider/provider.dart';

import 'filter/filter_menu.dart';

class StationSheetBelow extends StatelessWidget {
  const StationSheetBelow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverAppBar(
              expandedHeight: 50,
              collapsedHeight: 50,
              toolbarHeight: 50,
              floating: true,
              flexibleSpace: const FlexibleSpaceBar(
                background: FilterMenu(),
              ),
              backgroundColor: Colors.white,
              elevation: 0.0,
              leading: Container(),
            ),
            Consumer<SearchResultModel>(
              builder: (context, searchResult, childWidget) {
                if (searchResult.stations.isNotEmpty) {
                  if (searchResult.stations is List<Top3StationResult>) {
                    return Top3StationResultList(
                        top3StationResultList: searchResult.stations as List<
                            Top3StationResult>);
                  }
                  else {
                    return SearchResultList(stationResultList: searchResult.stations as List<StationResult>);
                  }
                }
                else{
                  return SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Icon(
                            Icons.search,
                            color: Theme.of(context).primaryColor,
                            size: 100,
                          ),
                        ),
                        Flexible(
                          child: const Text(
                            'No results to display',
                            style: TextStyle(
                              color: Colors.black12,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              }
            )
          ]),
    );
  }
}
