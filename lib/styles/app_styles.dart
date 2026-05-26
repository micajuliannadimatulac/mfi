import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color blue = Color(0xFF2F3192);
  static const Color lightBlue = Color(0xFF74B2F2);

  static const Color textGray = Color(0xFF8C8C8C);
  static const Color softGray = Color(0xFFEEEEEE);
  static const Color borderGray = Color(0xFFCFCFCF);
  static const Color dividerGray = Color(0xFFD4D4D4);
  static const Color placeholderGray = Color(0xFFB5B5B5);
}

class AppAssets {
  static const String logo = 'assets/images/logo.png';
  static const String googleLogo = 'assets/images/logo-google.png';
  static const String matutum = 'assets/images/matutum.png';
}

class AppGradients {
  static const LinearGradient authBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF74B2F2),
      Color(0xFF91C1EE),
      Color(0xFFBBDBEE),
      Color(0xFFC4E0EE),
    ],
    stops: [0.0, 0.307692, 0.572115, 1.0],
  );
}

class AppShadows {
  static final List<BoxShadow> authButton = [
    BoxShadow(
      color: AppColors.blue.withOpacity(0.35),
      offset: const Offset(0, 4),
      blurRadius: 8,
    ),
  ];

  static final List<BoxShadow> lightButton = [
    BoxShadow(
      color: AppColors.blue.withOpacity(0.18),
      offset: const Offset(0, 4),
      blurRadius: 8,
    ),
  ];

  static final List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black.withOpacity(0.18),
      offset: const Offset(0, 3),
      blurRadius: 8,
    ),
  ];
}

class AppText {
  static TextStyle dmSans({
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.dmSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // This keeps the same function name used by your screens,
  // but displays Poppins instead of Cal Sans.
  static TextStyle calSans({
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}

double clampDouble(double value, double min, double max) {
  if (value < min) return min;
  if (value > max) return max;
  return value;
}

double authCardWidth(double screenWidth) {
  if (screenWidth <= 768) {
    final double width = screenWidth - 40;
    return width > 380 ? 380 : width;
  }

  return 380;
}