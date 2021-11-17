import 'package:flutter/material.dart';
import 'package:fuel_opt/model/filter_enums.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:provider/provider.dart';
import '../../utils/appColors.dart';

class FuelTypeOptions extends StatelessWidget {
  final void Function() onTapClose;

  const FuelTypeOptions({Key? key, required this.onTapClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color selectedTextColor =
        Theme.of(context).buttonTheme.selectedTextColor(context);
    final Color selectedButtonColor =
        Theme.of(context).buttonTheme.selectedButtonColor;

    final Color unselectedTextColor =
        Theme.of(context).buttonTheme.unselectedTextColor;
    final Color unselectedButtonColor =
        Theme.of(context).buttonTheme.unselectedButtonColor(context);

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 40.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 10,
            children: [
              Consumer<FuelTypePreferenceModel>(
                builder: (context, fuelTypePreferenceModel, childWidget) {
                  bool isUnleaded =
                      fuelTypePreferenceModel.fuelTypePreference ==
                          FuelTypePreference.UNLEADED;
                  return TextButton(
                      onPressed: () {
                        fuelTypePreferenceModel.setFuelTypePreference(isUnleaded
                            ? FuelTypePreference.NONE
                            : FuelTypePreference.UNLEADED);
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              isUnleaded
                                  ? selectedButtonColor
                                  : unselectedButtonColor)),
                      child: Text(
                        'Unleaded',
                        style: TextStyle(
                            color: isUnleaded
                                ? selectedTextColor
                                : unselectedTextColor),
                      ));
                },
              ),
              Consumer<FuelTypePreferenceModel>(
                  builder: (context, fuelTypePreferenceModel, childWidget) {
                bool isSuperUnleaded =
                    fuelTypePreferenceModel.fuelTypePreference ==
                        FuelTypePreference.SUPER_UNLEADED;
                return TextButton(
                    onPressed: () {
                      fuelTypePreferenceModel.setFuelTypePreference(
                          isSuperUnleaded
                              ? FuelTypePreference.NONE
                              : FuelTypePreference.SUPER_UNLEADED);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            isSuperUnleaded
                                ? selectedButtonColor
                                : unselectedButtonColor)),
                    child: Text(
                      'Super Unleaded',
                      style: TextStyle(
                          color: isSuperUnleaded
                              ? selectedTextColor
                              : unselectedTextColor),
                    ));
              }),
              Consumer<FuelTypePreferenceModel>(
                builder: (context, fuelTypePreferenceModel, childWidget) {
                  bool isDiesel = fuelTypePreferenceModel.fuelTypePreference ==
                      FuelTypePreference.DIESEL;
                  return TextButton(
                      onPressed: () {
                        fuelTypePreferenceModel.setFuelTypePreference(isDiesel
                            ? FuelTypePreference.NONE
                            : FuelTypePreference.DIESEL);
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              isDiesel
                                  ? selectedButtonColor
                                  : unselectedButtonColor)),
                      child: Text(
                        'Diesel',
                        style: TextStyle(
                            color: isDiesel
                                ? selectedTextColor
                                : unselectedTextColor),
                      ));
                },
              ),
              Consumer<FuelTypePreferenceModel>(
                builder: (context, fuelTypePreferenceModel, childWidget) {
                  bool isPremiumDiesel =
                      fuelTypePreferenceModel.fuelTypePreference ==
                          FuelTypePreference.PREMIUM_DIESEL;
                  return TextButton(
                      onPressed: () {
                        fuelTypePreferenceModel.setFuelTypePreference(
                            isPremiumDiesel
                                ? FuelTypePreference.NONE
                                : FuelTypePreference.PREMIUM_DIESEL);
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              isPremiumDiesel
                                  ? selectedButtonColor
                                  : unselectedButtonColor)),
                      child: Text(
                        'Super Diesel',
                        style: TextStyle(
                            color: isPremiumDiesel
                                ? selectedTextColor
                                : unselectedTextColor),
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
