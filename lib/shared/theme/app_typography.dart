import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fieldnote/shared/theme/app_colors.dart';

class AppTypography {
  static TextTheme get textTheme => GoogleFonts.nunitoSansTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: AppColors.primaryBlue,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: AppColors.textGray,
          ),
        ),
      );
}
