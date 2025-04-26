import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4D37F3);
  static const Color secondary = Color(0xFFE91E63);
  static const Color background = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF2F2F2F);
  static const Color textLight = Color(0xFF757575);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14,
    color: AppColors.textLight,
  );
}
