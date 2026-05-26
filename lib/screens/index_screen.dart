import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import '../styles/index_styles.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_buttons.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth <= 768;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: IndexStyles.topSpacing),
                      Image.asset(
                        AppAssets.logo,
                        width: IndexStyles.logoWidth,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: IndexStyles.logoBottomSpacing),
                      Text(
                        'Mahintana Foundation, Inc.',
                        textAlign: TextAlign.center,
                        style: IndexStyles.title(constraints.maxWidth),
                      ),
                      const SizedBox(height: IndexStyles.titleBottomSpacing),
                      Text(
                        '“Building Resiliency, Sustaining Development”',
                        textAlign: TextAlign.center,
                        style: IndexStyles.subtitle(constraints.maxWidth),
                      ),
                      const SizedBox(height: IndexStyles.subtitleBottomSpacing),
                      Flex(
                        direction: isMobile ? Axis.vertical : Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AuthButton(
                            text: 'Log In',
                            width: 142,
                            height: 45,
                            type: AuthButtonType.primaryLanding,
                            onTap: () => Navigator.pushNamed(context, '/login'),
                          ),
                          SizedBox(
                            width: isMobile ? 0 : IndexStyles.desktopButtonGap,
                            height: isMobile ? IndexStyles.mobileButtonGap : 0,
                          ),
                          AuthButton(
                            text: 'Sign Up',
                            width: 142,
                            height: 45,
                            type: AuthButtonType.secondaryLanding,
                            onTap: () => Navigator.pushNamed(context, '/signup'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
