import 'package:flutter/material.dart';
import 'app_styles.dart';

class LoginStyles {
  static const double cardHeight = 465;
  static const EdgeInsets desktopPadding = EdgeInsets.fromLTRB(30, 36, 30, 24);
  static const EdgeInsets mobilePadding = EdgeInsets.fromLTRB(30, 36, 30, 24);
  static const double cardTopMargin = 24;

  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(7),
    boxShadow: AppShadows.card,
  );

  static TextStyle heading = AppText.calSans(
    fontSize: 27.2,
    color: AppColors.blue,
    fontWeight: FontWeight.w600,
  );

  static TextStyle forgotPassword = AppText.dmSans(
    fontSize: 10.4,
    color: AppColors.placeholderGray,
  );

  static TextStyle dividerText = AppText.dmSans(
    fontSize: 12.48,
    fontWeight: FontWeight.w600,
    color: Color(0xFFB4B4B4),
  );
}
