import 'package:flutter/material.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart' as appColors;

class DistanceOptions extends StatefulWidget {
  final void Function() onTapClose;

  const DistanceOptions({Key? key, required this.onTapClose}) : super(key: key);

  @override
  State<DistanceOptions> createState() => _DistanceOptionsState();
}

class _DistanceOptionsState extends State<DistanceOptions> {

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
                    activeColor: appColors.PrimaryBlue, // The color to use for the portion of the slider track that is active.
                    thumbColor: appColors.PrimaryBlue,
                    min: 1,
                    max: 15,
                    divisions: 14,
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
