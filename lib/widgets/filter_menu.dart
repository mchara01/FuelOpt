import 'package:flutter/material.dart';

class FilterMenu extends StatefulWidget {
  const FilterMenu({Key? key}) : super(key: key);

  @override
  _FilterMenuState createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<int> _animation;
  late Animation<int> _reverseAnimation;

  bool currentWidget = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = IntTween(begin: 0, end: 30).animate(_animationController);
    _reverseAnimation = IntTween(begin: 30, end: 0).animate(_animationController);
    _animation.addListener(() => setState(() {}));
  }

    @override
    Widget build(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(flex: 30, child: SizedBox(
            width: 0,
            child: currentWidget ? OutlinedButton(onPressed: () {
              _animationController.forward();
            },child: Text('Sort by')) : SortByOptions(),
          )),
          Expanded(flex: _reverseAnimation.value, child: SizedBox(width: 0, child: OutlinedButton(onPressed: () {}, child: Text('Fuel Type', overflow: TextOverflow.ellipsis,)))),
          Expanded(flex: _reverseAnimation.value, child: SizedBox(width: 0, child: OutlinedButton(onPressed: () {}, child: Text('Distance', overflow: TextOverflow.ellipsis,),)))
        ],
      );
    }
}

class MenuOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(onPressed: () {}, child: Text('Sort By')),
        OutlinedButton(onPressed: () {}, child: Text('Fuel Type')),
        OutlinedButton(onPressed: () {}, child: Text('Distance'),)
      ],
    );
  }
}

class SortByOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(onPressed: () {}, child: Text('Price')),
        OutlinedButton(onPressed: () {}, child: Text('Distance'))
      ],
    );
  }
}

