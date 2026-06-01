import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../state/sidebar_state.dart';
import '../styles/app_styles.dart';
import '../styles/calendar_styles.dart';
import '../widgets/auth_buttons.dart';
import 'activities_admin_details_screen.dart';
import 'activities_admin_screen.dart';

Future<void> _showLogoutConfirmation(BuildContext context) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.35),
    builder: (context) => const _LogoutConfirmationDialog(),
  );

  if (confirmed != true || !context.mounted) return;

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
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
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
                'Log Out',
                textAlign: TextAlign.center,
                style: AppText.calSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Are you sure you want to log out?',
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
                    onTap: () => Navigator.pop(context, false),
                    textStyle: AppText.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(width: 22),
                  AuthButton(
                    text: 'Log Out',
                    width: 115,
                    height: 42,
                    type: AuthButtonType.dashboardFilled,
                    onTap: () => Navigator.pop(context, true),
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

const String _micaPortfolioUrl = 'https://micajuliannadimatulac.github.io/portfolio/';

void _openMicaPortfolio() {
  html.window.open(_micaPortfolioUrl, '_blank');
}

class CalendarAdminScreen extends StatefulWidget {
  const CalendarAdminScreen({super.key});

  @override
  State<CalendarAdminScreen> createState() => _CalendarAdminScreenState();
}

class _CalendarAdminScreenState extends State<CalendarAdminScreen> {
  late final DateTime _visibleMonth;
  late final List<_CalendarEntry> _entries;

  final Set<String> _selectedPrograms = <String>{'All'};
  String _selectedProject = 'All Projects';
  bool _showProjects = true;
  bool _showActivities = true;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month, 1);
    _entries = _defaultCalendarEntries(_visibleMonth);
  }

  List<String> get _programOptions {
    final Set<String> programs = _entries.map((entry) => entry.program).toSet();
    return <String>['All', ...(programs.toList()..sort())];
  }

  List<String> get _projectOptions {
    final Set<String> projects = _entries.map((entry) => entry.projectTitle).toSet();
    return <String>['All Projects', ...(projects.toList()..sort())];
  }

  List<_CalendarEntry> get _filteredEntries {
    return _entries.where((entry) {
      final bool matchesProgram = _selectedPrograms.contains('All') ||
          _selectedPrograms.contains(entry.program);
      final bool matchesProject = _selectedProject == 'All Projects' ||
          entry.projectTitle == _selectedProject;
      final bool matchesType = (entry.type == _CalendarEntryType.project && _showProjects) ||
          (entry.type == _CalendarEntryType.activity && _showActivities);

      return matchesProgram && matchesProject && matchesType;
    }).toList();
  }

  void _toggleProgram(String program, bool selected) {
    setState(() {
      if (program == 'All') {
        _selectedPrograms
          ..clear()
          ..add('All');
        return;
      }

      _selectedPrograms.remove('All');

      if (selected) {
        _selectedPrograms.add(program);
      } else {
        _selectedPrograms.remove(program);
      }

      if (_selectedPrograms.isEmpty) {
        _selectedPrograms.add('All');
      }
    });
  }

  void _openEntry(_CalendarEntry entry) {
    if (entry.type == _CalendarEntryType.project) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActivitiesAdminScreen(
            projectTitle: entry.projectTitle,
            projectDescription: entry.projectDescription,
            projectProgram: entry.program,
            projectProgress: entry.projectProgress,
            openedFromCalendar: true,
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivitiesAdminDetailsScreen(
          projectTitle: entry.projectTitle,
          projectDescription: entry.projectDescription,
          projectProgram: entry.program,
          projectProgress: entry.projectProgress,
          activity: ActivityAdminItem(
            title: entry.title,
            description: entry.description,
            code: entry.code,
            componentName: entry.componentName,
            program: entry.program,
            scheduleFrom: _formatDate(entry.date),
            scheduleTo: _formatDate(entry.endDate ?? entry.date),
            percent: entry.projectProgress,
            status: entry.status,
          ),
          onActivityChanged: (_) {},
          onActivityDeleted: () {},
          onBackToProjectActivities: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ActivitiesAdminScreen(
                  projectTitle: entry.projectTitle,
                  projectDescription: entry.projectDescription,
                  projectProgram: entry.program,
                  projectProgress: entry.projectProgress,
                ),
              ),
            );
          },
          openedFromCalendar: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: CalendarStyles.pageBackground,
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
                          padding: const EdgeInsets.fromLTRB(48, 28, 48, 60),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: CalendarStyles.contentMaxWidth,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildHeader(),
                                  const SizedBox(height: 28),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final bool compact = constraints.maxWidth < 1050;

                                      if (compact) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            _buildFiltersPanel(),
                                            const SizedBox(height: 18),
                                            _buildCalendarPanel(),
                                          ],
                                        );
                                      }

                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(child: _buildCalendarPanel()),
                                          const SizedBox(width: 20),
                                          SizedBox(
                                            width: 280,
                                            child: _buildFiltersPanel(),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
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
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset(
          AppAssets.matutum,
          width: double.infinity,
          fit: BoxFit.fitWidth,
          alignment: Alignment.bottomCenter,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
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
            'Calendar',
            overflow: TextOverflow.ellipsis,
            style: CalendarStyles.pageTitle,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarPanel() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: CalendarStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _monthLabel(_visibleMonth),
                  style: CalendarStyles.sectionTitle,
                ),
              ),
              _legendDot(CalendarStyles.projectColor, 'Projects'),
              const SizedBox(width: 16),
              _legendDot(CalendarStyles.activityColor, 'Activities'),
            ],
          ),
          const SizedBox(height: 18),
          _buildWeekHeader(),
          const SizedBox(height: 8),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildWeekHeader() {
    const List<String> days = <String>['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      children: days
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(day, style: CalendarStyles.dayHeader),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final List<DateTime> days = _calendarDays(_visibleMonth);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: days.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        mainAxisExtent: 118,
      ),
      itemBuilder: (context, index) {
        final DateTime day = days[index];
        final bool isCurrentMonth = day.month == _visibleMonth.month;
        final List<_CalendarEntry> dayEntries = _filteredEntries.where((entry) {
          final DateTime end = entry.endDate ?? entry.date;
          return !day.isBefore(_dateOnly(entry.date)) && !day.isAfter(_dateOnly(end));
        }).toList();

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isCurrentMonth ? 0.92 : 0.45),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: CalendarStyles.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${day.day}',
                style: isCurrentMonth
                    ? CalendarStyles.dayNumber
                    : CalendarStyles.mutedDayNumber,
              ),
              const SizedBox(height: 6),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: dayEntries.map(_calendarEventChip).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _calendarEventChip(_CalendarEntry entry) {
    final Color color = entry.type == _CalendarEntryType.project
        ? CalendarStyles.projectColor
        : CalendarStyles.activityColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Tooltip(
        message: entry.title,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _openEntry(entry),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                entry.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CalendarStyles.eventText,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: CalendarStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Filters', style: CalendarStyles.sectionTitle),
          const SizedBox(height: 18),
          Text('Program', style: CalendarStyles.filterTitle),
          const SizedBox(height: 8),
          ..._programOptions.map((program) {
            return CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: _selectedPrograms.contains(program),
              onChanged: (value) => _toggleProgram(program, value ?? false),
              activeColor: AppColors.blue,
              title: Text(program, style: CalendarStyles.filterText),
              controlAffinity: ListTileControlAffinity.leading,
            );
          }),
          const SizedBox(height: 14),
          Text('Project', style: CalendarStyles.filterTitle),
          const SizedBox(height: 8),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: CalendarStyles.controlDecoration,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _projectOptions.contains(_selectedProject)
                    ? _selectedProject
                    : 'All Projects',
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.blue,
                ),
                style: CalendarStyles.dropdownText,
                dropdownColor: Colors.white,
                items: _projectOptions
                    .map(
                      (project) => DropdownMenuItem<String>(
                        value: project,
                        child: Text(
                          project,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedProject = value);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            value: _showProjects,
            onChanged: (value) => setState(() => _showProjects = value ?? true),
            activeColor: AppColors.blue,
            title: Text('Show Projects', style: CalendarStyles.filterText),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            value: _showActivities,
            onChanged: (value) => setState(() => _showActivities = value ?? true),
            activeColor: AppColors.blue,
            title: Text('Show Activities', style: CalendarStyles.filterText),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: CalendarStyles.filterText),
      ],
    );
  }

  Widget _buildSidebar(bool isExpanded) {
    return AnimatedContainer(
      clipBehavior: Clip.hardEdge,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      width: isExpanded
          ? CalendarStyles.expandedSidebarWidth
          : CalendarStyles.sidebarWidth,
      height: double.infinity,
      decoration: CalendarStyles.sidebarDecoration,
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
              style: CalendarStyles.orgName,
            ),
            const SizedBox(height: 4),
            Text(
              '“Building Resiliency, Sustaining Development”',
              textAlign: TextAlign.center,
              style: CalendarStyles.orgTagline,
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
            onTap: () => Navigator.pushReplacementNamed(context, '/dashboard-admin'),
          ),
          _sidebarItem(
            icon: Icons.folder_open_rounded,
            label: 'Projects & Activities',
            selected: false,
            isExpanded: isExpanded,
            onTap: () => Navigator.pushReplacementNamed(context, '/projects-admin'),
          ),
          _sidebarItem(
            icon: Icons.calendar_month_rounded,
            label: 'Calendar',
            selected: true,
            isExpanded: isExpanded,
            onTap: () {},
          ),
          _sidebarItem(
            icon: Icons.person,
            label: 'Account Settings',
            selected: false,
            isExpanded: isExpanded,
            onTap: () => Navigator.pushReplacementNamed(context, '/settings-admin'),
          ),
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
                style: CalendarStyles.sidebarLabel,
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
                border: Border.all(color: const Color(0xFFCBD5E1)),
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
          color: selected ? CalendarStyles.selectedSidebar : Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: isExpanded ? 28 : 0),
          child: Row(
            mainAxisAlignment:
                isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: AppColors.blue),
              if (isExpanded) ...[
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: CalendarStyles.sidebarLabel,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
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
        Text('Developed by:', textAlign: TextAlign.center, style: labelStyle),
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

enum _CalendarEntryType { project, activity }

class _CalendarEntry {
  const _CalendarEntry({
    required this.title,
    required this.description,
    required this.program,
    required this.projectTitle,
    required this.projectDescription,
    required this.projectProgress,
    required this.status,
    required this.date,
    required this.type,
    this.endDate,
    this.code = '',
    this.componentName = '',
  });

  final String title;
  final String description;
  final String program;
  final String projectTitle;
  final String projectDescription;
  final int projectProgress;
  final String status;
  final DateTime date;
  final DateTime? endDate;
  final _CalendarEntryType type;
  final String code;
  final String componentName;
}

List<_CalendarEntry> _defaultCalendarEntries(DateTime month) {
  const List<String> programs = <String>['IBG', 'DSS', 'ENVI', 'KMI'];
  final List<_CalendarEntry> entries = <_CalendarEntry>[];

  for (int programIndex = 0; programIndex < programs.length; programIndex++) {
    final String program = programs[programIndex];

    for (int projectIndex = 1; projectIndex <= 3; projectIndex++) {
      final String projectTitle = '$program Project $projectIndex';
      final String projectDescription = _projectDescriptionFor(program);
      final int projectProgress = 35 + (programIndex * 12) + (projectIndex * 8);
      final DateTime projectStart = DateTime(
        month.year,
        month.month,
        2 + programIndex + ((projectIndex - 1) * 7),
      );

      entries.add(
        _CalendarEntry(
          title: projectTitle,
          description: projectDescription,
          program: program,
          projectTitle: projectTitle,
          projectDescription: projectDescription,
          projectProgress: projectProgress.clamp(0, 100).toInt(),
          status: _statusForProgress(projectProgress),
          date: projectStart,
          endDate: projectStart.add(const Duration(days: 2)),
          type: _CalendarEntryType.project,
        ),
      );

      for (int activityIndex = 1; activityIndex <= 2; activityIndex++) {
        final int activityProgress = (projectProgress + (activityIndex * 10)).clamp(0, 100).toInt();
        entries.add(
          _CalendarEntry(
            title: '$program Activity ${((projectIndex - 1) * 2) + activityIndex}',
            description: 'Tracks the scheduled activity outputs, field progress, and documentation updates.',
            program: program,
            projectTitle: projectTitle,
            projectDescription: projectDescription,
            projectProgress: activityProgress,
            status: _statusForProgress(activityProgress),
            date: projectStart.add(Duration(days: activityIndex * 2)),
            type: _CalendarEntryType.activity,
            code: 'A$activityIndex',
            componentName: activityIndex == 1 ? 'Field Assessment' : 'Documentation Review',
          ),
        );
      }
    }
  }

  return entries;
}

List<DateTime> _calendarDays(DateTime month) {
  final DateTime firstDay = DateTime(month.year, month.month, 1);
  final DateTime firstGridDay = firstDay.subtract(Duration(days: firstDay.weekday % 7));
  return List<DateTime>.generate(
    42,
    (index) => DateTime(firstGridDay.year, firstGridDay.month, firstGridDay.day + index),
  );
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

String _monthLabel(DateTime date) {
  const List<String> months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  return '${months[date.month - 1]} ${date.year}';
}

String _formatDate(DateTime date) {
  const List<String> months = <String>[
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

String _projectDescriptionFor(String program) {
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

String _statusForProgress(int progress) {
  if (progress >= 100) return 'Completed';
  if (progress <= 0) return 'Not Started';
  return 'In Progress';
}
