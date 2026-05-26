import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import '../styles/signup_styles.dart';
import '../widgets/app_header.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/form_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentStep = 1;
  bool _showPassword = false;
  String? _program;
  String? _position;

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = authCardWidth(constraints.maxWidth);
            final bool isPhone = constraints.maxWidth <= 480;
            final bool isTablet = constraints.maxWidth <= 768;
            final double cardHeight = isTablet ? SignupStyles.mobileCardHeight : SignupStyles.cardHeight;

            EdgeInsets padding = SignupStyles.desktopPadding;
            if (isPhone) {
              padding = SignupStyles.phonePadding;
            } else if (isTablet) {
              padding = SignupStyles.tabletPadding;
            }

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const AppHeader(),
                      const SizedBox(height: SignupStyles.cardTopMargin),
                      Container(
                        width: width,
                        height: cardHeight,
                        decoration: SignupStyles.cardDecoration,
                        child: Stack(
                          children: [
                            const Positioned(
                              top: 14,
                              left: 16,
                              child: BackHomeLink(),
                            ),
                            Padding(
                              padding: padding,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Sign Up',
                                    textAlign: TextAlign.center,
                                    style: SignupStyles.heading,
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(child: _buildCurrentStep(isPhone)),
                                  const SizedBox(height: SignupStyles.switchTopGap),
                                    const AuthSwitchLink(
                                      prefix: 'Already have an account?',
                                      linkText: 'Log In',
                                      routeName: '/login',
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
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

  Widget _buildCurrentStep(bool isPhone) {
    switch (_currentStep) {
      case 1:
        return _PersonalDetailsStep(
          isPhone: isPhone,
          currentStep: _currentStep,
          onNext: _nextStep,
        );
      case 2:
        return _OfficeDetailsStep(
          isPhone: isPhone,
          currentStep: _currentStep,
          program: _program,
          position: _position,
          onProgramChanged: (value) => setState(() => _program = value),
          onPositionChanged: (value) => setState(() => _position = value),
          onNext: _nextStep,
          onBack: _previousStep,
        );
      case 3:
      default:
        return _AccountDetailsStep(
          isPhone: isPhone,
          currentStep: _currentStep,
          showPassword: _showPassword,
          onTogglePassword: () => setState(() => _showPassword = !_showPassword),
          onBack: _previousStep,
        );
    }
  }
}

class _PersonalDetailsStep extends StatelessWidget {
  const _PersonalDetailsStep({
    required this.isPhone,
    required this.currentStep,
    required this.onNext,
  });

  final bool isPhone;
  final int currentStep;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = isPhone ? 82 : 96;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepTitle('PERSONAL DETAILS'),

        const SizedBox(height: 18),

        const AuthTextField(label: 'First Name*'),
        const AuthTextField(label: 'Middle Name'),
        const AuthTextField(label: 'Last Name*'),
        const AuthTextField(
          label: 'Contact Number*',
          keyboardType: TextInputType.phone,
        ),

        const Spacer(),

        Row(
          children: [
            SizedBox(width: buttonWidth),

            Expanded(
              child: Center(
                child: StepDots(currentStep: currentStep),
              ),
            ),

            AuthButton(
              text: 'Next',
              width: buttonWidth,
              height: 38,
              type: AuthButtonType.next,
              onTap: onNext,
            ),
          ],
        ),
      ],
    );
  }
}

class _OfficeDetailsStep extends StatelessWidget {
  const _OfficeDetailsStep({
    required this.isPhone,
    required this.currentStep,
    required this.program,
    required this.position,
    required this.onProgramChanged,
    required this.onPositionChanged,
    required this.onNext,
    required this.onBack,
  });

  final bool isPhone;
  final int currentStep;
  final String? program;
  final String? position;
  final ValueChanged<String?> onProgramChanged;
  final ValueChanged<String?> onPositionChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = isPhone ? 82 : 96;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepTitle('OFFICE DETAILS'),
        const SizedBox(height: SignupStyles.stepTitleBottomGap),
        AuthDropdownField(
          label: 'Program*',
          value: program,
          items: const ['Program 1', 'Program 2', 'Program 3'],
          onChanged: onProgramChanged,
        ),
        AuthDropdownField(
          label: 'Position*',
          value: position,
          items: const ['Staff', 'Coordinator', 'Manager'],
          onChanged: onPositionChanged,
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AuthButton(
              text: 'Back',
              width: buttonWidth,
              height: 38,
              type: AuthButtonType.back,
              onTap: onBack,
            ),
            StepDots(currentStep: currentStep),
            AuthButton(
              text: 'Next',
              width: buttonWidth,
              height: 38,
              type: AuthButtonType.next,
              onTap: onNext,
            ),
          ],
        ),
      ],
    );
  }
}

class _AccountDetailsStep extends StatelessWidget {
  const _AccountDetailsStep({
    required this.isPhone,
    required this.currentStep,
    required this.showPassword,
    required this.onTogglePassword,
    required this.onBack,
  });

  final bool isPhone;
  final int currentStep;
  final bool showPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = isPhone ? 82 : 96;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepTitle('ACCOUNT DETAILS'),
        const SizedBox(height: SignupStyles.stepTitleBottomGap),
        const AuthTextField(label: 'Email*', keyboardType: TextInputType.emailAddress),
        const AuthTextField(label: 'Username*'),
        AuthTextField(
          label: 'Password*',
          obscureText: !showPassword,
          suffix: PasswordToggle(
            visible: showPassword,
            onPressed: onTogglePassword,
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AuthButton(
              text: 'Back',
              width: buttonWidth,
              height: 38,
              type: AuthButtonType.back,
              onTap: onBack,
            ),
            StepDots(currentStep: currentStep),
            AuthButton(
              text: 'Submit',
              width: buttonWidth,
              height: 38,
              type: AuthButtonType.next,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _StepTitle extends StatelessWidget {
  const _StepTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: SignupStyles.subheading,
    );
  }
}

class StepDots extends StatelessWidget {
  const StepDots({super.key, required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final bool active = index == currentStep - 1;
        return Container(
          width: 6,
          height: 6,
          margin: EdgeInsets.only(right: index == 2 ? 0 : 7),
          decoration: active ? SignupStyles.activeDot : SignupStyles.inactiveDot,
        );
      }),
    );
  }
}
