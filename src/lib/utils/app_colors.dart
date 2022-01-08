import 'package:flutter/material.dart';

const PrimaryBlue = Color(0xFF002060);
const PrimaryAssentColor = Color(0xFF808080);

extension SelectedButtonTheme on ButtonThemeData {
  Color selectedButtonColor(context) => Theme.of(context).primaryColor;
  Color get selectedTextColor => Colors.white;

  Color get unselectedButtonColor => Colors.white;
  Color unselectedTextColor(context) => Theme.of(context).primaryColor;
}