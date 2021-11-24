import 'package:flutter/material.dart';
import 'package:fuel_opt/model/filter_enums.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';

class FuelTypeOptions extends StatelessWidget {
  final void Function() onTapClose;

  const FuelTypeOptions({Key? key, required this.onTapClose}) : super(key: key);

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
                                  : unselectedButtonColor),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      child: Text('Unleaded',
                          style: TextStyle(
                              color: isUnleaded
                                  ? selectedTextColor
                                  : unselectedTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)));
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
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      'Super Unleaded',
                      style: TextStyle(
                          color: isSuperUnleaded
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
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
                                  : unselectedButtonColor),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      child: Text(
                        'Diesel',
                        style: TextStyle(
                            color: isDiesel
                                ? selectedTextColor
                                : unselectedTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
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
                                  : unselectedButtonColor),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      child: Text(
                        'Super Diesel',
                        style: TextStyle(
                            color: isPremiumDiesel
                                ? selectedTextColor
                                : unselectedTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
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
      )
    ]);
  }
}
