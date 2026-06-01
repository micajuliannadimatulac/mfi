import 'package:flutter/material.dart';

import 'app_styles.dart';

class ActivitiesStyles {
  static const double contentMaxWidth = 1120;
  static const double sidebarWidth = 92;
  static const double expandedSidebarWidth = 290;
  static const Color cardBorder = Color(0xFFE2E4EF);
  static const Color green = Color(0xFF379543);
  static const Color yellow = Color(0xFFD7A92E);
  static const Color red = Color(0xFFC43030);

  static const BoxDecoration pageBackground = BoxDecoration(
    gradient: AppGradients.authBackground,
  );


  static BoxDecoration get sidebarDecoration {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.96),
      border: const Border(
        right: BorderSide(
          color: Color(0xFFE4E4E4),
          width: 1,
        ),
      ),
      boxShadow: AppShadows.lightButton,
    );
  }

  static Color get selectedSidebar {
    return const Color(0xFFD9D9D9);
  }

  static BoxDecoration get cardDecoration {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.96),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: cardBorder,
        width: 1,
      ),
      boxShadow: AppShadows.card,
    );
  }

  static BoxDecoration get softPanelDecoration {
    return BoxDecoration(
      color: AppColors.softGray,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: AppColors.borderGray,
        width: 1,
      ),
    );
  }

  static InputDecoration fieldDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppText.dmSans(
        fontSize: 13,
        color: AppColors.placeholderGray,
      ),
      filled: true,
      fillColor: AppColors.softGray,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.borderGray,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.blue,
          width: 1,
        ),
      ),
    );
  }

  static Color progressColor(double percent) {
    if (percent < 40) {
      return red;
    }

    if (percent < 70) {
      return yellow;
    }

    return green;
  }

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return green;
      case 'not started':
        return red;
      case 'in progress':
      default:
        return AppColors.blue;
    }
  }

  static TextStyle get backText {
    return AppText.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
    );
  }

  static TextStyle get pageTitle {
    return AppText.calSans(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
      height: 1.05,
    );
  }

  static TextStyle get sectionTitle {
    return AppText.calSans(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
    );
  }

  static TextStyle get cardTitle {
    return AppText.calSans(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
      height: 1.1,
    );
  }

  static TextStyle get description {
    return AppText.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textGray,
      height: 1.35,
    );
  }

  static TextStyle get meta {
    return AppText.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.textGray,
      height: 1.25,
    );
  }

  static TextStyle get label {
    return AppText.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
    );
  }

  static TextStyle get value {
    return AppText.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textGray,
    );
  }

  static TextStyle get percentText {
    return AppText.dmSans(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: AppColors.blue,
    );
  }

  static TextStyle get buttonText {
    return AppText.dmSans(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
  }

  static TextStyle get orgName {
    return AppText.calSans(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
      height: 1.05,
    );
  }

  static TextStyle get orgTagline {
    return AppText.dmSans(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: AppColors.blue,
      height: 1.2,
    );
  }

  static TextStyle get sidebarLabel {
    return AppText.calSans(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
    );
  }

}
