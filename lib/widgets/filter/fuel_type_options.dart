import 'package:flutter/material.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:provider/provider.dart';

class FuelTypeOptions extends StatelessWidget {
  final void Function() onTapClose;

  const FuelTypeOptions({Key? key, required this.onTapClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SearchOptions>(context);

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 40.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 10,
            children: [
              ElevatedButton(
                  onPressed: () {
                    state.filterOptions.fuel_type = 'unleaded';
                  },
                  child: const Text('Unleaded')),
              ElevatedButton(
                  onPressed: () {
                    state.filterOptions.fuel_type = 'super_unleaded';
                  },
                  child: const Text('Super Unleaded')),
              ElevatedButton(
                  onPressed: () {
                    state.filterOptions.fuel_type = 'diesel';
                  },
                  child: const Text('Diesel')),
              ElevatedButton(
                  onPressed: () {
                    state.filterOptions.fuel_type = 'premium_diesel';
                  },
                  child: const Text('Super Diesel')),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: IconButton(
            onPressed: onTapClose,
            icon: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).primaryColor,
                ))),
      )
    ]);
  }
}
