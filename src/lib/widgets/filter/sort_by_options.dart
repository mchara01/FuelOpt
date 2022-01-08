import 'package:flutter/material.dart';
import 'package:fuel_opt/model/filter_enums.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';

class SortByOptions extends StatelessWidget {
  final void Function() onTapClose;
  final Future<void> Function() search;

  const SortByOptions(
      {Key? key, required this.onTapClose, required this.search})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color selectedTextColor =
        Theme.of(context).buttonTheme.selectedTextColor;
    final Color selectedButtonColor =
        Theme.of(context).buttonTheme.selectedButtonColor(context);

    final Color unselectedTextColor =
        Theme.of(context).buttonTheme.unselectedTextColor(context);
    final Color unselectedButtonColor =
        Theme.of(context).buttonTheme.unselectedButtonColor;

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 40.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 10,
            children: [
              Consumer<SortByPreferenceModel>(
                builder: (context, sortByPreferenceModel, childWidget) {
                  bool isSortByPrice = sortByPreferenceModel.sortByPreference ==
                      SortByPreference.PRICE;
                  return TextButton(
                      onPressed: () {
                        if (isSortByPrice) {
                          sortByPreferenceModel
                              .setSortByPreference(SortByPreference.NONE);
                        } else {
                          sortByPreferenceModel
                              .setSortByPreference(SortByPreference.PRICE);
                        }
                        search();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              isSortByPrice
                                  ? selectedButtonColor
                                  : unselectedButtonColor),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      child: Text(
                        'Price',
                        style: TextStyle(
                            color: isSortByPrice
                                ? selectedTextColor
                                : unselectedTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ));
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Consumer<SortByPreferenceModel>(
                builder: (context, sortByPreferenceModel, childWidget) {
                  bool isSortByTimeToArrival =
                      sortByPreferenceModel.sortByPreference ==
                          SortByPreference.TIME_TO_ARRIVAL;
                  return TextButton(
                      onPressed: () {
                        if (isSortByTimeToArrival) {
                          sortByPreferenceModel
                              .setSortByPreference(SortByPreference.NONE);
                        } else {
                          sortByPreferenceModel.setSortByPreference(
                              SortByPreference.TIME_TO_ARRIVAL);
                        }
                        search();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              isSortByTimeToArrival
                                  ? selectedButtonColor
                                  : unselectedButtonColor),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      child: Text(
                        'Time To Arrival',
                        style: TextStyle(
                            color: isSortByTimeToArrival
                                ? selectedTextColor
                                : unselectedTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ));
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Consumer<SortByPreferenceModel>(
                builder: (context, sortByPreferenceModel, childWidget) {
                  bool isSortByEco = sortByPreferenceModel.sortByPreference ==
                      SortByPreference.CARBON_EMISSION;
                  return TextButton(
                      onPressed: () {
                        if (isSortByEco) {
                          sortByPreferenceModel
                              .setSortByPreference(SortByPreference.NONE);
                        } else {
                          sortByPreferenceModel.setSortByPreference(
                              SortByPreference.CARBON_EMISSION);
                        }
                        search();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              isSortByEco
                                  ? selectedButtonColor
                                  : unselectedButtonColor),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      child: Text(
                        'Carbon Emission',
                        style: TextStyle(
                            color: isSortByEco
                                ? selectedTextColor
                                : unselectedTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ));
                },
              ),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: IconButton(
            onPressed: onTapClose,
            icon: Icon(
              Icons.close,
              color: Theme.of(context).primaryColor,
            )),
      ),
    ]);
  }
}
