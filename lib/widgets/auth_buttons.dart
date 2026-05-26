import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

enum AuthButtonType {
  primaryLanding,
  secondaryLanding,
  submit,
  google,
  next,
  back,
  dashboardOutline,
  dashboardFilled,
}

class AuthButton extends StatefulWidget {
  const AuthButton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.type,
    required this.onTap,
    this.leading,
    this.textStyle,
  });

  final String text;
  final double width;
  final double height;
  final AuthButtonType type;
  final VoidCallback onTap;
  final Widget? leading;
  final TextStyle? textStyle;

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  bool _hovered = false;

  bool get _hasLiftHover {
    return widget.type != AuthButtonType.google;
  }

  _ButtonVisual get _normal {
    switch (widget.type) {
      case AuthButtonType.primaryLanding:
        return _ButtonVisual(
          background: AppColors.blue,
          border: Colors.transparent,
          textColor: Colors.white,
          shadows: AppShadows.authButton,
          fontSize: 14.4,
        );

      case AuthButtonType.secondaryLanding:
        return _ButtonVisual(
          background: Colors.transparent,
          border: Colors.white,
          textColor: Colors.white,
          shadows: AppShadows.lightButton,
          fontSize: 14.4,
        );

      case AuthButtonType.submit:
      case AuthButtonType.next:
        return _ButtonVisual(
          background: AppColors.blue,
          border: Colors.transparent,
          textColor: Colors.white,
          shadows: AppShadows.authButton,
          fontSize: 13.6,
        );

      case AuthButtonType.back:
        return _ButtonVisual(
          background: Colors.transparent,
          border: AppColors.blue,
          textColor: AppColors.blue,
          shadows: const [],
          fontSize: 13.6,
        );

      case AuthButtonType.google:
        return _ButtonVisual(
          background: Colors.white,
          border: const Color(0xFFB7B7B7),
          textColor: AppColors.textGray,
          shadows: const [],
          fontSize: 12.8,
        );

      case AuthButtonType.dashboardOutline:
        return _ButtonVisual(
          background: Colors.transparent,
          border: AppColors.blue,
          textColor: AppColors.blue,
          shadows: AppShadows.lightButton,
          fontSize: 13,
        );

      case AuthButtonType.dashboardFilled:
        return _ButtonVisual(
          background: AppColors.blue,
          border: Colors.transparent,
          textColor: Colors.white,
          shadows: AppShadows.authButton,
          fontSize: 13,
        );
    }
  }

  _ButtonVisual get _hover {
    switch (widget.type) {
      case AuthButtonType.primaryLanding:
        return _ButtonVisual(
          background: AppColors.blue.withOpacity(0.30),
          border: AppColors.blue,
          textColor: AppColors.blue,
          shadows: AppShadows.authButton,
          fontSize: 14.4,
        );

      case AuthButtonType.secondaryLanding:
        return _ButtonVisual(
          background: Colors.white.withOpacity(0.30),
          border: Colors.white,
          textColor: Colors.white,
          shadows: AppShadows.lightButton,
          fontSize: 14.4,
        );

      case AuthButtonType.submit:
      case AuthButtonType.next:
      case AuthButtonType.back:
        return _ButtonVisual(
          background: AppColors.blue.withOpacity(0.18),
          border: AppColors.blue,
          textColor: AppColors.blue,
          shadows: AppShadows.lightButton,
          fontSize: 13.6,
        );

      case AuthButtonType.google:
        return _ButtonVisual(
          background: AppColors.blue.withOpacity(0.18),
          border: AppColors.blue,
          textColor: AppColors.blue,
          shadows: const [],
          fontSize: 12.8,
        );

      case AuthButtonType.dashboardOutline:
      case AuthButtonType.dashboardFilled:
        return _ButtonVisual(
          background: AppColors.blue.withOpacity(0.18),
          border: AppColors.blue,
          textColor: AppColors.blue,
          shadows: AppShadows.lightButton,
          fontSize: 13,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _ButtonVisual visual = _hovered ? _hover : _normal;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: widget.width,
          height: widget.height,
          transform: Matrix4.translationValues(
            0,
            _hovered && _hasLiftHover ? -2 : 0,
            0,
          ),
          decoration: BoxDecoration(
            color: visual.background,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: visual.border,
              width: 2,
            ),
            boxShadow: visual.shadows,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: 7),
                ],
                Text(
                  widget.text,
                  style: widget.textStyle?.copyWith(
                        color: visual.textColor,
                      ) ??
                      AppText.calSans(
                        fontSize: visual.fontSize,
                        fontWeight: FontWeight.w600,
                        color: visual.textColor,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonVisual {
  const _ButtonVisual({
    required this.background,
    required this.border,
    required this.textColor,
    required this.shadows,
    required this.fontSize,
  });

  final Color background;
  final Color border;
  final Color textColor;
  final List<BoxShadow> shadows;
  final double fontSize;
}