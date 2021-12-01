import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/widgets/filter/filter_menu.dart';

class StationSheetBelow extends StatelessWidget {
  const StationSheetBelow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StationResult>>(
      future: FuelStationDataService().getStationsLocal(),
      builder: (BuildContext context,
          AsyncSnapshot<List<StationResult>> asyncSnapShot) {
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
                return ListTile(
                  title: Text('item: ' + index.toString())
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
    );
  }
}
