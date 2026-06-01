import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../state/sidebar_state.dart';
import '../styles/app_styles.dart';
import '../styles/projects_styles.dart';
import '../widgets/auth_buttons.dart';
import 'activities_admin_screen.dart';


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



enum _ProjectSortOrder {
  az,
  za,
  lastAccessed,
  mostRecentAdded,
  percentageLowToHigh,
  percentageHighToLow,
}

class ProjectsAdminScreen extends StatefulWidget {
  const ProjectsAdminScreen({super.key});

  @override
  State<ProjectsAdminScreen> createState() => _ProjectsAdminScreenState();
}

class _ProjectsAdminScreenState extends State<ProjectsAdminScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _headerHasBackground = false;

  final List<String> _programOptions = const [
    'All Programs',
    'IBG',
    'DSS',
    'ENVI',
    'KMI',
  ];

  final List<String> _statusOptions = const [
    'All Status',
    'Completed',
    'In Progress',
    'Not Started',
  ];

  late final List<_ProjectItem> _projects;

  String _selectedProgram = 'All Programs';
  String _selectedStatus = 'All Status';
  _ProjectSortOrder _sortOrder = _ProjectSortOrder.az;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleHeaderBackground);

    final DateTime now = DateTime.now();
    _projects = _defaultProjects(now);
  }

  List<_ProjectItem> _defaultProjects(DateTime now) {
    const List<String> programs = [
      'IBG',
      'DSS',
      'ENVI',
      'KMI',
    ];

    final List<_ProjectItem> defaultProjects = [];

    for (final String program in programs) {
      final List<int> percents = _projectPercentsFor(program);

      for (int index = 0; index < percents.length; index++) {
        final int projectNumber = index + 1;
        final int progress = percents[index];
        final int order = defaultProjects.length;

        defaultProjects.add(
          _ProjectItem(
            title: '$program Project $projectNumber',
            program: program,
            status: _statusForProgress(progress),
            description: _projectDescriptionFor(program, projectNumber),
            scheduleFrom: now.subtract(Duration(days: 24 - order)),
            scheduleTo: now.add(Duration(days: 6 + order)),
            progress: progress,
            dateAdded: now.subtract(Duration(days: 32 - order)),
            lastAccessed: now.subtract(Duration(hours: 3 + order)),
          ),
        );
      }
    }

    return defaultProjects;
  }

  List<int> _projectPercentsFor(String program) {
    switch (program.toUpperCase()) {
      case 'IBG':
        return [95, 90, 85, 80, 75, 70];
      case 'DSS':
        return [72, 68, 60, 52, 44, 36];
      case 'ENVI':
        return [55, 45, 35, 25, 15, 10];
      case 'KMI':
        return [88, 78, 70, 62, 50, 42];
      default:
        return [0, 0, 0, 0, 0, 0];
    }
  }

  String _statusForProgress(int progress) {
    if (progress >= 100) {
      return 'Completed';
    }

    if (progress <= 0) {
      return 'Not Started';
    }

    return 'In Progress';
  }

  String _projectDescriptionFor(String program, int projectNumber) {
    switch (program.toUpperCase()) {
      case 'IBG':
        return 'Supports income-building activities and enterprise development monitoring.';
      case 'DSS':
        return 'Tracks community services, field coordination, and support activities.';
      case 'ENVI':
        return 'Monitors environmental activities, field updates, and project progress.';
      case 'KMI':
        return 'Organizes knowledge management outputs, documentation, and reports.';
      default:
        return 'Tracks project activities, updates, and progress monitoring.';
    }
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

  List<_ProjectItem> get _filteredProjects {
    final String searchText = _searchController.text.trim().toLowerCase();

    final List<_ProjectItem> filtered = _projects.where((project) {
      final bool matchesSearch = project.title.toLowerCase().contains(
                searchText,
              ) ||
          project.program.toLowerCase().contains(searchText) ||
          project.status.toLowerCase().contains(searchText) ||
          project.description.toLowerCase().contains(searchText);

      final bool matchesProgram = _selectedProgram == 'All Programs' ||
          project.program == _selectedProgram;

      final bool matchesStatus = _selectedStatus == 'All Status' ||
          project.status == _selectedStatus;

      return matchesSearch && matchesProgram && matchesStatus;
    }).toList();

    filtered.sort((a, b) {
      switch (_sortOrder) {
        case _ProjectSortOrder.az:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case _ProjectSortOrder.za:
          return b.title.toLowerCase().compareTo(a.title.toLowerCase());
        case _ProjectSortOrder.lastAccessed:
          return b.lastAccessed.compareTo(a.lastAccessed);
        case _ProjectSortOrder.mostRecentAdded:
          return b.dateAdded.compareTo(a.dateAdded);
        case _ProjectSortOrder.percentageLowToHigh:
          return a.progress.compareTo(b.progress);
        case _ProjectSortOrder.percentageHighToLow:
          return b.progress.compareTo(a.progress);
      }
    });

    return filtered;
  }

  List<String> get _editableProgramOptions {
    return _programOptions
        .where((program) => program != 'All Programs')
        .toList();
  }

  Future<void> _addProject() async {
    final _ProjectDraft? draft = await showDialog<_ProjectDraft>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _ProjectDetailsDialog(
          title: 'Add Project',
          buttonText: 'Add',
          programs: _editableProgramOptions,
        );
      },
    );

    if (draft == null || draft.title.trim().isEmpty) {
      return;
    }

    final DateTime now = DateTime.now();

    setState(() {
      _projects.add(
        _ProjectItem(
          title: draft.title.trim(),
          program: draft.program,
          status: 'Not Started',
          description: draft.description.trim().isEmpty
              ? 'No description added yet.'
              : draft.description.trim(),
          scheduleFrom: draft.scheduleFrom,
          scheduleTo: draft.scheduleTo,
          progress: 0,
          dateAdded: now,
          lastAccessed: now,
        ),
      );
    });
  }

  Future<void> _editProject(_ProjectItem oldProject) async {
    final _ProjectDraft? draft = await showDialog<_ProjectDraft>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _ProjectDetailsDialog(
          title: 'Edit Project',
          buttonText: 'Save',
          programs: _editableProgramOptions,
          initialTitle: oldProject.title,
          initialDescription: oldProject.description,
          initialProgram: oldProject.program,
          initialScheduleFrom: oldProject.scheduleFrom,
          initialScheduleTo: oldProject.scheduleTo,
        );
      },
    );

    if (draft == null || draft.title.trim().isEmpty) {
      return;
    }

    setState(() {
      final int index = _projects.indexOf(oldProject);

      if (index != -1) {
        _projects[index] = oldProject.copyWith(
          title: draft.title.trim(),
          program: draft.program,
          description: draft.description.trim().isEmpty
              ? 'No description added yet.'
              : draft.description.trim(),
          scheduleFrom: draft.scheduleFrom,
          scheduleTo: draft.scheduleTo,
        );
      }
    });
  }

  void _deleteProject(_ProjectItem project) {
    showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _DeleteProjectConfirmationDialog(
          projectName: project.title,
        );
      },
    ).then((confirmed) {
      if (confirmed != true) {
        return;
      }

      setState(() {
        _projects.remove(project);
      });
    });
  }

  void _openProject(_ProjectItem project) {
    setState(() {
      project.lastAccessed = DateTime.now();
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ActivitiesAdminScreen(
            projectTitle: project.title,
            projectDescription: project.description,
            projectProgram: project.program,
            projectProgress: project.progress,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<_ProjectItem> projects = _filteredProjects;

    return Scaffold(
      body: Container(
        decoration: ProjectsStyles.pageBackground,
        child: Stack(
          children: [
            _buildBackgroundImage(),
            ValueListenableBuilder<bool>(
              valueListenable: SidebarState.isExpanded,
              builder: (context, isExpanded, child) {
                final double contentWidth = MediaQuery.of(context).size.width -
                    (isExpanded
                        ? ProjectsStyles.expandedSidebarWidth
                        : ProjectsStyles.sidebarWidth) -
                    96;
                final double headerHeight = contentWidth < 980 ? 304 : 180;

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
                                  padding: const EdgeInsets.fromLTRB(
                                    48,
                                    28,
                                    48,
                                    26,
                                  ),
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth:
                                            ProjectsStyles.contentMaxWidth,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          _buildHeader(),
                                          const SizedBox(height: 26),
                                          _buildControls(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                height: headerHeight,
                              ),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(
                                48,
                                0,
                                48,
                                60,
                              ),
                              sliver: SliverToBoxAdapter(
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: ProjectsStyles.contentMaxWidth,
                                    ),
                                    child: projects.isEmpty
                                        ? _buildEmptyCard()
                                        : _buildProjectsGrid(projects),
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
          ? ProjectsStyles.expandedSidebarWidth
          : ProjectsStyles.sidebarWidth,
      height: double.infinity,
      decoration: ProjectsStyles.sidebarDecoration,
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
              style: ProjectsStyles.orgName,
            ),
            const SizedBox(height: 4),
            Text(
              '“Building Resiliency, Sustaining Development”',
              textAlign: TextAlign.center,
              style: ProjectsStyles.orgTagline,
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
            label: 'Projects & Activities',
            selected: true,
            isExpanded: isExpanded,
            onTap: () {},
          ),
          _sidebarItem(
            icon: Icons.calendar_month_rounded,
            label: 'Calendar',
            selected: false,
            isExpanded: isExpanded,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/calendar-admin');
            },
          ),
          _sidebarItem(
            icon: Icons.person,
            label: 'Account Settings',
            selected: false,
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
                style: ProjectsStyles.sidebarLabel,
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
          color: selected ? ProjectsStyles.selectedSidebar : Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: isExpanded ? 28 : 0,
          ),
          child: Row(
            mainAxisAlignment:
                isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 26,
                color: AppColors.blue,
              ),
              if (isExpanded) ...[
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: ProjectsStyles.sidebarLabel,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Image.asset(
          AppAssets.logo,
          width: 56,
          height: 56,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            'Projects',
            overflow: TextOverflow.ellipsis,
            style: ProjectsStyles.pageTitle,
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compact = constraints.maxWidth < 980;

        if (compact) {
          return Column(
            children: [
              _searchBox(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _programDropdown()),
                  const SizedBox(width: 12),
                  Expanded(child: _statusDropdown()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _sortDropdown()),
                  const SizedBox(width: 12),
                  AuthButton(
                    text: '+ Add Project',
                    width: 150,
                    height: 42,
                    type: AuthButtonType.dashboardFilled,
                    onTap: _addProject,
                    textStyle: ProjectsStyles.buttonText,
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: _searchBox()),
            const SizedBox(width: 14),
            SizedBox(width: 165, child: _programDropdown()),
            const SizedBox(width: 14),
            SizedBox(width: 165, child: _statusDropdown()),
            const SizedBox(width: 14),
            SizedBox(width: 200, child: _sortDropdown()),
            const SizedBox(width: 14),
            AuthButton(
              text: '+ Add Project',
              width: 150,
              height: 42,
              type: AuthButtonType.dashboardFilled,
              onTap: _addProject,
              textStyle: ProjectsStyles.buttonText,
            ),
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
        style: AppText.dmSans(
          fontSize: 13,
          color: AppColors.blue,
        ),
        decoration: ProjectsStyles.searchInputDecoration(
          hintText: 'Search projects',
        ),
      ),
    );
  }

  Widget _programDropdown() {
    return _dropdownShell(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedProgram,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.blue,
            size: 22,
          ),
          style: ProjectsStyles.dropdownText,
          dropdownColor: Colors.white,
          items: _programOptions
              .map(
                (program) => DropdownMenuItem<String>(
                  value: program,
                  child: Text(program),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedProgram = value);
          },
        ),
      ),
    );
  }

  Widget _statusDropdown() {
    return _dropdownShell(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatus,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.blue,
            size: 22,
          ),
          style: ProjectsStyles.dropdownText,
          dropdownColor: Colors.white,
          items: _statusOptions
              .map(
                (status) => DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedStatus = value);
          },
        ),
      ),
    );
  }

  Widget _sortDropdown() {
    return _dropdownShell(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<_ProjectSortOrder>(
          value: _sortOrder,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.blue,
            size: 22,
          ),
          style: ProjectsStyles.dropdownText,
          dropdownColor: Colors.white,
          items: const [
            DropdownMenuItem(
              value: _ProjectSortOrder.az,
              child: Text('A-Z'),
            ),
            DropdownMenuItem(
              value: _ProjectSortOrder.za,
              child: Text('Z-A'),
            ),
            DropdownMenuItem(
              value: _ProjectSortOrder.lastAccessed,
              child: Text('Last Accessed'),
            ),
            DropdownMenuItem(
              value: _ProjectSortOrder.mostRecentAdded,
              child: Text('Most Recent Added'),
            ),
            DropdownMenuItem(
              value: _ProjectSortOrder.percentageLowToHigh,
              child: Text('Percentage: Low to High'),
            ),
            DropdownMenuItem(
              value: _ProjectSortOrder.percentageHighToLow,
              child: Text('Percentage: High to Low'),
            ),
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
      decoration: ProjectsStyles.controlDecoration,
      child: child,
    );
  }

  Widget _buildProjectsGrid(List<_ProjectItem> projects) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = constraints.maxWidth >= 1050
            ? 3
            : constraints.maxWidth >= 700
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projects.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 222,
          ),
          itemBuilder: (context, index) {
            return _projectCard(projects[index]);
          },
        );
      },
    );
  }

  Widget _projectCard(_ProjectItem project) {
    final double clampedProgress = project.progress.clamp(0, 100).toDouble();
    final Color statusColor = ProjectsStyles.statusColor(project.status);
    final Color progressColor = ProjectsStyles.progressColor(clampedProgress);

    return Container(
      decoration: ProjectsStyles.cardDecoration,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.folder_open_rounded,
                    size: 22,
                    color: AppColors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ProjectsStyles.cardTitle,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            project.program,
                            overflow: TextOverflow.ellipsis,
                            style: ProjectsStyles.cardMeta,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _statusChip(project.status, statusColor),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ProjectIconActionButton(
                    tooltip: 'Edit project',
                    icon: Icons.edit_outlined,
                    onTap: () => _editProject(project),
                  ),
                  const SizedBox(width: 8),
                  _ProjectIconActionButton(
                    tooltip: 'Delete project',
                    icon: Icons.delete_outline_rounded,
                    onTap: () => _deleteProject(project),
                    isDelete: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            project.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: ProjectsStyles.cardDescription,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    minHeight: 9,
                    value: clampedProgress / 100,
                    backgroundColor: const Color(0xFFE0E0E0),
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${clampedProgress.toInt()}%',
                style: AppText.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Added ${_formatDate(project.dateAdded)} • Last ${_formatDate(project.lastAccessed)}',
                  overflow: TextOverflow.ellipsis,
                  style: ProjectsStyles.cardMeta,
                ),
              ),
              const SizedBox(width: 12),
              AuthButton(
                text: 'View Project',
                width: 112,
                height: 32,
                type: AuthButtonType.dashboardFilled,
                onTap: () => _openProject(project),
                textStyle: ProjectsStyles.viewActivitiesText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status, Color color) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: color.withOpacity(0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: AppText.dmSans(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildEmptyCard() {
    return Container(
      height: 260,
      alignment: Alignment.center,
      decoration: ProjectsStyles.cardDecoration,
      child: Text(
        'No projects found.',
        style: ProjectsStyles.emptyText,
      ),
    );
  }
}

class _ProjectItem {
  _ProjectItem({
    required this.title,
    required this.program,
    required this.status,
    required this.description,
    required this.scheduleFrom,
    required this.scheduleTo,
    required this.progress,
    required this.dateAdded,
    required this.lastAccessed,
  });

  final String title;
  final String program;
  final String status;
  final String description;
  final DateTime scheduleFrom;
  final DateTime scheduleTo;
  final int progress;
  final DateTime dateAdded;
  DateTime lastAccessed;

  _ProjectItem copyWith({
    String? title,
    String? program,
    String? status,
    String? description,
    DateTime? scheduleFrom,
    DateTime? scheduleTo,
    int? progress,
    DateTime? dateAdded,
    DateTime? lastAccessed,
  }) {
    return _ProjectItem(
      title: title ?? this.title,
      program: program ?? this.program,
      status: status ?? this.status,
      description: description ?? this.description,
      scheduleFrom: scheduleFrom ?? this.scheduleFrom,
      scheduleTo: scheduleTo ?? this.scheduleTo,
      progress: progress ?? this.progress,
      dateAdded: dateAdded ?? this.dateAdded,
      lastAccessed: lastAccessed ?? this.lastAccessed,
    );
  }
}

class _ProjectDraft {
  const _ProjectDraft({
    required this.title,
    required this.description,
    required this.program,
    required this.scheduleFrom,
    required this.scheduleTo,
  });

  final String title;
  final String description;
  final String program;
  final DateTime scheduleFrom;
  final DateTime scheduleTo;
}


class _ProjectIconActionButton extends StatefulWidget {
  const _ProjectIconActionButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
    this.isDelete = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDelete;

  @override
  State<_ProjectIconActionButton> createState() =>
      _ProjectIconActionButtonState();
}

class _ProjectIconActionButtonState extends State<_ProjectIconActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Color color =
        widget.isDelete ? const Color(0xFFC43030) : AppColors.blue;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 160),
            opacity: _hovered ? 0.7 : 1,
            child: Icon(
              widget.icon,
              size: 19,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectDetailsDialog extends StatefulWidget {
  const _ProjectDetailsDialog({
    required this.title,
    required this.buttonText,
    required this.programs,
    this.initialTitle = '',
    this.initialDescription = '',
    this.initialProgram = '',
    this.initialScheduleFrom,
    this.initialScheduleTo,
  });

  final String title;
  final String buttonText;
  final List<String> programs;
  final String initialTitle;
  final String initialDescription;
  final String initialProgram;
  final DateTime? initialScheduleFrom;
  final DateTime? initialScheduleTo;

  @override
  State<_ProjectDetailsDialog> createState() => _ProjectDetailsDialogState();
}

class _ProjectDetailsDialogState extends State<_ProjectDetailsDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  DateTime? _scheduleFrom;
  DateTime? _scheduleTo;
  late String _selectedProgram;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(
      text: widget.initialDescription,
    );
    _scheduleFrom = widget.initialScheduleFrom;
    _scheduleTo = widget.initialScheduleTo;
    _selectedProgram = widget.programs.contains(widget.initialProgram)
        ? widget.initialProgram
        : widget.programs.isEmpty
            ? ''
            : widget.programs.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    final String title = _titleController.text.trim();

    if (title.isEmpty || _selectedProgram.isEmpty || _scheduleFrom == null || _scheduleTo == null) {
      return;
    }

    Navigator.pop(
      context,
      _ProjectDraft(
        title: title,
        description: _descriptionController.text.trim(),
        program: _selectedProgram,
        scheduleFrom: _scheduleFrom!,
        scheduleTo: _scheduleTo!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 560,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(40, 38, 40, 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: AppText.calSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 28),
              _fieldLabel('Title*'),
              const SizedBox(height: 8),
              SizedBox(
                height: 46,
                child: TextField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  style: AppText.dmSans(
                    fontSize: 15,
                    color: AppColors.blue,
                  ),
                  decoration: _fieldDecoration(),
                ),
              ),
              const SizedBox(height: 16),
              _fieldLabel('Program*'),
              const SizedBox(height: 8),
              _dialogDropdown<String>(
                value: _selectedProgram,
                items: widget.programs,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedProgram = value);
                },
              ),
              const SizedBox(height: 16),
              _fieldLabel('Description'),
              const SizedBox(height: 8),
              SizedBox(
                height: 84,
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                  style: AppText.dmSans(
                    fontSize: 15,
                    color: AppColors.blue,
                  ),
                  decoration: _fieldDecoration(
                    hintText: 'Add a short project description',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _dateField(
                      label: 'Schedule From*',
                      value: _scheduleFrom,
                      onTap: () => _pickDate(isFrom: true),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _dateField(
                      label: 'Schedule To*',
                      value: _scheduleTo,
                      onTap: () => _pickDate(isFrom: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthButton(
                    text: 'Cancel',
                    width: 115,
                    height: 44,
                    type: AuthButtonType.dashboardOutline,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    textStyle: AppText.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(width: 24),
                  AuthButton(
                    text: widget.buttonText,
                    width: 115,
                    height: 44,
                    type: AuthButtonType.dashboardFilled,
                    onTap: _submit,
                    textStyle: AppText.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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


  Future<void> _pickDate({required bool isFrom}) async {
    final DateTime initialDate = isFrom
        ? (_scheduleFrom ?? DateTime.now())
        : (_scheduleTo ?? _scheduleFrom ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      if (isFrom) {
        _scheduleFrom = picked;
        if (_scheduleTo != null && _scheduleTo!.isBefore(picked)) {
          _scheduleTo = picked;
        }
      } else {
        _scheduleTo = picked;
      }
    });
  }

  Widget _dateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 8),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: AbsorbPointer(
              child: SizedBox(
                height: 46,
                child: TextField(
                  controller: TextEditingController(
                    text: value == null ? '' : _formatDialogDate(value),
                  ),
                  style: AppText.dmSans(
                    fontSize: 15,
                    color: AppColors.blue,
                  ),
                  decoration: _fieldDecoration(
                    hintText: 'Select date',
                  ).copyWith(
                    suffixIcon: const Icon(
                      Icons.calendar_month_rounded,
                      color: AppColors.blue,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDialogDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: AppText.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.blue,
      ),
    );
  }

  InputDecoration _fieldDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppText.dmSans(
        fontSize: 13,
        color: AppColors.placeholderGray,
      ),
      filled: true,
      fillColor: AppColors.softGray,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.borderGray,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.blue,
          width: 1,
        ),
      ),
    );
  }

  Widget _dialogDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: ProjectsStyles.controlDecoration,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.blue,
          ),
          style: ProjectsStyles.dropdownText,
          dropdownColor: Colors.white,
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(item.toString()),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _DeleteProjectConfirmationDialog extends StatelessWidget {
  const _DeleteProjectConfirmationDialog({
    required this.projectName,
  });

  final String projectName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 480,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(36, 34, 36, 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Delete Project',
                textAlign: TextAlign.center,
                style: AppText.calSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Are you sure you want to delete "$projectName" from projects? This cannot be undone.',
                textAlign: TextAlign.center,
                style: AppText.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGray,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthButton(
                    text: 'Cancel',
                    width: 115,
                    height: 42,
                    type: AuthButtonType.dashboardOutline,
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                    textStyle: AppText.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(width: 22),
                  AuthButton(
                    text: 'Delete',
                    width: 115,
                    height: 42,
                    type: AuthButtonType.dashboardFilled,
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    textStyle: AppText.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _StickyHeaderDelegate({
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
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
}
