import 'package:flutter/material.dart';
import 'package:fuel_opt/model/stations_model.dart';

class SearchResult extends StatelessWidget {
  // final Station station;
  // SearchResult(this.station);

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: Colors.black12,
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
    );
  }
}
