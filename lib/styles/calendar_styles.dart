import 'package:flutter/material.dart';

import 'app_styles.dart';

class CalendarStyles {
  static const double sidebarWidth = 78;
  static const double expandedSidebarWidth = 300;
  static const double contentMaxWidth = 1260;

  static const Color selectedSidebar = Color(0xFFD9D9D9);
  static const Color cardBorder = Color(0xFFE2E4EF);
  static const Color projectColor = AppColors.blue;
  static const Color activityColor = AppColors.lightBlue;

  static const BoxDecoration pageBackground = BoxDecoration(
    gradient: AppGradients.authBackground,
  );

  static BoxDecoration get sidebarDecoration {
    return BoxDecoration(
      color: Colors.white,
      border: const Border(
        right: BorderSide(
          color: AppColors.blue,
          width: 4,
        ),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 12,
          offset: const Offset(3, 0),
        ),
      ],
    );
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

  static BoxDecoration get controlDecoration {
    return BoxDecoration(
      color: AppColors.softGray,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: AppColors.borderGray,
        width: 1,
      ),
    );
  }

  static TextStyle get pageTitle {
    return AppText.calSans(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
    );
  }

  static TextStyle get sectionTitle {
    return AppText.calSans(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
    );
  }

  static TextStyle get sidebarLabel {
    return AppText.calSans(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
    );
  }

  static TextStyle get orgName {
    return AppText.calSans(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
    );
  }

  static TextStyle get orgTagline {
    return AppText.dmSans(
      fontSize: 7,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic,
      color: AppColors.blue,
    );
  }

  static TextStyle get dropdownText {
    return AppText.dmSans(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColors.blue,
    );
  }

  static TextStyle get dayHeader {
    return AppText.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w800,
      color: AppColors.blue,
    );
  }

  static TextStyle get dayNumber {
    return AppText.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w800,
      color: AppColors.blue,
    );
  }

  static TextStyle get mutedDayNumber {
    return AppText.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: AppColors.placeholderGray,
    );
  }

  static TextStyle get eventText {
    return AppText.dmSans(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      height: 1.1,
    );
  }

  static TextStyle get filterTitle {
    return AppText.dmSans(
      fontSize: 13,
      fontWeight: FontWeight.w800,
      color: AppColors.blue,
    );
  }

  static TextStyle get filterText {
    return AppText.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.textGray,
    );
  }
}
