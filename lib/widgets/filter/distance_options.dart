import 'package:flutter/material.dart';

class DistanceOptions extends StatefulWidget {
  final void Function() onTapClose;

  const DistanceOptions({Key? key, required this.onTapClose}) : super(key: key);

  @override
  State<DistanceOptions> createState() => _DistanceOptionsState();
}

class _DistanceOptionsState extends State<DistanceOptions> {

  double distance = 50;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: Slider(
            value: distance,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: (newDistance) {
              setState(() {
                distance = newDistance;
              });
            },
            label: distance.round().toString(),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(onPressed: widget.onTapClose, icon: Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),child: Icon(Icons.close, color: Theme.of(context).primaryColor,))),
        )
    ]
    );
  }
}