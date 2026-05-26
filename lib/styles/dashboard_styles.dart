import 'package:flutter/material.dart';

import 'app_styles.dart';

class DashboardStyles {
  static const double sidebarWidth = 78;
  static const double expandedSidebarWidth = 300;
  static const double contentMaxWidth = 1400;

  static const Color green = Color(0xFF379543);
  static const Color yellow = Color(0xFFD7C42E);
  static const Color red = Color(0xFFC43030);
  static const Color lightPanel = Color(0xFFEFEFEF);
  static const Color calendarBorder = Color(0xFFDADCE5);

  static Color progressColor(double percent) {
    if (percent < 40) {
      return red;
    }

    if (percent < 70) {
      return yellow;
    }

    return green;
  }

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

  static BoxDecoration get smallPanelDecoration {
    return BoxDecoration(
      color: lightPanel,
      borderRadius: BorderRadius.circular(9),
    );
  }

  static TextStyle get dashboardTitle {
    return AppText.calSans(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
    );
  }

  static TextStyle get heroName {
    return AppText.calSans(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
      height: 1,
    );
  }

  static TextStyle get heroSubtitle {
    return AppText.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic,
      color: AppColors.blue,
      height: 1.15,
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
      fontSize: 22,
      fontWeight: FontWeight.w700,
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

  static TextStyle get chipText {
    return AppText.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
    );
  }

  static TextStyle get calendarDayText {
    return AppText.dmSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );
  }

  static TextStyle get calendarNumberText {
    return AppText.dmSans(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
  }
}