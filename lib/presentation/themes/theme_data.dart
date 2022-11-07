import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    fontFamily: GoogleFonts.quicksand().fontFamily,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
      ),
    ),
  );
}
