import 'package:flutter/material.dart';

class SortByOptions extends StatelessWidget {
  final void Function() onTapClose;

  const SortByOptions({Key? key, required this.onTapClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () {}, child: const Text('Price'))),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: ElevatedButton(
                    onPressed: () {}, child: const Text('Distance'))),
          ],
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
