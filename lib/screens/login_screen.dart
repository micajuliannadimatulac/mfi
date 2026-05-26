import 'package:flutter/material.dart';

import '../styles/app_styles.dart';
import '../styles/login_styles.dart';
import '../widgets/app_header.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/form_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showPassword = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username == 'admin' && password == 'admin123') {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard-admin',
        (route) => false,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Invalid username or password.',
          style: AppText.dmSans(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = authCardWidth(constraints.maxWidth);

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const AppHeader(),
                      const SizedBox(height: LoginStyles.cardTopMargin),
                      Container(
                        width: width,
                        height: LoginStyles.cardHeight,
                        decoration: LoginStyles.cardDecoration,
                        child: Stack(
                          children: [
                            const Positioned(
                              top: 14,
                              left: 16,
                              child: BackHomeLink(),
                            ),
                            Padding(
                              padding: constraints.maxWidth <= 768
                                  ? LoginStyles.mobilePadding
                                  : LoginStyles.desktopPadding,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Log In',
                                    textAlign: TextAlign.center,
                                    style: LoginStyles.heading,
                                  ),
                                  const SizedBox(height: 24),

                                  _LoginTextField(
                                    label: 'Email/Username*',
                                    controller: _usernameController,
                                    textInputAction: TextInputAction.next,
                                  ),

                                  _LoginTextField(
                                    label: 'Password*',
                                    controller: _passwordController,
                                    obscureText: !_showPassword,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) => _login(),
                                    suffix: PasswordToggle(
                                      visible: _showPassword,
                                      onPressed: () {
                                        setState(() {
                                          _showPassword = !_showPassword;
                                        });
                                      },
                                    ),
                                  ),

                                  Transform.translate(
                                    offset: const Offset(0, -10),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: _ForgotPasswordLink(),
                                    ),
                                  ),

                                  const SizedBox(height: 7),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          color: AppColors.dividerGray,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Text(
                                          'OR',
                                          style: LoginStyles.dividerText,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          color: AppColors.dividerGray,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 18),

                                  AuthButton(
                                    text: 'Log In with Google',
                                    width: double.infinity,
                                    height: 38,
                                    type: AuthButtonType.google,
                                    leading: Image.asset(
                                      AppAssets.googleLogo,
                                      width: 17,
                                      height: 17,
                                    ),
                                    onTap: () {},
                                  ),

                                  const SizedBox(height: 18),

                                  AuthButton(
                                    text: 'Log In',
                                    width: double.infinity,
                                    height: 39,
                                    type: AuthButtonType.submit,
                                    onTap: _login,
                                  ),

                                  const SizedBox(height: 18),

                                  const AuthSwitchLink(
                                    prefix: 'Don’t have an account?',
                                    linkText: 'Sign Up',
                                    routeName: '/signup',
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
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.suffix,
    this.textInputAction,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffix;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppText.dmSans(
              fontSize: 14.4,
              fontWeight: FontWeight.w500,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 36,
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              textInputAction: textInputAction,
              onSubmitted: onSubmitted,
              style: AppText.dmSans(
                fontSize: 13.6,
                color: AppColors.blue,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.softGray,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                suffixIcon: suffix,
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 42,
                  minHeight: 36,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.borderGray,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.blue,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForgotPasswordLink extends StatefulWidget {
  @override
  State<_ForgotPasswordLink> createState() => _ForgotPasswordLinkState();
}

class _ForgotPasswordLinkState extends State<_ForgotPasswordLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
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
        onTap: () {},
        child: Text(
          'Forgot Password?',
          style: LoginStyles.forgotPassword.copyWith(
            color: _hovered ? AppColors.blue : AppColors.placeholderGray,
            decoration: _hovered
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}