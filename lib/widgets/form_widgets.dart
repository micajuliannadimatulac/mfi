import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../styles/app_styles.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
  });

  final String label;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;

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
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: AppText.dmSans(
                fontSize: 13.6,
                color: AppColors.blue,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.softGray,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                suffixIcon: suffix,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderGray, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.blue, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthDropdownField extends StatelessWidget {
  const AuthDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

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
            child: DropdownButtonFormField<String>(
              value: value,
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: AppText.dmSans(
                          fontSize: 13.6,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.blue, size: 18),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.softGray,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderGray, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.blue, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordToggle extends StatelessWidget {
  const PasswordToggle({
    super.key,
    required this.visible,
    required this.onPressed,
  });

  final bool visible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      splashRadius: 18,
      icon: FaIcon(
        visible ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
        size: 16,
        color: const Color(0xFFB8B8B8),
      ),
    );
  }
}

class BackHomeLink extends StatefulWidget {
  const BackHomeLink({super.key});

  @override
  State<BackHomeLink> createState() => _BackHomeLinkState();
}

class _BackHomeLinkState extends State<BackHomeLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: _hovered ? 0.75 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            transform: Matrix4.translationValues(_hovered ? -2 : 0, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(
                  FontAwesomeIcons.chevronLeft,
                  size: 11,
                  color: AppColors.blue,
                ),
                const SizedBox(width: 6),
                const FaIcon(
                  FontAwesomeIcons.house,
                  size: 11,
                  color: AppColors.blue,
                ),
                const SizedBox(width: 6),
                Text(
                  'Back to Home',
                  style: AppText.dmSans(
                    fontSize: 10.88,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue,
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

class AuthSwitchLink extends StatefulWidget {
  const AuthSwitchLink({
    super.key,
    required this.prefix,
    required this.linkText,
    required this.routeName,
  });

  final String prefix;
  final String linkText;
  final String routeName;

  @override
  State<AuthSwitchLink> createState() => _AuthSwitchLinkState();
}

class _AuthSwitchLinkState extends State<AuthSwitchLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: '${widget.prefix} ',
        style: AppText.calSans(fontSize: 10.88, color: AppColors.blue),
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _hovered = true),
              onExit: (_) => setState(() => _hovered = false),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, widget.routeName),
                child: Text(
                  widget.linkText,
                  style: AppText.calSans(
                    fontSize: 10.88,
                    color: _hovered ? const Color(0xFF1F217A) : AppColors.blue,
                  ).copyWith(
                    decoration: TextDecoration.underline,
                    decorationThickness: _hovered ? 2 : 1,
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
