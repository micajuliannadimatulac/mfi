import 'package:flutter/material.dart';
import 'app_styles.dart';

class SignupStyles {
  static const double cardHeight = 520;
  static const double mobileCardHeight = 515;
  static const EdgeInsets desktopPadding = EdgeInsets.fromLTRB(30, 36, 30, 22);
  static const EdgeInsets tabletPadding = EdgeInsets.fromLTRB(26, 36, 26, 22);
  static const EdgeInsets phonePadding = EdgeInsets.fromLTRB(22, 36, 22, 20);
  static const double cardTopMargin = 22;

  // Flutter inputs/text are slightly taller than HTML/CSS,
  // so these are reduced to avoid signup overflow.
  static const double stepTitleBottomGap = 20;
  static const double switchTopGap = 10;

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

  static TextStyle subheading = AppText.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: AppColors.blue,
  );

  static BoxDecoration inactiveDot = const BoxDecoration(
    color: Color(0xFFD1D1D1),
    shape: BoxShape.circle,
  );

  static BoxDecoration activeDot = const BoxDecoration(
    color: Color(0xFFA9A9A9),
    shape: BoxShape.circle,
  );
}