import 'package:flutter/material.dart';
import '../utils/appColors.dart' as appColors;

class BorderBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double width, height;

  BorderBox(
      {Key? key,
      required this.padding,
      required this.width,
      required this.height,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: appColors.COLOR_White,
          borderRadius: BorderRadius.circular(15),
          border:
              Border.all(color: appColors.COLOR_GREY.withAlpha(40), width: 2)),
      padding: padding,
      child: Center(child: child),
    );
  }
}
