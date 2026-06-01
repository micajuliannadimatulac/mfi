import 'dart:html' as html;

import 'package:flutter/material.dart';
import '../state/blocked_users_state.dart';
import '../state/sidebar_state.dart';
import '../styles/app_styles.dart';
import '../styles/settings_admin_edit_styles.dart';
import '../widgets/auth_buttons.dart';


Future<void> _showLogoutConfirmation(BuildContext context) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.35),
    builder: (context) {
      return const _LogoutConfirmationDialog();
    },
  );

  if (confirmed != true || !context.mounted) {
    return;
  }

  Navigator.pushNamedAndRemoveUntil(
    context,
    '/',
    (route) => false,
  );
}



class _LogoutConfirmationDialog extends StatelessWidget {
  const _LogoutConfirmationDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 26, 28, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Log Out',
                style: AppText.calSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to log out?',
                style: AppText.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      'Cancel',
                      style: AppText.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.placeholderGray,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 112,
                    height: 38,
                    child: AuthButton(
                      text: 'Log Out',
                      width: 112,
                      height: 38,
                      type: AuthButtonType.dashboardFilled,
                      onTap: () => Navigator.pop(context, true),
                      textStyle: AppText.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const String _micaPortfolioUrl = 'https://micajuliannadimatulac.github.io/portfolio/';

void _openMicaPortfolio() {
  html.window.open(_micaPortfolioUrl, '_blank');
}

class _DevelopedByFooter extends StatelessWidget {
  const _DevelopedByFooter();

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = AppText.dmSans(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF888888),
    );
    final TextStyle nameStyle = AppText.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF888888),
    );
    final TextStyle linkStyle = nameStyle.copyWith(
      decoration: TextDecoration.underline,
      decorationColor: const Color(0xFF888888),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Developed by:',
          textAlign: TextAlign.center,
          style: labelStyle,
        ),
        const SizedBox(height: 3),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('J. Casia & ', style: nameStyle),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _openMicaPortfolio,
                child: Text('M. Dimatulac', style: linkStyle),
              ),
            ),
          ],
        ),
      ],
    );
  }
}



class SettingsAdminEditScreen extends StatefulWidget {
  const SettingsAdminEditScreen({super.key});

  @override
  State<SettingsAdminEditScreen> createState() =>
      _SettingsAdminEditScreenState();
}

class _SettingsAdminEditScreenState extends State<SettingsAdminEditScreen> {
  bool _loadedArguments = false;
  bool _backHovered = false;

  late final TextEditingController _fullNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _contactNumberController;
  late final TextEditingController _programController;
  late final TextEditingController _emailController;
  late final TextEditingController _positionController;
  late final TextEditingController _passwordController;

  String _photoUrl = '';
  String _accountEmail = '';

  @override
  void initState() {
    super.initState();

    _fullNameController = TextEditingController();
    _usernameController = TextEditingController();
    _contactNumberController = TextEditingController();
    _programController = TextEditingController();
    _emailController = TextEditingController();
    _positionController = TextEditingController();
    _passwordController = TextEditingController(text: '************');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loadedArguments) return;
    _loadedArguments = true;

    final Object? args = ModalRoute.of(context)?.settings.arguments;

    final Map<String, dynamic> user =
        args is Map<String, dynamic> ? args : <String, dynamic>{};

    final String fullName = _value(user['name'], 'Julianne Marie M. Casia');
    final String email = _value(user['email'], 'jmmcasia@addu.edu.ph');
    final String role = _value(user['role'], 'OJT Intern');

    _fullNameController.text = fullName;
    _usernameController.text = _value(
      user['username'],
      _usernameFromEmail(email),
    );
    _contactNumberController.text = _value(
      user['contactNumber'],
      '0968 440 9623',
    );
    _programController.text = _value(user['program'], 'KMI');
    _emailController.text = email;
    _positionController.text = _value(user['position'], role);

    _photoUrl = _value(
      user['photoUrl'] ??
          user['avatarUrl'] ??
          user['imageUrl'] ??
          user['profileImage'] ??
          user['avatar'],
      '',
    );

    _accountEmail = email;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _contactNumberController.dispose();
    _programController.dispose();
    _emailController.dispose();
    _positionController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _value(Object? value, String fallback) {
    final String text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  String _usernameFromEmail(String email) {
    final String trimmedEmail = email.trim();

    if (!trimmedEmail.contains('@')) {
      return trimmedEmail;
    }

    return trimmedEmail.split('@').first;
  }

  Future<void> _toggleBlockUser() async {
    await BlockedUsersState.toggle(_accountEmail);

    if (!mounted) return;
    setState(() {});
  }

  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }

    Navigator.pushReplacementNamed(context, '/settings-admin');
  }

  void _saveChanges() {
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Changes saved.',
          style: AppText.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.blue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: BlockedUsersState.blockedEmails,
      builder: (context, blockedEmails, child) {
        final bool isBlocked = BlockedUsersState.isBlocked(_accountEmail);

        return Scaffold(
          body: Container(
            decoration: SettingsAdminEditStyles.pageBackground,
            child: Stack(
              children: [
                _buildBackgroundImage(),
                ValueListenableBuilder<bool>(
                  valueListenable: SidebarState.isExpanded,
                  builder: (context, isExpanded, child) {
                    return Row(
                      children: [
                        _buildSidebar(isExpanded),
                        Expanded(
                          child: SafeArea(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(
                                48,
                                28,
                                48,
                                60,
                              ),
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth:
                                        SettingsAdminEditStyles.contentMaxWidth,
                                  ),
                                  child: _buildContent(isBlocked),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AppAssets.matutum,
              width: constraints.maxWidth,
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSidebar(bool isExpanded) {
    return AnimatedContainer(
      clipBehavior: Clip.hardEdge,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      width: isExpanded
          ? SettingsAdminEditStyles.expandedSidebarWidth
          : SettingsAdminEditStyles.sidebarWidth,
      height: double.infinity,
      decoration: SettingsAdminEditStyles.sidebarDecoration,
      child: Column(
        children: [
          const SizedBox(height: 24),

          isExpanded
              ? Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 22),
                    child: _menuButton(),
                  ),
                )
              : Center(child: _menuButton()),

          if (isExpanded) ...[
            const SizedBox(height: 18),
            Image.asset(
              AppAssets.logo,
              width: 78,
              height: 78,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              'Mahintana Foundation, Inc.',
              textAlign: TextAlign.center,
              style: SettingsAdminEditStyles.orgName,
            ),
            const SizedBox(height: 4),
            Text(
              '“Building Resiliency, Sustaining Development”',
              textAlign: TextAlign.center,
              style: SettingsAdminEditStyles.orgTagline,
            ),
            const SizedBox(height: 44),
          ] else ...[
            const SizedBox(height: 126),
          ],

          _sidebarItem(
            icon: Icons.grid_view_rounded,
            label: 'Dashboard',
            selected: false,
            isExpanded: isExpanded,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/dashboard-admin');
            },
          ),

          _sidebarItem(
            icon: Icons.folder_open_rounded,
            label: 'Projects',
            selected: false,
            isExpanded: isExpanded,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/projects-admin');
            },
          ),

          _sidebarItem(
            icon: Icons.person,
            label: 'Account Settings',
            selected: true,
            isExpanded: isExpanded,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/settings-admin');
            },
          ),
          _themeToggleItem(isExpanded: isExpanded),

          _sidebarItem(
            icon: Icons.logout_rounded,
            label: 'Log Out',
            selected: false,
            isExpanded: isExpanded,
            onTap: () {
              _showLogoutConfirmation(context);
            },
          ),

          if (isExpanded) ...[
            const Spacer(),
            const _DevelopedByFooter(),
            const SizedBox(height: 28),
          ],
        ],
      ),
    );
  }

  Widget _menuButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: SidebarState.toggle,
        child: const Icon(
          Icons.menu_rounded,
          size: 34,
          color: AppColors.blue,
        ),
      ),
    );
  }


  Widget _themeToggleItem({required bool isExpanded}) {
    return Container(
      width: double.infinity,
      height: 78,
      padding: EdgeInsets.symmetric(horizontal: isExpanded ? 28 : 0),
      child: Row(
        mainAxisAlignment:
            isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wb_sunny_outlined,
            size: 28,
            color: AppColors.blue,
          ),
          if (isExpanded) ...[
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                'Dark/Light Mode',
                overflow: TextOverflow.ellipsis,
                style: SettingsAdminEditStyles.sidebarLabel,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 46,
              height: 24,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFCBD5E1),
                  width: 1,
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _sidebarItem({
    required IconData icon,
    required String label,
    required bool selected,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 78,
          color: selected
              ? SettingsAdminEditStyles.selectedSidebar
              : Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: isExpanded ? 28 : 0,
          ),
          child: Row(
            mainAxisAlignment:
                isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: AppColors.blue,
              ),
              if (isExpanded) ...[
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: SettingsAdminEditStyles.sidebarLabel,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isBlocked) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: SettingsAdminEditStyles.cardMaxWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageTitle(),

            const SizedBox(height: 42),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(34, 26, 34, 24),
              decoration: SettingsAdminEditStyles.cardDecoration,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool compact = constraints.maxWidth < 760;

                  if (compact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildAvatar(isBlocked),
                        const SizedBox(height: 18),
                        _buildUserHeader(isBlocked, compact: true),
                        const SizedBox(height: 30),
                        _buildForm(compact: true),
                        const SizedBox(height: 26),
                        _buildSaveChangesButton(fullWidth: true),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildAvatar(isBlocked),

                          const SizedBox(
                            width: SettingsAdminEditStyles.headerGap,
                          ),

                          Flexible(
                            child: _buildUserHeader(isBlocked),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      _buildForm(),
                      const SizedBox(height: 26),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _buildSaveChangesButton(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _backTextButton(),
        const SizedBox(height: 18),
        Text(
          'Edit User',
          overflow: TextOverflow.ellipsis,
          style: SettingsAdminEditStyles.pageTitle,
        ),
      ],
    );
  }

  Widget _backTextButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _backHovered = true),
      onExit: (_) => setState(() => _backHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _goBack,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 160),
          opacity: _backHovered ? 0.7 : 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.chevron_left_rounded,
                size: 24,
                color: AppColors.blue,
              ),
              Text(
                'Back to Account Settings',
                style: AppText.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isBlocked) {
    final String imageUrl = _photoUrl.trim();

    return Container(
      width: SettingsAdminEditStyles.avatarSize,
      height: SettingsAdminEditStyles.avatarSize,
      padding: const EdgeInsets.all(4),
      decoration: SettingsAdminEditStyles.avatarRingDecoration(
        isBlocked: isBlocked,
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: imageUrl.isEmpty ? null : NetworkImage(imageUrl),
        child: imageUrl.isEmpty
            ? const SizedBox.shrink()
            : null,
      ),
    );
  }

  Widget _buildUserHeader(
    bool isBlocked, {
    bool compact = false,
  }) {
    return Column(
      crossAxisAlignment:
          compact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _fullNameController.text,
          textAlign: compact ? TextAlign.center : TextAlign.left,
          style: SettingsAdminEditStyles.userName,
        ),

        const SizedBox(height: 12),

        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _toggleBlockUser,
            child: Container(
              width: 122,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(100),
                boxShadow: AppShadows.authButton,
              ),
              child: Text(
                isBlocked ? 'Unblock User' : 'Block User',
                style: SettingsAdminEditStyles.buttonText,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveChangesButton({bool fullWidth = false}) {
    return AuthButton(
      text: 'Save Changes',
      width: fullWidth ? double.infinity : 150,
      height: 38,
      type: AuthButtonType.dashboardFilled,
      onTap: _saveChanges,
      textStyle: SettingsAdminEditStyles.buttonText,
    );
  }

  Widget _buildForm({
    bool compact = false,
  }) {
    final List<Widget> leftFields = [
      _editField(
        label: 'Full Name',
        controller: _fullNameController,
      ),
      const SizedBox(height: 16),
      _editField(
        label: 'Contact Number',
        controller: _contactNumberController,
      ),
      const SizedBox(height: 16),
      _editField(
        label: 'Email',
        controller: _emailController,
      ),
      const SizedBox(height: 16),
      _editField(
        label: 'Change Password',
        controller: _passwordController,
        obscureText: true,
      ),
    ];

    final List<Widget> rightFields = [
      _editField(
        label: 'Username',
        controller: _usernameController,
      ),
      const SizedBox(height: 16),
      _editField(
        label: 'Program',
        controller: _programController,
      ),
      const SizedBox(height: 16),
      _editField(
        label: 'Position',
        controller: _positionController,
      ),
    ];

    if (compact) {
      return Column(
        children: [
          ...leftFields,
          const SizedBox(height: 16),
          ...rightFields,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: leftFields,
          ),
        ),

        const SizedBox(
          width: SettingsAdminEditStyles.desktopColumnGap,
        ),

        Expanded(
          child: Column(
            children: rightFields,
          ),
        ),
      ],
    );
  }

  Widget _editField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: SettingsAdminEditStyles.fieldLabel,
        ),

        const SizedBox(height: 4),

        SizedBox(
          height: 34,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: SettingsAdminEditStyles.fieldText,
            decoration: SettingsAdminEditStyles.fieldDecoration(),
            onChanged: (_) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}