import 'package:flutter/material.dart';

import 'app_styles.dart';

class SettingsStyles {
  static const double sidebarWidth = 78;
  static const double expandedSidebarWidth = 300;
  static const double contentMaxWidth = 1200;

  static const Color lightPanel = Color(0xFFEFEFEF);
  static const Color selectedSidebar = Color(0xFFD9D9D9);
  static const Color cardBorder = Color(0xFFE2E4EF);

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

  static BoxDecoration get accountCardDecoration {
    return BoxDecoration(
      color: Colors.white,
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

  static TextStyle get cardTitle {
    return AppText.calSans(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
      height: 1.05,
    );
  }

  static TextStyle get cardMeta {
    return AppText.dmSans(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.textGray,
      height: 1.15,
    );
  }

  static TextStyle get dropdownText {
    return AppText.dmSans(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColors.blue,
    );
  }

  static TextStyle get buttonText {
    return AppText.dmSans(
      fontSize: 11,
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
