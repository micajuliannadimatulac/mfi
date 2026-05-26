import 'package:flutter/material.dart';
import 'app_styles.dart';

class IndexStyles {
  static const double topSpacing = 55;
  static const double logoWidth = 92;
  static const double logoBottomSpacing = 16;
  static const double titleBottomSpacing = 14;
  static const double subtitleBottomSpacing = 42;
  static const double desktopButtonGap = 36;
  static const double mobileButtonGap = 14;

  static TextStyle title(double screenWidth) {
    return AppText.calSans(
      fontSize: clampDouble(screenWidth * 0.044, 36.8, 68),
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
      height: 1,
    );
  }

  static TextStyle subtitle(double screenWidth) {
    return AppText.dmSans(
      fontSize: clampDouble(screenWidth * 0.0155, 15.2, 23.2),
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      color: AppColors.blue,
    );
  }
}
