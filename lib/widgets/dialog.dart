import 'package:flutter/material.dart';
import '../utils/appColors.dart' as appColors;
import '../utils/theme.dart' as appTheme;
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class DialogWidget extends StatefulWidget {
  const DialogWidget({Key? key}) : super(key: key);

  @override
  _DialogWidgetState createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  bool visibility = true;
  String titleText = "Think ahead!";
  String captionText =
      "Fuel prices are projected to be change by 4.19% in the next 2 weeks. Maybe you should plan ahead?";

  Future<String> loadAsset() async {
    Future<String> stat = rootBundle.loadString('assets/trends_stats.txt');
    print("hihi" + await stat);
    return await stat;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _changed(bool visibility) {
    setState(() {
      visibility = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        visibility
            ? Container(
                width: size.width,
                height: size.height,
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 100,
                ),
                padding: const EdgeInsets.only(
                  top: 32,
                  left: 16,
                  right: 16,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  color: appColors.COLOR_White,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Image.asset('assets/graph.png', scale: 5),
                          Text(
                            titleText,
                            style: appTheme.TEXT_THEME_DEFAULT.headline1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            captionText,
                            style: appTheme.TEXT_THEME_DEFAULT.caption,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          _changed(visibility = false);
                        },
                        child: const Text('Continue'),
                        style: ElevatedButton.styleFrom(
                            primary: appColors.PrimaryBlue),
                      ),
                    ),
                  ],
                ),
              )
            : Container()
      ],
    );
  }
}
