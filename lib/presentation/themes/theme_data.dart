
import 'package:flutter/material.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
      ),
    ),
  );
}