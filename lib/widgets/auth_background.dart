import 'package:flutter/material.dart';
import '../styles/app_styles.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.authBackground,
            ),
          ),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool narrow = constraints.maxWidth <= 900;

                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    AppAssets.matutum,
                    width: constraints.maxWidth,
                    height: narrow ? constraints.maxHeight * 0.48 : null,
                    fit: narrow ? BoxFit.cover : BoxFit.fitWidth,
                    alignment: Alignment.bottomCenter,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}
