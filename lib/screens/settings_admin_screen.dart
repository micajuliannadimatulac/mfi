import 'dart:html' as html;

import 'package:flutter/material.dart';
import '../state/blocked_users_state.dart';
import '../state/sidebar_state.dart';
import '../styles/app_styles.dart';
import '../styles/settings_styles.dart';
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



enum _AccountSortOrder { az, za }

class SettingsAdminScreen extends StatefulWidget {
  const SettingsAdminScreen({super.key});

  @override
  State<SettingsAdminScreen> createState() => _SettingsAdminScreenState();
}

class _SettingsAdminScreenState extends State<SettingsAdminScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _headerHasBackground = false;

  String _selectedFilter = 'All';
  _AccountSortOrder _sortOrder = _AccountSortOrder.az;

  // Change/replace these values when your real filter values are ready.
  final List<String> _filterOptions = const ['All', 'Active', 'Blocked'];

  final List<_AccountUser> _users = [
    const _AccountUser(
      'Julianne Marie M. Casia',
      'jmmcasia@addu.edu.ph',
      'OJT Intern',
      'https://i.pravatar.cc/150?img=1',
      username: 'Jcasia10',
      contactNumber: '0968 440 9623',
      program: 'KMI',
    ),
    const _AccountUser('Mica Julianna Dimatulac', 'mjdimatulac@addu.edu.ph',
        'OJT Intern', 'https://i.pravatar.cc/150?img=5'),
    const _AccountUser('Tristan Jay Sintos', 'tjsintos@addu.edu.ph',
        'OJT Intern', 'https://i.pravatar.cc/150?img=8'),
    const _AccountUser('Daenyell Sarcon', 'dsarcon@mahintana.org', 'Admin',
        'https://i.pravatar.cc/150?img=11'),
    const _AccountUser('Julianne Marie M. Casia', 'jmmcasia2@addu.edu.ph',
        'OJT Intern', 'https://i.pravatar.cc/150?img=16'),
    const _AccountUser('Mica Julianna Dimatulac', 'mjdimatulac2@addu.edu.ph',
        'OJT Intern', 'https://i.pravatar.cc/150?img=20'),
    const _AccountUser('Tristan Jay Sintos', 'tjsintos2@addu.edu.ph',
        'OJT Intern', 'https://i.pravatar.cc/150?img=24'),
    const _AccountUser('Julianne Marie M. Casia', 'jmmcasia3@addu.edu.ph',
        'OJT Intern', 'https://i.pravatar.cc/150?img=29',
        isBlocked: true),
    const _AccountUser('Mica Julianna Dimatulac', 'mjdimatulac3@addu.edu.ph',
        'OJT Intern', 'https://i.pravatar.cc/150?img=32'),
    const _AccountUser('Tristan Jay Sintos', 'tjsintos3@addu.edu.ph',
        'OJT Intern', 'https://i.pravatar.cc/150?img=36'),
    const _AccountUser('Julianne Marie M. Casia', 'jmmcasia4@addu.edu.ph',
        'OJT Intern', 'https://i.pravatar.cc/150?img=40'),
    const _AccountUser('Mica Julianna Dimatulac', 'mjdimatulac4@addu.edu.ph',
        'OJT Intern', 'https://i.pravatar.cc/150?img=44'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleHeaderBackground);
    BlockedUsersState.reload();
  }

  void _handleHeaderBackground() {
    final bool shouldShow = _scrollController.hasClients &&
        _scrollController.offset > 0.5;

    if (shouldShow == _headerHasBackground) {
      return;
    }

    setState(() {
      _headerHasBackground = shouldShow;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleHeaderBackground);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openEditUser(_AccountUser user) {
    Navigator.pushNamed(
      context,
      '/settings-admin-edit',
      arguments: <String, dynamic>{
        'name': user.name,
        'email': user.email,
        'role': user.role,
        'position': user.role,
        'photoUrl': user.photoUrl,
        'username': user.username,
        'contactNumber': user.contactNumber,
        'program': user.program,
      },
    );
  }

  List<_AccountUser> get _filteredUsers {
    final String searchText = _searchController.text.trim().toLowerCase();

    final List<_AccountUser> filtered = _users.where((user) {
      final bool isBlocked = BlockedUsersState.isBlocked(user.email);
      final bool matchesSearch = user.name.toLowerCase().contains(searchText) ||
          user.email.toLowerCase().contains(searchText) ||
          user.role.toLowerCase().contains(searchText);

      final bool matchesFilter = switch (_selectedFilter) {
        'Active' => !isBlocked,
        'Blocked' => isBlocked,
        _ => true,
      };

      return matchesSearch && matchesFilter;
    }).toList();

    filtered.sort((a, b) {
      final int result = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      return _sortOrder == _AccountSortOrder.az ? result : -result;
    });

    return filtered;
  }

  Future<void> _toggleBlockUser(_AccountUser user) async {
    await BlockedUsersState.toggle(user.email);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: BlockedUsersState.blockedEmails,
      builder: (context, _, child) {
        final List<_AccountUser> users = _filteredUsers;

        return Scaffold(
          body: Container(
        decoration: SettingsStyles.pageBackground,
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
                        child: CustomScrollView(
                          controller: _scrollController,
                          slivers: [
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _StickyHeaderDelegate(
                                child: Container(
                                  decoration: _headerHasBackground
                                      ? const BoxDecoration(
                                          gradient: AppGradients.authBackground,
                                        )
                                      : const BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                  padding:
                                      const EdgeInsets.fromLTRB(48, 28, 48, 26),
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          maxWidth:
                                              SettingsStyles.contentMaxWidth),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          _buildHeader(showLogo: true),
                                          const SizedBox(height: 26),
                                          _buildControls(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                height: 180,
                              ),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(48, 0, 48, 60),
                              sliver: SliverToBoxAdapter(
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        maxWidth:
                                            SettingsStyles.contentMaxWidth),
                                    child: users.isEmpty
                                        ? _buildEmptyCard()
                                        : _buildAccountGrid(users),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
          ? SettingsStyles.expandedSidebarWidth
          : SettingsStyles.sidebarWidth,
      height: double.infinity,
      decoration: SettingsStyles.sidebarDecoration,
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
            Image.asset(AppAssets.logo,
                width: 78, height: 78, fit: BoxFit.contain),
            const SizedBox(height: 10),
            Text('Mahintana Foundation, Inc.',
                textAlign: TextAlign.center, style: SettingsStyles.orgName),
            const SizedBox(height: 4),
            Text('“Building Resiliency, Sustaining Development”',
                textAlign: TextAlign.center, style: SettingsStyles.orgTagline),
            const SizedBox(height: 44),
          ] else ...[
            const SizedBox(height: 126),
          ],
          _sidebarItem(
            icon: Icons.grid_view_rounded,
            label: 'Dashboard',
            selected: false,
            isExpanded: isExpanded,
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/dashboard-admin'),
          ),
          _sidebarItem(
            icon: Icons.folder_open_rounded,
            label: 'Projects & Activities',
            selected: false,
            isExpanded: isExpanded,
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/projects-admin'),
          ),
          _sidebarItem(
            icon: Icons.calendar_month_rounded,
            label: 'Calendar',
            selected: false,
            isExpanded: isExpanded,
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/calendar-admin'),
          ),
          _sidebarItem(
              icon: Icons.person,
              label: 'Account Settings',
              selected: true,
              isExpanded: isExpanded,
              onTap: () {}),
          _themeToggleItem(isExpanded: isExpanded),
          _sidebarItem(
            icon: Icons.logout_rounded,
            label: 'Log Out',
            selected: false,
            isExpanded: isExpanded,
            onTap: () => _showLogoutConfirmation(context),
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
        child: const Icon(Icons.menu_rounded, size: 34, color: AppColors.blue),
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
                style: SettingsStyles.sidebarLabel,
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
          color: selected ? SettingsStyles.selectedSidebar : Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: isExpanded ? 28 : 0),
          child: Row(
            mainAxisAlignment:
                isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: AppColors.blue),
              if (isExpanded) ...[
                const SizedBox(width: 18),
                Expanded(
                    child: Text(label,
                        overflow: TextOverflow.ellipsis,
                        style: SettingsStyles.sidebarLabel)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({required bool showLogo}) {
    return Row(
      children: [
        if (showLogo) ...[
          Image.asset(AppAssets.logo,
              width: 56, height: 56, fit: BoxFit.contain),
          const SizedBox(width: 14),
        ],
        Expanded(
          child: Text(
            'Account Settings',
            overflow: TextOverflow.ellipsis,
            style: SettingsStyles.pageTitle,
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compact = constraints.maxWidth < 760;

        if (compact) {
          return Column(
            children: [
              _searchBox(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _filterDropdown()),
                  const SizedBox(width: 12),
                  SizedBox(width: 140, child: _sortDropdown()),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: _searchBox()),
            const SizedBox(width: 14),
            SizedBox(width: 235, child: _filterDropdown()),
            const SizedBox(width: 14),
            SizedBox(width: 140, child: _sortDropdown()),
          ],
        );
      },
    );
  }

  Widget _searchBox() {
    return SizedBox(
      height: 42,
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: AppText.dmSans(fontSize: 13, color: AppColors.blue),
        decoration: SettingsStyles.searchInputDecoration(hintText: 'Search'),
      ),
    );
  }

  Widget _filterDropdown() {
    return _dropdownShell(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFilter,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.blue, size: 22),
          style: SettingsStyles.dropdownText,
          dropdownColor: Colors.white,
          items: _filterOptions
              .map((filter) =>
                  DropdownMenuItem<String>(value: filter, child: Text(filter)))
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedFilter = value);
          },
        ),
      ),
    );
  }

  Widget _sortDropdown() {
    return _dropdownShell(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<_AccountSortOrder>(
          value: _sortOrder,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.blue, size: 22),
          style: SettingsStyles.dropdownText,
          dropdownColor: Colors.white,
          items: const [
            DropdownMenuItem(value: _AccountSortOrder.az, child: Text('A-Z')),
            DropdownMenuItem(value: _AccountSortOrder.za, child: Text('Z-A')),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() => _sortOrder = value);
          },
        ),
      ),
    );
  }

  Widget _dropdownShell({required Widget child}) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: SettingsStyles.controlDecoration,
      child: child,
    );
  }

  Widget _buildAccountGrid(List<_AccountUser> users) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = constraints.maxWidth >= 1020
            ? 3
            : constraints.maxWidth >= 690
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: users.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 118,
          ),
          itemBuilder: (context, index) => _accountCard(users[index]),
        );
      },
    );
  }

  Widget _accountCard(_AccountUser user) {
    return Container(
      decoration: SettingsStyles.accountCardDecoration,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          _avatar(user),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(user.name,
                            overflow: TextOverflow.ellipsis,
                            style: SettingsStyles.cardTitle)),
                    if (BlockedUsersState.isBlocked(user.email)) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.block_rounded,
                          color: Color(0xFFC43030), size: 16),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(user.email,
                    overflow: TextOverflow.ellipsis,
                    style: SettingsStyles.cardMeta),
                const SizedBox(height: 2),
                Text(user.role,
                    overflow: TextOverflow.ellipsis,
                    style: SettingsStyles.cardMeta),
                const SizedBox(height: 12),
                Row(
                  children: [
                    AuthButton(
                      text: BlockedUsersState.isBlocked(user.email)
                          ? 'Unblock'
                          : 'Block User',
                      width: 88,
                      height: 26,
                      type: AuthButtonType.dashboardFilled,
                      onTap: () => _toggleBlockUser(user),
                      textStyle: SettingsStyles.buttonText,
                    ),
                    const SizedBox(width: 8),
                    AuthButton(
                      text: 'Edit User',
                      width: 82,
                      height: 26,
                      type: AuthButtonType.dashboardFilled,
                      onTap: () => _openEditUser(user),
                      textStyle: SettingsStyles.buttonText,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(_AccountUser user) {
    final String initials = user.initials;

    return Container(
      width: 68,
      height: 68,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: BlockedUsersState.isBlocked(user.email)
              ? const Color(0xFFC43030)
              : const Color(0xFF379543),
          width: 2,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: AppColors.blue.withValues(alpha: 0.10),
        backgroundImage:
            user.photoUrl.trim().isEmpty ? null : NetworkImage(user.photoUrl),
        child: user.photoUrl.trim().isEmpty
            ? Text(
                initials,
                style: AppText.calSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue),
              )
            : null,
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      height: 180,
      decoration: SettingsStyles.cardDecoration,
      child: Center(
          child: Text('No accounts found.', style: SettingsStyles.emptyText)),
    );
  }
}

class _AccountUser {
  const _AccountUser(
    this.name,
    this.email,
    this.role,
    this.photoUrl, {
    this.username = '',
    this.contactNumber = '',
    this.program = 'KMI',
    this.isBlocked = false,
  });

  final String name;
  final String email;
  final String role;
  final String photoUrl;
  final String username;
  final String contactNumber;
  final String program;
  final bool isBlocked;

  String get initials {
    final List<String> words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  _AccountUser copyWith(
      {String? name,
      String? email,
      String? role,
      String? photoUrl,
      String? username,
      String? contactNumber,
      String? program,
      bool? isBlocked}) {
    return _AccountUser(
      name ?? this.name,
      email ?? this.email,
      role ?? this.role,
      photoUrl ?? this.photoUrl,
      username: username ?? this.username,
      contactNumber: contactNumber ?? this.contactNumber,
      program: program ?? this.program,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  _StickyHeaderDelegate({
    required this.child,
    required this.height,
  });

  final Widget child;
  final double height;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: overlapsContent ? 2 : 0,
      color: Colors.transparent,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
}
