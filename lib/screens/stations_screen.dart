import 'package:flutter/material.dart';
import 'package:fuel_opt/api/api.dart';
import 'package:provider/provider.dart';

class StationsScreen extends StatelessWidget {
  const StationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stationsP = Provider.of<StationsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Stations List')),
      body: ListView.builder(
          itemCount: stationsP.stations.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(stationsP.stations[index].title),
              subtitle: Text(stationsP.stations[index].id.toString()),
            );
          }),
    );
  }
}
