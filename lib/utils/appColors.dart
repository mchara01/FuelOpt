import 'package:flutter/material.dart';

const PrimaryBlue = Color(0xFF002060);
const PrimaryAssentColor = Color(0xFF808080);

extension SelectedButtonTheme on ButtonThemeData {
  Color get selectedButtonColor => Colors.white;
  Color selectedTextColor(context) => Theme.of(context).primaryColor;

  Color unselectedButtonColor(context) => Theme.of(context).primaryColor;
  Color get unselectedTextColor => Colors.white;
}