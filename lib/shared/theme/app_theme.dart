import 'package:flutter/material.dart';
import 'package:fieldnote/shared/theme/app_colors.dart';
import 'package:fieldnote/shared/theme/app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.bgOffWhite,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accentBlue,
        secondary: AppColors.calmGreen,
        error: AppColors.destructiveRed,
        surface: AppColors.surfaceWhite,
      ),
      textTheme: AppTypography.textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgOffWhite,
        elevation: 0,
        titleTextStyle: AppTypography.textTheme.displayLarge,
        iconTheme: const IconThemeData(color: AppColors.primaryBlue),
      ),
    );
  }
}
