import 'package:flutter/material.dart';
import 'package:fuel_opt/model/filter_enums.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:provider/provider.dart';
import '../../utils/appColors.dart';

class SortByOptions extends StatelessWidget {
  final void Function() onTapClose;

  const SortByOptions({Key? key, required this.onTapClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color selectedTextColor = Theme.of(context).buttonTheme.selectedTextColor(context);
    final Color selectedButtonColor = Theme.of(context).buttonTheme.selectedButtonColor;

    final Color unselectedTextColor = Theme.of(context).buttonTheme.unselectedTextColor;
    final Color unselectedButtonColor = Theme.of(context).buttonTheme.unselectedButtonColor(context);

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: Consumer<SortByPreferenceModel>(
              builder: (context, sortByPreferenceModel, childWidget) {
                bool isSortByPrice = sortByPreferenceModel.sortByPreference == SortByPreference.PRICE;
                return TextButton(
                    onPressed: () {
                      if (isSortByPrice) {
                        sortByPreferenceModel
                            .setSortByPreference(SortByPreference.NONE);
                      } else {
                        sortByPreferenceModel
                            .setSortByPreference(SortByPreference.PRICE);
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            isSortByPrice ? Colors.white : Theme.of(context).primaryColor),
                    ),
                    child: Text('Price', style: TextStyle(color: isSortByPrice ? Theme.of(context).primaryColor : Colors.white),
                    overflow: TextOverflow.ellipsis,));
              },
            )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Consumer<SortByPreferenceModel>(
                  builder: (context, sortByPreferenceModel, childWidget) {
                    bool isSortByTimeToArrival = sortByPreferenceModel.sortByPreference == SortByPreference.TIME_TO_ARRIVAL;
                    return TextButton(
                        onPressed: () {
                          if(isSortByTimeToArrival) {
                            sortByPreferenceModel.setSortByPreference(SortByPreference.NONE);
                          }
                          else{
                            sortByPreferenceModel.setSortByPreference(SortByPreference.TIME_TO_ARRIVAL);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(isSortByTimeToArrival ? selectedButtonColor : unselectedButtonColor)
                        ),
                        child: Text('Time To Arrival', style: TextStyle(color: isSortByTimeToArrival ? selectedTextColor : unselectedTextColor), overflow: TextOverflow.ellipsis,));
                  },
                )),
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
