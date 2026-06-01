import 'package:flutter/material.dart';

import 'app_styles.dart';

class ProjectsStyles {
  static const double sidebarWidth = 78;
  static const double expandedSidebarWidth = 300;
  static const double contentMaxWidth = 1200;

  static const Color selectedSidebar = Color(0xFFD9D9D9);
  static const Color completedGreen = Color(0xFF379543);
  static const Color progressYellow = Color(0xFFD7C42E);
  static const Color progressRed = Color(0xFFC43030);
  static const Color notStartedGray = Color(0xFF8A8A8A);
  static const Color lightPanel = Color(0xFFEFEFEF);

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
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
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

  static InputDecoration searchInputDecoration({
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppText.dmSans(
        fontSize: 13,
        color: AppColors.placeholderGray,
      ),
      suffixIcon: const Icon(
        Icons.search_rounded,
        color: AppColors.blue,
        size: 22,
      ),
      filled: true,
      fillColor: AppColors.softGray,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
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

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return completedGreen;
      case 'not started':
        return notStartedGray;
      case 'in progress':
      default:
        return AppColors.blue;
    }
  }

  static Color progressColor(double percent) {
    if (percent < 40) {
      return progressRed;
    }

    if (percent < 70) {
      return progressYellow;
    }

    return completedGreen;
  }

  static TextStyle get pageTitle {
    return AppText.calSans(
      fontSize: 24,
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

  static TextStyle get cardTitle {
    return AppText.calSans(
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
      height: 1.05,
    );
  }

  static TextStyle get cardMeta {
    return AppText.dmSans(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: AppColors.textGray,
      height: 1.2,
    );
  }

  static TextStyle get cardDescription {
    return AppText.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textGray,
      height: 1.25,
    );
  }

  static TextStyle get viewActivitiesText {
    return AppText.dmSans(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
  }

  static TextStyle get buttonText {
    return AppText.dmSans(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
  }

  static TextStyle get emptyText {
    return AppText.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.placeholderGray,
    );
  }
}
