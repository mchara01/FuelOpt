import 'package:flutter/material.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:provider/provider.dart';

class DistanceOptions extends StatefulWidget {
  final void Function() onTapClose;

  const DistanceOptions({Key? key, required this.onTapClose}) : super(key: key);

  @override
  State<DistanceOptions> createState() => _DistanceOptionsState();
}

class _DistanceOptionsState extends State<DistanceOptions> {
  double distance = 30;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(right: 40.0),
        child: Consumer<DistancePreferenceModel>(
          builder: (context, distancePreferenceModel, childWidget) {
            return Column(
              children: [
                Expanded(
                    child: Text(distancePreferenceModel.distancePreference
                            .round()
                            .toString() +
                        ' km')),
                Expanded(
                  child: Slider(
                    value: distancePreferenceModel.distancePreference,
                    min: 0,
                    max: 50,
                    divisions: 50,
                    onChanged: (newDistance) {
                      distancePreferenceModel
                          .setDistancePreference(newDistance);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: IconButton(
            onPressed: widget.onTapClose,
            icon: Icon(
              Icons.close,
              color: Theme.of(context).primaryColor,
            )),
      )
    ]);
  }
}
