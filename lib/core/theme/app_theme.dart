import 'package:flutter/material.dart';
import 'package:movie_app/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
    ),

    colorScheme: const ColorScheme.dark(
      background: AppColors.background,
      surface: AppColors.surface,
      primary: AppColors.primary,
    ),
  );
}
