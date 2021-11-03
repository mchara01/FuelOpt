import 'package:flutter/material.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';

class SortCondition {
  String name;
  bool isSelected;

  SortCondition({
    required this.name,
    required this.isSelected,
  });
}

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  List<String> _dropDownHeaderItemStrings = [
    'Sort By',
    'Fuel Type',
    'Distance',
    'More'
  ];
  List<SortCondition> _sortConditions = [];
  List<SortCondition> _fuleTypeConditions = [];
  List<SortCondition> _distanceSortConditions = [];
  late SortCondition _selectSortCondition;
  late SortCondition _selectFuelTypeSortCondition;
  late SortCondition _selectDistanceSortCondition;
  GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();

  String _seletedSortConditions = '';
  String _seletedFuleTypeConditions = '';
  String _seletedDistanceSortConditions = '';

  @override
  void initState() {
    super.initState();

    _sortConditions.add(SortCondition(name: 'Price', isSelected: true));
    _sortConditions.add(SortCondition(name: 'Distance', isSelected: false));
    _sortConditions
        .add(SortCondition(name: 'Carbon Footprint', isSelected: false));
    _selectSortCondition = _sortConditions[0];
    _seletedSortConditions = _selectSortCondition.name;

    // _fuleTypeConditions.add(SortCondition(name: 'All', isSelected: true));
    _fuleTypeConditions.add(SortCondition(name: 'Unleaded', isSelected: true));
    _fuleTypeConditions
        .add(SortCondition(name: 'Super Unleaded', isSelected: false));
    _fuleTypeConditions.add(SortCondition(name: 'Diesel', isSelected: false));
    _selectFuelTypeSortCondition = _fuleTypeConditions[0];
    _seletedFuleTypeConditions = _selectFuelTypeSortCondition.name;

    _distanceSortConditions.add(SortCondition(name: '1km', isSelected: false));
    _distanceSortConditions.add(SortCondition(name: '3km', isSelected: false));
    _distanceSortConditions.add(SortCondition(name: '5km', isSelected: true));
    _distanceSortConditions.add(SortCondition(name: '10km', isSelected: false));
    _selectDistanceSortCondition = _distanceSortConditions[2];
    _seletedDistanceSortConditions = _selectDistanceSortCondition.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            key: _scaffoldKey,
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(-45),
        ),
        backgroundColor: Colors.white,
        endDrawer: Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 4, top: 0),
          color: Colors.white,
        ),
        body:
        Container(
            color: Colors.white,
            child: Stack(
              key: _stackKey,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Showing results for $_seletedFuleTypeConditions within $_seletedDistanceSortConditions sort by $_seletedSortConditions',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    GZXDropDownHeader(
                      height: 150,
                      items: [
                        GZXDropDownHeaderItem(
                          _dropDownHeaderItemStrings[0],
                          iconData: Icons.keyboard_arrow_down,
                          iconDropDownData: Icons.keyboard_arrow_up,
                        ),
                        GZXDropDownHeaderItem(
                          _dropDownHeaderItemStrings[1],
                          iconData: Icons.keyboard_arrow_down,
                          iconDropDownData: Icons.keyboard_arrow_up,
                        ),
                        GZXDropDownHeaderItem(
                          _dropDownHeaderItemStrings[2],
                          iconData: Icons.keyboard_arrow_down,
                          iconDropDownData: Icons.keyboard_arrow_up,
                        ),
                        GZXDropDownHeaderItem(
                          _dropDownHeaderItemStrings[3],
                          iconData: Icons.filter_frames,
                          iconSize: 18,
                        ),
                      ],
                      stackKey: _stackKey,
                      controller: _dropdownMenuController,
                      onItemTap: (index) {
                        if (index == 3) {
                          _dropdownMenuController.hide();
                          _scaffoldKey.currentState!.openEndDrawer();
                        }
                      },
                      style: TextStyle(color: Color(0xFF666666), fontSize: 14),
                      dropDownStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                          itemCount: 10,
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(height: 1.0),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: ListTile(
                                leading: Text('test$index'),
                              ),
                              onTap: () {},
                            );
                          }),
                    ),
                  ],
                ),
                GZXDropDownMenu(
                  controller: _dropdownMenuController,
                  animationMilliseconds: 300,
                  menus: [
                    GZXDropdownMenuBuilder(
                        dropDownHeight: 40.0 * _sortConditions.length,
                        dropDownWidget:
                            _buildConditionListWidget(_sortConditions, (value) {
                          _selectSortCondition = value;
                          _dropdownMenuController.hide();
                          setState(() {
                            _seletedSortConditions = _selectSortCondition.name;
                          });
                        })),
                    GZXDropdownMenuBuilder(
                        dropDownHeight: 40.0 * _fuleTypeConditions.length,
                        dropDownWidget: _buildConditionListWidget(
                            _fuleTypeConditions, (value) {
                          _selectFuelTypeSortCondition = value;
                          // _dropDownHeaderItemStrings[1] =
                          //     _selectFuelTypeSortCondition.name == 'All'
                          //         ? 'Fuel Type'
                          //         : _selectFuelTypeSortCondition.name;
                          _dropdownMenuController.hide();
                          setState(() {
                            _seletedFuleTypeConditions =
                                _selectFuelTypeSortCondition.name;
                          });
                        })),
                    GZXDropdownMenuBuilder(
                        dropDownHeight: 40.0 * _distanceSortConditions.length,
                        dropDownWidget: _buildConditionListWidget(
                            _distanceSortConditions, (value) {
                          _selectDistanceSortCondition = value;
                          _dropDownHeaderItemStrings[2] =
                              _selectDistanceSortCondition.name;
                          _dropdownMenuController.hide();
                          setState(() {
                            _seletedDistanceSortConditions =
                                _selectDistanceSortCondition.name;
                          });
                        })),
                  ],
                ),
              ],
              // ),
            ));
  }

  _buildConditionListWidget(
      items, void itemOnTap(SortCondition sortCondition)) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 1.0),
      itemBuilder: (BuildContext context, int index) {
        return gestureDetector(items, index, itemOnTap, context);
      },
    );
  }

  GestureDetector gestureDetector(items, int index,
      void itemOnTap(SortCondition sortCondition), BuildContext context) {
    SortCondition goodsSortCondition = items[index];
    return GestureDetector(
      onTap: () {
        for (var value in items) {
          value.isSelected = false;
        }
        goodsSortCondition.isSelected = true;

        itemOnTap(goodsSortCondition);
      },
      child: Container(
        height: 40,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                goodsSortCondition.name,
                style: TextStyle(
                  color: goodsSortCondition.isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                ),
              ),
            ),
            goodsSortCondition.isSelected
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                    size: 16,
                  )
                : SizedBox(),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}
