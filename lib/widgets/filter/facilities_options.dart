import 'package:flutter/material.dart';
import 'package:fuel_opt/model/filter_enums.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';

class FacilitiesOptions extends StatelessWidget {
  final void Function() onTapClose;

  const FacilitiesOptions({Key? key, required this.onTapClose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> facilities = [
      "car_wash",
      "air_and_water",
      "car_vacuum",
      "number_24_7_opening_hours",
      "toilet",
      "convenience_store",
      "atm",
      "parking_facilities",
      "disabled_toilet_baby_change",
      "alcohol",
      "wi_fi",
      "hgv_psv_fueling",
      "fuelservice",
      "payphone",
      "restaurant",
      "electric_car_charging",
      "repair_garage",
      "shower_facilities",
    ];

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
              // Consumer<FacilitiesPreferenceModel>(
              //     builder: (context, facilitiesPreferenceModel, childWidget) {
              //   for (var facility in facilities) {
              //     print(facility);
              //     return TextButton(
              //         onPressed: () {
              //           if (facilitiesPreferenceModel.facilitiesPreference
              //               .contains(facility)) {
              //             facilitiesPreferenceModel
              //                 .addFacilitiesPreference(facility);
              //           } else {
              //             facilitiesPreferenceModel
              //                 .removeFacilitiesPreference(facility);
              //           }
              //         },
              //         style: ButtonStyle(
              //             backgroundColor: MaterialStateProperty.all<Color>(
              //                 facilitiesPreferenceModel.facilitiesPreference
              //                         .contains(facility)
              //                     ? selectedButtonColor
              //                     : unselectedButtonColor),
              //             shape: MaterialStateProperty.all<OutlinedBorder>(
              //                 RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(10)))),
              //         child: Text(
              //           facility,
              //           style: TextStyle(
              //               color: facilitiesPreferenceModel
              //                       .facilitiesPreference
              //                       .contains(facility)
              //                   ? selectedTextColor
              //                   : unselectedTextColor,
              //               fontSize: 16,
              //               fontWeight: FontWeight.bold),
              //         ));
              //   }
              //   ;
              //   return Text('data');
              // }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("car_wash")) {
                        facilitiesPreferenceModel
                            .removeFacilitiesPreference("car_wash");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("car_wash");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("car_wash")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Car Wash",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("car_wash")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("air_and_water")) {
                        facilitiesPreferenceModel
                            .removeFacilitiesPreference("air_and_water");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("air_and_water");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("air_and_water")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Air&Water",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("air_and_water")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("car_vacuum")) {
                        facilitiesPreferenceModel
                            .removeFacilitiesPreference("car_vacuum");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("car_vacuum");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("car_vacuum")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Car Vacuum",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("car_vacuum")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("number_24_7_opening_hours")) {
                        facilitiesPreferenceModel.removeFacilitiesPreference(
                            "number_24_7_opening_hours");
                      } else {
                        facilitiesPreferenceModel.addFacilitiesPreference(
                            "number_24_7_opening_hours");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("number_24_7_opening_hours")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "24/7",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("number_24_7_opening_hours")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("toilet")) {
                        facilitiesPreferenceModel
                            .removeFacilitiesPreference("toilet");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("toilet");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("toilet")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Toilet",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("toilet")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("convenience_store")) {
                        facilitiesPreferenceModel
                            .removeFacilitiesPreference("convenience_store");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("convenience_store");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("convenience_store")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Convenience Store",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("convenience_store")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("atm")) {
                        facilitiesPreferenceModel
                            .removeFacilitiesPreference("atm");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("atm");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("atm")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "ATM",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("atm")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("parking_facilities")) {
                        facilitiesPreferenceModel
                            .removeFacilitiesPreference("parking_facilities");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("parking_facilities");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("parking_facilities")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Parking",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("parking_facilities")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("disabled_toilet_baby_change")) {
                        facilitiesPreferenceModel.removeFacilitiesPreference(
                            "disabled_toilet_baby_change");
                      } else {
                        facilitiesPreferenceModel.addFacilitiesPreference(
                            "disabled_toilet_baby_change");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("disabled_toilet_baby_change")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Disabled Toilet/Baby Change",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("disabled_toilet_baby_change")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("alcohol")) {
                        facilitiesPreferenceModel
                            .removeFacilitiesPreference("alcohol");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("alcohol");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("alcohol")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Alcohol",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("alcohol")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("wi_fi")) {
                        facilitiesPreferenceModel
                            .removeFacilitiesPreference("wi_fi");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("wi_fi");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("wi_fi")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "WIFI",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("wi_fi")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("hgv_psv_fueling")) {
                        facilitiesPreferenceModel
                            .removeFacilitiesPreference("hgv_psv_fueling");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("hgv_psv_fueling");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("hgv_psv_fueling")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "HGV PSV",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("hgv_psv_fueling")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("fuelservice")) {
                        facilitiesPreferenceModel
                            .removeFacilitiesPreference("fuelservice");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("fuelservice");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("fuelservice")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Fuel Service",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("fuelservice")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("payphone")) {
                        facilitiesPreferenceModel
                            .removeFacilitiesPreference("payphone");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("payphone");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("payphone")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Mobile Pay",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("payphone")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("restaurant")) {
                        facilitiesPreferenceModel
                            .removeFacilitiesPreference("restaurant");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("restaurant");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("restaurant")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Restaurant",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("restaurant")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("electric_car_charging")) {
                        facilitiesPreferenceModel.removeFacilitiesPreference(
                            "electric_car_charging");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("electric_car_charging");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("electric_car_charging")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Electric Car Charging",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("electric_car_charging")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("repair_garage")) {
                        facilitiesPreferenceModel
                            .removeFacilitiesPreference("repair_garage");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("repair_garage");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("repair_garage")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Repair Garage",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("repair_garage")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
              Consumer<FacilitiesPreferenceModel>(
                  builder: (context, facilitiesPreferenceModel, childWidget) {
                return TextButton(
                    onPressed: () {
                      if (facilitiesPreferenceModel.facilitiesPreference
                          .contains("shower_facilities")) {
                        facilitiesPreferenceModel
                            .removeFacilitiesPreference("shower_facilities");
                      } else {
                        facilitiesPreferenceModel
                            .addFacilitiesPreference("shower_facilities");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            facilitiesPreferenceModel.facilitiesPreference
                                    .contains("shower_facilities")
                                ? selectedButtonColor
                                : unselectedButtonColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Shower",
                      style: TextStyle(
                          color: facilitiesPreferenceModel.facilitiesPreference
                                  .contains("shower_facilities")
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ));
              }),
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
