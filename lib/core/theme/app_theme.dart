import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {

  static ThemeData lightTheme = ThemeData(

    useMaterial3: true,

    scaffoldBackgroundColor:
    AppColors.background,

    colorScheme: ColorScheme.fromSeed(

      seedColor:
      AppColors.primaryGreen,

      primary:
      AppColors.primaryGreen,
    ),

    appBarTheme: const AppBarTheme(

      backgroundColor:
      AppColors.primaryGreen,

      foregroundColor:
      Colors.white,

      elevation: 0,
    ),

    cardTheme: CardThemeData(

      color:
      AppColors.card,

      elevation: 3,
    ),
  );
}