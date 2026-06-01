import 'package:flutter/material.dart';

import 'app_styles.dart';

class SettingsAdminEditStyles {
  static const double sidebarWidth = 78;
  static const double expandedSidebarWidth = 300;
  static const double contentMaxWidth = 1200;

  static const double cardMaxWidth = 860;
  static const double headerGap = 42;
  static const double desktopColumnGap = 54;
  static const double avatarSize = 128;

  static const Color selectedSidebar = Color(0xFFD9D9D9);
  static const Color activeGreen = Color(0xFF379543);
  static const Color blockedRed = Color(0xFFC43030);

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
      boxShadow: AppShadows.card,
    );
  }

  static BoxDecoration avatarRingDecoration({required bool isBlocked}) {
    return BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(
        color: isBlocked ? blockedRed : activeGreen,
        width: 4,
      ),
    );
  }

  static InputDecoration fieldDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.softGray.withOpacity(0.95),
      suffixIcon: const Icon(
        Icons.edit_outlined,
        color: AppColors.blue,
        size: 21,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: AppColors.blue,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: AppColors.blue,
          width: 1.5,
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

  static TextStyle get userName {
    return AppText.calSans(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
      height: 1.05,
    );
  }

  static TextStyle get fieldLabel {
    return AppText.dmSans(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColors.blue,
    );
  }

  static TextStyle get fieldText {
    return AppText.dmSans(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF3A3A3A),
    );
  }

  static TextStyle get buttonText {
    return AppText.dmSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
  }
}