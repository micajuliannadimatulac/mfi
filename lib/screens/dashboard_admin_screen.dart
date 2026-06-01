import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../state/sidebar_state.dart';
import '../styles/app_styles.dart';
import '../styles/dashboard_styles.dart';
import '../widgets/auth_buttons.dart';
import 'activities_admin_details_screen.dart';
import 'activities_admin_screen.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  final List<String> _programs = [
    'IBG',
    'DSS',
    'ENVI',
    'KMI',
  ];

  final Map<String, List<_DashboardProject>> _programProjects = {};

  String _selectedProgram = 'IBG';
  int _selectedProjectIndex = 0;
  int _listResetVersion = 0;

  @override
  void initState() {
    super.initState();

    for (final String program in _programs) {
      _programProjects[program] = _defaultProjectsFor(program);
    }
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

  List<List<int>> _activityPercentsFor(String program) {
    switch (program.toUpperCase()) {
      case 'IBG':
        return [
          [100, 95, 90, 85, 80],
          [95, 90, 85, 80, 75],
          [90, 85, 80, 75, 70],
          [85, 80, 75, 70, 65],
          [80, 75, 70, 65, 60],
          [75, 70, 65, 60, 55],
        ];

      case 'DSS':
        return [
          [80, 75, 70, 65, 60],
          [75, 70, 65, 60, 55],
          [70, 65, 60, 55, 50],
          [60, 55, 50, 45, 40],
          [55, 50, 45, 40, 35],
          [45, 40, 35, 30, 25],
        ];

      case 'ENVI':
        return [
          [65, 55, 50, 45, 40],
          [55, 50, 45, 40, 35],
          [45, 40, 35, 30, 25],
          [35, 30, 25, 20, 15],
          [25, 20, 15, 10, 5],
          [20, 15, 10, 5, 0],
        ];

      case 'KMI':
        return [
          [95, 90, 85, 80, 75],
          [85, 80, 75, 70, 65],
          [80, 75, 70, 65, 60],
          [70, 65, 60, 55, 50],
          [60, 55, 50, 45, 40],
          [50, 45, 40, 35, 30],
        ];

      default:
        return [
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
        ];
    }
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

  List<_DashboardProject> _defaultProjectsFor(String program) {
    final List<int> projectPercents = _projectPercentsFor(program);

    return List.generate(projectPercents.length, (index) {
      final int projectNumber = index + 1;

      return _DashboardProject(
        title: '$program Project $projectNumber',
        description: _projectDescriptionFor(program, projectNumber),
        program: program,
        percent: projectPercents[index],
        activities: _defaultActivitiesFor(
          program,
          projectNumber,
        ),
      );
    });
  }

  List<_DashboardActivity> _defaultActivitiesFor(
    String program,
    int projectNumber,
  ) {
    final List<List<int>> activityPercents = _activityPercentsFor(program);

    final List<int> selectedProjectActivities =
        projectNumber <= activityPercents.length
            ? activityPercents[projectNumber - 1]
            : [0, 0, 0, 0, 0];

    return List.generate(selectedProjectActivities.length, (index) {
      final int activityNumber = index + 1;

      return _DashboardActivity(
        title: '$program Activity $activityNumber',
        description: _dashboardActivityDescriptionFor(program, activityNumber),
        code: '$program-A${activityNumber.toString().padLeft(2, '0')}',
        componentName: '$program Component $activityNumber',
        scheduleFrom: 'Jun ${activityNumber.toString().padLeft(2, '0')}, 2026',
        scheduleTo: 'Jun ${(activityNumber + 4).toString().padLeft(2, '0')}, 2026',
        percent: selectedProjectActivities[index],
      );
    });
  }

  String _dashboardActivityDescriptionFor(String program, int activityNumber) {
    switch (program.toUpperCase()) {
      case 'IBG':
        return 'Income-building task focused on enterprise support and monitoring outputs.';
      case 'DSS':
        return 'Community service task covering coordination, delivery, and field documentation.';
      case 'ENVI':
        return 'Environmental task tracking implementation, site updates, and progress evidence.';
      case 'KMI':
        return 'Knowledge management task for reports, documentation, and learning materials.';
      default:
        return 'Project activity task with tracked schedule, outputs, and progress.';
    }
  }

  List<_DashboardProject> _renameProjectsForProgram({
    required List<_DashboardProject> projects,
    required String oldProgramName,
    required String newProgramName,
  }) {
    return projects.map((project) {
      final String updatedProjectTitle =
          project.title.startsWith('$oldProgramName ')
              ? project.title.replaceFirst(oldProgramName, newProgramName)
              : project.title;

      final List<_DashboardActivity> updatedActivities =
          project.activities.map((activity) {
        final String updatedActivityTitle =
            activity.title.startsWith('$oldProgramName ')
                ? activity.title.replaceFirst(oldProgramName, newProgramName)
                : activity.title;

        return activity.copyWith(
          title: updatedActivityTitle,
        );
      }).toList();

      return project.copyWith(
        title: updatedProjectTitle,
        program: newProgramName,
        activities: updatedActivities,
      );
    }).toList();
  }

  void _selectProgram(String program) {
    setState(() {
      _selectedProgram = program;
      _selectedProjectIndex = 0;
      _listResetVersion++;
    });
  }

  void _selectProject(int index) {
    setState(() {
      _selectedProjectIndex = index;
    });
  }

  void _showManageProgramsDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _ManageProgramsDialog(
          programs: _programs,
          onProgramsChanged: (updatedPrograms) {
            setState(() {
              final List<String> oldPrograms = List<String>.from(_programs);
              final Map<String, List<_DashboardProject>> oldProjectsMap =
                  Map<String, List<_DashboardProject>>.from(_programProjects);

              final Map<String, List<_DashboardProject>> updatedProjectsMap =
                  {};

              for (int index = 0; index < updatedPrograms.length; index++) {
                final String newProgramName = updatedPrograms[index];

                if (oldProjectsMap.containsKey(newProgramName)) {
                  updatedProjectsMap[newProgramName] =
                      oldProjectsMap[newProgramName]!;
                  continue;
                }

                if (index < oldPrograms.length) {
                  final String oldProgramName = oldPrograms[index];

                  if (oldProjectsMap.containsKey(oldProgramName) &&
                      !updatedPrograms.contains(oldProgramName)) {
                    updatedProjectsMap[newProgramName] =
                        _renameProjectsForProgram(
                      projects: oldProjectsMap[oldProgramName]!,
                      oldProgramName: oldProgramName,
                      newProgramName: newProgramName,
                    );
                    continue;
                  }
                }

                updatedProjectsMap[newProgramName] = [];
              }

              _programs
                ..clear()
                ..addAll(updatedPrograms);

              _programProjects
                ..clear()
                ..addAll(updatedProjectsMap);

              if (_programs.isEmpty) {
                _selectedProgram = '';
                _selectedProjectIndex = 0;
              } else if (!_programs.contains(_selectedProgram)) {
                _selectedProgram = _programs.first;
                _selectedProjectIndex = 0;
              }
            });
          },
        );
      },
    );
  }

  void _showManageProjectsDialog() {
    if (_selectedProgram.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _ManageProjectsDialog(
          program: _selectedProgram,
          programs: _programs,
          projects: _currentProjects,
          onProjectsChanged: (updatedProjects) {
            setState(() {
              _programProjects[_selectedProgram] = updatedProjects;

              if (updatedProjects.isEmpty) {
                _selectedProjectIndex = 0;
              } else if (_selectedProjectIndex >= updatedProjects.length) {
                _selectedProjectIndex = updatedProjects.length - 1;
              }
            });
          },
        );
      },
    );
  }

  void _showManageActivitiesDialog() {
    if (_selectedProgram.isEmpty || _currentProjects.isEmpty) {
      return;
    }

    if (_selectedProjectIndex >= _currentProjects.length) {
      return;
    }

    final _DashboardProject selectedProject =
        _currentProjects[_selectedProjectIndex];

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _ManageActivitiesDialog(
          project: selectedProject,
          activities: selectedProject.activities,
          onActivitiesChanged: (updatedActivities) {
            setState(() {
              final List<_DashboardProject> projects =
                  List<_DashboardProject>.from(_currentProjects);

              if (_selectedProjectIndex < projects.length) {
                projects[_selectedProjectIndex] =
                    projects[_selectedProjectIndex].copyWith(
                  activities: updatedActivities,
                );

                _programProjects[_selectedProgram] = projects;
              }
            });
          },
        );
      },
    );
  }


  String _statusLabelForPercent(int percent) {
    if (percent >= 100) {
      return 'Completed';
    }

    if (percent <= 0) {
      return 'Not Started';
    }

    return 'In Progress';
  }

  void _openActivityDetails(_DashboardActivity activity) {
    final List<_DashboardProject> projects = _currentProjects;

    if (projects.isEmpty || _selectedProjectIndex >= projects.length) {
      return;
    }

    final _DashboardProject selectedProject = projects[_selectedProjectIndex];
    final int activityIndexAtOpen = selectedProject.activities.indexOf(activity);

    if (activityIndexAtOpen == -1) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ActivitiesAdminDetailsScreen(
            projectTitle: selectedProject.title,
            projectDescription: selectedProject.description,
            projectProgram: selectedProject.program,
            projectProgress: selectedProject.percent,
            activity: ActivityAdminItem(
              title: activity.title,
              description: activity.description,
              code: activity.code,
              componentName: activity.componentName,
              program: selectedProject.program,
              scheduleFrom: activity.scheduleFrom,
              scheduleTo: activity.scheduleTo,
              percent: activity.percent,
              status: _statusLabelForPercent(activity.percent),
            ),
            onActivityChanged: (updatedActivity) {
              setState(() {
                final List<_DashboardProject> updatedProjects =
                    List<_DashboardProject>.from(_currentProjects);

                if (_selectedProjectIndex >= updatedProjects.length) {
                  return;
                }

                final _DashboardProject project =
                    updatedProjects[_selectedProjectIndex];
                final List<_DashboardActivity> updatedActivities =
                    List<_DashboardActivity>.from(project.activities);

                if (activityIndexAtOpen >= updatedActivities.length) {
                  return;
                }

                updatedActivities[activityIndexAtOpen] = activity.copyWith(
                  title: updatedActivity.title,
                  description: updatedActivity.description,
                  code: updatedActivity.code,
                  componentName: updatedActivity.componentName,
                  scheduleFrom: updatedActivity.scheduleFrom,
                  scheduleTo: updatedActivity.scheduleTo,
                  percent: updatedActivity.percent,
                );

                updatedProjects[_selectedProjectIndex] = project.copyWith(
                  activities: updatedActivities,
                );
                _programProjects[_selectedProgram] = updatedProjects;
              });
            },
            onActivityDeleted: () {
              setState(() {
                final List<_DashboardProject> updatedProjects =
                    List<_DashboardProject>.from(_currentProjects);

                if (_selectedProjectIndex >= updatedProjects.length) {
                  return;
                }

                final _DashboardProject project =
                    updatedProjects[_selectedProjectIndex];
                final List<_DashboardActivity> updatedActivities =
                    List<_DashboardActivity>.from(project.activities);

                if (activityIndexAtOpen >= updatedActivities.length) {
                  return;
                }

                updatedActivities.removeAt(activityIndexAtOpen);

                updatedProjects[_selectedProjectIndex] = project.copyWith(
                  activities: updatedActivities,
                );
                _programProjects[_selectedProgram] = updatedProjects;
              });
            },
            onBackToProjectActivities: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ActivitiesAdminScreen(
                      projectTitle: selectedProject.title,
                      projectDescription: selectedProject.description,
                      projectProgram: selectedProject.program,
                      projectProgress: selectedProject.percent,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<_DashboardProject> get _currentProjects {
    if (_selectedProgram.isEmpty) {
      return [];
    }

    return _programProjects[_selectedProgram] ?? [];
  }

  List<_DashboardActivity> get _currentActivities {
    final List<_DashboardProject> projects = _currentProjects;

    if (projects.isEmpty || _selectedProjectIndex >= projects.length) {
      return [];
    }

    return projects[_selectedProjectIndex].activities;
  }

  double get _completionPercent {
    final List<_DashboardProject> projects = _currentProjects;

    if (projects.isEmpty) {
      return 0;
    }

    final double total = projects.fold<double>(
      0,
      (sum, project) => sum + project.percent,
    );

    return total / projects.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: DashboardStyles.pageBackground,
        child: ValueListenableBuilder<bool>(
          valueListenable: SidebarState.isExpanded,
          builder: (context, isExpanded, child) {
            return Row(
              children: [
                _DashboardSidebar(
                  isExpanded: isExpanded,
                  onToggle: SidebarState.toggle,
                ),
                Expanded(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(58, 28, 50, 60),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: DashboardStyles.contentMaxWidth,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _DashboardHeader(),
                              const SizedBox(height: 28),
                              const _HeroCard(),
                              const SizedBox(height: 40),
                              const _OverviewTitle(),
                              const SizedBox(height: 28),
                              _ProgramActionRow(
                                programs: _programs,
                                selectedProgram: _selectedProgram,
                                onProgramSelected: _selectProgram,
                                onManagePressed: _showManageProgramsDialog,
                              ),
                              const SizedBox(height: 30),
                              _OverviewCards(
                                selectedProgram: _selectedProgram,
                                completionPercent: _completionPercent,
                              ),
                              const SizedBox(height: 32),
                              _ProjectsPanel(
                                selectedProgram: _selectedProgram,
                                selectedProjectIndex: _selectedProjectIndex,
                                projects: _currentProjects,
                                activities: _currentActivities,
                                resetVersion: _listResetVersion,
                                onProjectSelected: _selectProject,
                                onActivitySelected: _openActivityDetails,
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
      ),
    );
  }
}

class _DashboardProject {
  const _DashboardProject({
    required this.title,
    required this.description,
    required this.program,
    required this.percent,
    required this.activities,
  });

  final String title;
  final String description;
  final String program;
  final int percent;
  final List<_DashboardActivity> activities;

  _DashboardProject copyWith({
    String? title,
    String? description,
    String? program,
    int? percent,
    List<_DashboardActivity>? activities,
  }) {
    return _DashboardProject(
      title: title ?? this.title,
      description: description ?? this.description,
      program: program ?? this.program,
      percent: percent ?? this.percent,
      activities: activities ?? this.activities,
    );
  }
}

class _DashboardActivity {
  const _DashboardActivity({
    required this.title,
    required this.description,
    required this.percent,
    this.code = '',
    this.componentName = 'General Component',
    this.scheduleFrom = 'Not set',
    this.scheduleTo = 'Not set',
  });

  final String title;
  final String description;
  final String code;
  final String componentName;
  final String scheduleFrom;
  final String scheduleTo;
  final int percent;

  _DashboardActivity copyWith({
    String? title,
    String? description,
    String? code,
    String? componentName,
    String? scheduleFrom,
    String? scheduleTo,
    int? percent,
  }) {
    return _DashboardActivity(
      title: title ?? this.title,
      description: description ?? this.description,
      code: code ?? this.code,
      componentName: componentName ?? this.componentName,
      scheduleFrom: scheduleFrom ?? this.scheduleFrom,
      scheduleTo: scheduleTo ?? this.scheduleTo,
      percent: percent ?? this.percent,
    );
  }
}

class _DashboardSidebar extends StatelessWidget {
  const _DashboardSidebar({
    required this.isExpanded,
    required this.onToggle,
  });

  final bool isExpanded;
  final VoidCallback onToggle;

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

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      clipBehavior: Clip.hardEdge,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      width: isExpanded
          ? DashboardStyles.expandedSidebarWidth
          : DashboardStyles.sidebarWidth,
      height: double.infinity,
      decoration: DashboardStyles.sidebarDecoration,
      child: Column(
        children: [
          const SizedBox(height: 24),
          if (isExpanded)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 22),
                child: _MenuButton(onTap: onToggle),
              ),
            )
          else
            Center(
              child: _MenuButton(onTap: onToggle),
            ),
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
              style: AppText.calSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '“Building Resiliency, Sustaining Development”',
              textAlign: TextAlign.center,
              style: AppText.dmSans(
                fontSize: 7,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(height: 44),
          ] else ...[
            const SizedBox(height: 126),
          ],
          _SidebarItem(
            icon: Icons.grid_view_rounded,
            label: 'Dashboard',
            isExpanded: isExpanded,
            selected: true,
            onTap: () {},
          ),
          _SidebarItem(
            icon: Icons.folder_open_rounded,
            label: 'Projects',
            isExpanded: isExpanded,
            selected: false,
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                '/projects-admin',
              );
            },
          ),
          _SidebarItem(
            icon: Icons.person,
            label: 'Account Settings',
            isExpanded: isExpanded,
            selected: false,
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                '/settings-admin',
              );
            },
          ),
          _SidebarThemeToggle(isExpanded: isExpanded),
          _SidebarItem(
            icon: Icons.logout_rounded,
            label: 'Log Out',
            isExpanded: isExpanded,
            selected: false,
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
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: const Icon(
          Icons.menu_rounded,
          size: 34,
          color: AppColors.blue,
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isExpanded,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isExpanded;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 78,
          color: selected ? const Color(0xFFD9D9D9) : Colors.transparent,
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
                    style: AppText.calSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
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


class _SidebarThemeToggle extends StatelessWidget {
  const _SidebarThemeToggle({
    required this.isExpanded,
  });

  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
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
                style: AppText.calSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const _SidebarToggleSwitch(),
          ],
        ],
      ),
    );
  }
}

class _SidebarToggleSwitch extends StatelessWidget {
  const _SidebarToggleSwitch();

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          AppAssets.logo,
          width: 56,
          height: 56,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 14),
        Text(
          'Dashboard',
          style: DashboardStyles.dashboardTitle,
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 262,
      decoration: DashboardStyles.cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/matutum2.png',
              fit: BoxFit.cover,
              alignment: const Alignment(0.55, 0.85),
            ),
          ),
          Positioned(
            left: 42,
            top: 36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Mica Julianna!',
                  style: DashboardStyles.heroName,
                ),
                const SizedBox(height: 12),
                Text(
                  'Knowledge Management Information\nOJT Intern',
                  style: DashboardStyles.heroSubtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewTitle extends StatelessWidget {
  const _OverviewTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Overview',
      style: DashboardStyles.sectionTitle,
    );
  }
}

class _ProgramActionRow extends StatelessWidget {
  const _ProgramActionRow({
    required this.programs,
    required this.selectedProgram,
    required this.onProgramSelected,
    required this.onManagePressed,
  });

  final List<String> programs;
  final String selectedProgram;
  final ValueChanged<String> onProgramSelected;
  final VoidCallback onManagePressed;

  double _buttonWidth(String text) {
    if (text.length <= 3) {
      return 68;
    }

    if (text.length <= 4) {
      return 76;
    }

    if (text.length <= 8) {
      return 100;
    }

    return 130;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: programs.isEmpty
              ? Text(
                  'No programs available.',
                  style: AppText.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue,
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int index = 0; index < programs.length; index++) ...[
                        if (index != 0) const SizedBox(width: 14),
                        _DashboardButton(
                          text: programs[index],
                          width: _buttonWidth(programs[index]),
                          filled: selectedProgram == programs[index],
                          onTap: () {
                            onProgramSelected(programs[index]);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
        ),
        const SizedBox(width: 18),
        _DashboardButton(
          text: 'Manage Programs',
          width: 170,
          filled: true,
          onTap: onManagePressed,
        ),
      ],
    );
  }
}

class _DashboardButton extends StatelessWidget {
  const _DashboardButton({
    required this.text,
    required this.width,
    required this.onTap,
    this.filled = false,
  });

  final String text;
  final double width;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return AuthButton(
      text: text,
      width: width,
      height: 32,
      type: filled
          ? AuthButtonType.dashboardFilled
          : AuthButtonType.dashboardOutline,
      onTap: onTap,
      textStyle: filled ? DashboardStyles.buttonText : DashboardStyles.chipText,
    );
  }
}

enum _DashboardSortOrder {
  az,
  za,
  highToLow,
  lowToHigh,
}

enum _NameSortOrder {
  az,
  za,
}

class _ManageProgramsDialog extends StatefulWidget {
  const _ManageProgramsDialog({
    required this.programs,
    required this.onProgramsChanged,
  });

  final List<String> programs;
  final ValueChanged<List<String>> onProgramsChanged;

  @override
  State<_ManageProgramsDialog> createState() => _ManageProgramsDialogState();
}

class _ManageProgramsDialogState extends State<_ManageProgramsDialog> {
  late final TextEditingController _searchController;
  late List<String> _localPrograms;

  String _searchQuery = '';
  _NameSortOrder _sortOrder = _NameSortOrder.az;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _localPrograms = List<String>.from(widget.programs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _filteredPrograms {
    final String query = _searchQuery.trim().toLowerCase();
    final List<String> filtered = _localPrograms.where((program) {
      return query.isEmpty || program.toLowerCase().contains(query);
    }).toList();

    filtered.sort((a, b) {
      final int result = a.toLowerCase().compareTo(b.toLowerCase());
      return _sortOrder == _NameSortOrder.az ? result : -result;
    });

    return filtered;
  }

  Future<void> _addProgram() async {
    final String? programName = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return const _NameDialog(
          title: 'Add Program',
          label: 'Program Name*',
          buttonText: 'Add',
        );
      },
    );

    if (programName == null || programName.trim().isEmpty) {
      return;
    }

    setState(() {
      _localPrograms.add(programName.trim());
    });
  }

  Future<void> _editProgram(String oldName) async {
    final String? newName = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _NameDialog(
          title: 'Edit Program',
          label: 'Program Name*',
          buttonText: 'Save',
          initialValue: oldName,
        );
      },
    );

    if (newName == null || newName.trim().isEmpty) {
      return;
    }

    setState(() {
      final int index = _localPrograms.indexOf(oldName);

      if (index != -1) {
        _localPrograms[index] = newName.trim();
      }
    });
  }

  void _deleteProgram(String programName) {
    setState(() {
      _localPrograms.remove(programName);
    });
  }

  void _savePrograms() {
    widget.onProgramsChanged(List<String>.from(_localPrograms));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
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
                'Manage Programs',
                textAlign: TextAlign.center,
                style: AppText.calSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 24),
              _buildProgramControls(),
              const SizedBox(height: 16),
              Flexible(
                child: _buildProgramList(),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthButton(
                    text: 'Cancel',
                    width: 115,
                    height: 44,
                    type: AuthButtonType.dashboardOutline,
                    onTap: () => Navigator.pop(context),
                    textStyle: AppText.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(width: 24),
                  AuthButton(
                    text: 'Save',
                    width: 115,
                    height: 44,
                    type: AuthButtonType.dashboardFilled,
                    onTap: _savePrograms,
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

  Widget _buildProgramControls() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compact = constraints.maxWidth < 650;

        final Widget search = SizedBox(
          height: 44,
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            style: AppText.dmSans(
              fontSize: 14,
              color: AppColors.blue,
            ),
            decoration: InputDecoration(
              hintText: 'Search programs',
              hintStyle: AppText.dmSans(
                fontSize: 14,
                color: AppColors.placeholderGray,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.blue,
                size: 22,
              ),
              filled: true,
              fillColor: AppColors.softGray,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
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
            ),
          ),
        );

        final Widget sort = SizedBox(
          height: 44,
          child: DropdownButtonFormField<_NameSortOrder>(
            value: _sortOrder,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.softGray,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 0,
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
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.blue,
            ),
            isExpanded: true,
            style: AppText.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
            ),
            items: const [
              DropdownMenuItem(
                value: _NameSortOrder.az,
                child: Text('A-Z'),
              ),
              DropdownMenuItem(
                value: _NameSortOrder.za,
                child: Text('Z-A'),
              ),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                _sortOrder = value;
              });
            },
          ),
        );

        final Widget addButton = AuthButton(
          text: '+ Add Program',
          width: 150,
          height: 44,
          type: AuthButtonType.dashboardFilled,
          onTap: _addProgram,
          textStyle: AppText.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              search,
              const SizedBox(height: 12),
              sort,
              const SizedBox(height: 12),
              addButton,
            ],
          );
        }

        return Row(
          children: [
            Expanded(flex: 2, child: search),
            const SizedBox(width: 12),
            SizedBox(width: 120, child: sort),
            const SizedBox(width: 12),
            addButton,
          ],
        );
      },
    );
  }

  Widget _buildProgramList() {
    final List<String> programs = _filteredPrograms;

    if (programs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.blue.withOpacity(0.10),
          ),
        ),
        child: Text(
          'No programs found.',
          style: AppText.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.placeholderGray,
          ),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 380),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.blue.withOpacity(0.10),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: programs.map((program) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.blue.withOpacity(0.08),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Program',
                      style: AppText.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      program,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blue,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Edit program',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.blue,
                      size: 20,
                    ),
                    onPressed: () => _editProgram(program),
                  ),
                  IconButton(
                    tooltip: 'Delete program',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFD64545),
                      size: 20,
                    ),
                    onPressed: () => _deleteProgram(program),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ManageProjectsDialog extends StatefulWidget {
  const _ManageProjectsDialog({
    required this.program,
    required this.programs,
    required this.projects,
    required this.onProjectsChanged,
  });

  final String program;
  final List<String> programs;
  final List<_DashboardProject> projects;
  final ValueChanged<List<_DashboardProject>> onProjectsChanged;

  @override
  State<_ManageProjectsDialog> createState() => _ManageProjectsDialogState();
}

class _ManageProjectsDialogState extends State<_ManageProjectsDialog> {
  late List<_DashboardProject> _localProjects;

  @override
  void initState() {
    super.initState();

    _localProjects = List<_DashboardProject>.from(widget.projects);
  }

  void _syncDashboardProjects() {
    widget.onProjectsChanged(List<_DashboardProject>.from(_localProjects));
  }

  Future<void> _addProject() async {
    final _ProjectDraft? draft = await showDialog<_ProjectDraft>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _ProjectDetailsDialog(
          title: 'Add Project',
          buttonText: 'Add',
          programs: widget.program.isEmpty ? widget.programs : [widget.program],
          initialProgram: widget.program,
        );
      },
    );

    if (draft == null || draft.title.trim().isEmpty) {
      return;
    }

    setState(() {
      _localProjects.add(
        _DashboardProject(
          title: draft.title.trim(),
          description: draft.description.trim().isEmpty
              ? 'No description added yet.'
              : draft.description.trim(),
          program: draft.program,
          percent: 0,
          activities: const [],
        ),
      );
    });

    _syncDashboardProjects();
  }

  Future<void> _editProject(_DashboardProject oldProject) async {
    final _ProjectDraft? draft = await showDialog<_ProjectDraft>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _ProjectDetailsDialog(
          title: 'Edit Project',
          buttonText: 'Save',
          programs: widget.program.isEmpty ? widget.programs : [widget.program],
          initialTitle: oldProject.title,
          initialDescription: oldProject.description,
          initialProgram: oldProject.program.isEmpty
              ? widget.program
              : oldProject.program,
        );
      },
    );

    if (draft == null || draft.title.trim().isEmpty) {
      return;
    }

    setState(() {
      final int index = _localProjects.indexOf(oldProject);

      if (index != -1) {
        _localProjects[index] = oldProject.copyWith(
          title: draft.title.trim(),
          description: draft.description.trim().isEmpty
              ? 'No description added yet.'
              : draft.description.trim(),
          program: draft.program,
        );
      }
    });

    _syncDashboardProjects();
  }

  void _deleteProject(_DashboardProject project) {
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
        _localProjects.remove(project);
      });

      _syncDashboardProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ManageListDialog<_DashboardProject>(
      title: 'Manage Projects',
      sectionTitle: 'Projects',
      searchHint: 'Search project',
      addButtonText: '+ Add Project',
      items: _localProjects,
      getTitle: (project) => project.title,
      onAdd: _addProject,
      onEdit: _editProject,
      onDelete: _deleteProject,
    );
  }
}

class _ManageActivitiesDialog extends StatefulWidget {
  const _ManageActivitiesDialog({
    required this.project,
    required this.activities,
    required this.onActivitiesChanged,
  });

  final _DashboardProject project;
  final List<_DashboardActivity> activities;
  final ValueChanged<List<_DashboardActivity>> onActivitiesChanged;

  @override
  State<_ManageActivitiesDialog> createState() =>
      _ManageActivitiesDialogState();
}

class _ManageActivitiesDialogState extends State<_ManageActivitiesDialog> {
  late List<_DashboardActivity> _localActivities;

  @override
  void initState() {
    super.initState();

    _localActivities = List<_DashboardActivity>.from(widget.activities);
  }

  void _syncDashboardActivities() {
    widget.onActivitiesChanged(
      List<_DashboardActivity>.from(_localActivities),
    );
  }

  List<String> get _componentOptions {
    final List<String> components = _localActivities
        .map((activity) => activity.componentName.trim())
        .where((component) => component.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return components.isEmpty ? ['General Component'] : components;
  }

  Future<void> _addActivity() async {
    final _DashboardActivityDraft? draft =
        await showDialog<_DashboardActivityDraft>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _DashboardActivityDetailsDialog(
          title: 'Add Activity',
          buttonText: 'Add',
          components: _componentOptions,
        );
      },
    );

    if (draft == null || draft.title.trim().isEmpty) {
      return;
    }

    final int nextIndex = _localActivities.length + 1;

    setState(() {
      _localActivities.add(
        _DashboardActivity(
          title: draft.title.trim(),
          description: draft.description.trim().isEmpty
              ? 'No description added yet.'
              : draft.description.trim(),
          code: draft.code.trim().isEmpty
              ? '${widget.project.program}-A${nextIndex.toString().padLeft(2, '0')}'
              : draft.code.trim(),
          componentName: draft.componentName.trim().isEmpty
              ? 'General Component'
              : draft.componentName.trim(),
          scheduleFrom: draft.scheduleFrom.trim().isEmpty
              ? 'Not set'
              : draft.scheduleFrom.trim(),
          scheduleTo: draft.scheduleTo.trim().isEmpty
              ? 'Not set'
              : draft.scheduleTo.trim(),
          percent: 0,
        ),
      );
    });

    _syncDashboardActivities();
  }

  Future<void> _editActivity(_DashboardActivity oldActivity) async {
    final _DashboardActivityDraft? draft =
        await showDialog<_DashboardActivityDraft>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _DashboardActivityDetailsDialog(
          title: 'Edit Activity',
          buttonText: 'Save',
          components: _componentOptions,
          initialActivity: oldActivity,
        );
      },
    );

    if (draft == null || draft.title.trim().isEmpty) {
      return;
    }

    setState(() {
      final int index = _localActivities.indexOf(oldActivity);

      if (index != -1) {
        _localActivities[index] = oldActivity.copyWith(
          title: draft.title.trim(),
          description: draft.description.trim().isEmpty
              ? 'No description added yet.'
              : draft.description.trim(),
          code: draft.code.trim(),
          componentName: draft.componentName.trim().isEmpty
              ? 'General Component'
              : draft.componentName.trim(),
          scheduleFrom: draft.scheduleFrom.trim().isEmpty
              ? 'Not set'
              : draft.scheduleFrom.trim(),
          scheduleTo: draft.scheduleTo.trim().isEmpty
              ? 'Not set'
              : draft.scheduleTo.trim(),
        );
      }
    });

    _syncDashboardActivities();
  }

  void _deleteActivity(_DashboardActivity activity) {
    setState(() {
      _localActivities.remove(activity);
    });

    _syncDashboardActivities();
  }

  @override
  Widget build(BuildContext context) {
    return _ManageListDialog<_DashboardActivity>(
      title: 'Manage Activities',
      sectionTitle: 'Activities',
      searchHint: 'Search activity',
      addButtonText: '+ Add Activity',
      items: _localActivities,
      getTitle: (activity) => activity.title,
      onAdd: _addActivity,
      onEdit: _editActivity,
      onDelete: _deleteActivity,
    );
  }
}


class _DashboardActivityDraft {
  const _DashboardActivityDraft({
    required this.title,
    required this.description,
    required this.code,
    required this.componentName,
    required this.scheduleFrom,
    required this.scheduleTo,
  });

  final String title;
  final String description;
  final String code;
  final String componentName;
  final String scheduleFrom;
  final String scheduleTo;
}

class _DashboardActivityDetailsDialog extends StatefulWidget {
  const _DashboardActivityDetailsDialog({
    required this.title,
    required this.buttonText,
    required this.components,
    this.initialActivity,
  });

  final String title;
  final String buttonText;
  final List<String> components;
  final _DashboardActivity? initialActivity;

  @override
  State<_DashboardActivityDetailsDialog> createState() =>
      _DashboardActivityDetailsDialogState();
}

class _DashboardActivityDetailsDialogState
    extends State<_DashboardActivityDetailsDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _codeController;
  late final TextEditingController _scheduleFromController;
  late final TextEditingController _scheduleToController;
  late String _selectedComponentName;

  @override
  void initState() {
    super.initState();

    final _DashboardActivity? initialActivity = widget.initialActivity;
    final List<String> components = widget.components.isEmpty
        ? ['General Component']
        : widget.components;

    _titleController = TextEditingController(
      text: initialActivity?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: initialActivity?.description ?? '',
    );
    _codeController = TextEditingController(
      text: initialActivity?.code ?? '',
    );
    _scheduleFromController = TextEditingController(
      text: initialActivity?.scheduleFrom ?? '',
    );
    _scheduleToController = TextEditingController(
      text: initialActivity?.scheduleTo ?? '',
    );

    final String initialComponent = initialActivity?.componentName ?? '';
    _selectedComponentName = components.contains(initialComponent)
        ? initialComponent
        : components.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    _scheduleFromController.dispose();
    _scheduleToController.dispose();
    super.dispose();
  }

  void _submit() {
    final String title = _titleController.text.trim();

    if (title.isEmpty) {
      return;
    }

    Navigator.pop(
      context,
      _DashboardActivityDraft(
        title: title,
        description: _descriptionController.text.trim(),
        code: _codeController.text.trim(),
        componentName: _selectedComponentName.trim(),
        scheduleFrom: _scheduleFromController.text.trim(),
        scheduleTo: _scheduleToController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Container(
          padding: const EdgeInsets.fromLTRB(40, 38, 40, 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: AppShadows.card,
          ),
          child: SingleChildScrollView(
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
                _dialogField(
                  label: 'Activity Name*',
                  controller: _titleController,
                  hintText: 'Courtesy Visits',
                ),
                const SizedBox(height: 16),
                _dialogField(
                  label: 'Description',
                  controller: _descriptionController,
                  maxLines: 3,
                  height: 84,
                  hintText: 'Add a short activity description',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _dialogField(
                        label: 'Code',
                        controller: _codeController,
                        hintText: '1.0, A1, etc.',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _componentDropdown()),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _dialogField(
                        label: 'Schedule From',
                        controller: _scheduleFromController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _dialogField(
                        label: 'Schedule To',
                        controller: _scheduleToController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _fixedTargetPanel(),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthButton(
                      text: 'Cancel',
                      width: 115,
                      height: 44,
                      type: AuthButtonType.dashboardOutline,
                      onTap: () => Navigator.pop(context),
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
      ),
    );
  }

  Widget _componentDropdown() {
    final List<String> components = widget.components.isEmpty
        ? ['General Component']
        : widget.components;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dialogLabel('Select Component Name'),
        const SizedBox(height: 8),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.softGray,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.borderGray,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedComponentName,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.blue,
              ),
              isExpanded: true,
              style: AppText.dmSans(
                fontSize: 15,
                color: AppColors.blue,
              ),
              dropdownColor: Colors.white,
              items: components.map((component) {
                return DropdownMenuItem<String>(
                  value: component,
                  child: Text(
                    component,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _selectedComponentName = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _fixedTargetPanel() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softGray,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.borderGray,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 20,
            color: AppColors.blue,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Target/Indicators: Fixed',
              style: AppText.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    int maxLines = 1,
    double height = 46,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dialogLabel(label),
        const SizedBox(height: 8),
        SizedBox(
          height: height,
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: AppText.dmSans(
              fontSize: 15,
              color: AppColors.blue,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppText.dmSans(
                fontSize: 14,
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
            ),
          ),
        ),
      ],
    );
  }

  Widget _dialogLabel(String label) {
    return Text(
      label,
      style: AppText.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.blue,
      ),
    );
  }
}

class _ManageListDialog<T> extends StatefulWidget {
  const _ManageListDialog({
    required this.title,
    required this.sectionTitle,
    required this.searchHint,
    required this.addButtonText,
    required this.items,
    required this.getTitle,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final String sectionTitle;
  final String searchHint;
  final String addButtonText;
  final List<T> items;
  final String Function(T item) getTitle;
  final VoidCallback onAdd;
  final ValueChanged<T> onEdit;
  final ValueChanged<T> onDelete;

  @override
  State<_ManageListDialog<T>> createState() => _ManageListDialogState<T>();
}

class _ManageListDialogState<T> extends State<_ManageListDialog<T>> {
  final TextEditingController _searchController = TextEditingController();

  _NameSortOrder _sortOrder = _NameSortOrder.az;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<T> get _filteredItems {
    final String searchText = _searchController.text.trim().toLowerCase();

    final List<T> filtered = widget.items.where((item) {
      return widget.getTitle(item).toLowerCase().contains(searchText);
    }).toList();

    filtered.sort((a, b) {
      final int result = widget
          .getTitle(a)
          .toLowerCase()
          .compareTo(widget.getTitle(b).toLowerCase());

      return _sortOrder == _NameSortOrder.az ? result : -result;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final List<T> items = _filteredItems;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 760,
        ),
        child: Container(
          height: 560,
          padding: const EdgeInsets.fromLTRB(36, 34, 36, 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: AppText.calSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) {
                          setState(() {});
                        },
                        style: AppText.dmSans(
                          fontSize: 14,
                          color: AppColors.blue,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.searchHint,
                          hintStyle: AppText.dmSans(
                            fontSize: 14,
                            color: AppColors.placeholderGray,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.blue,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: AppColors.softGray,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
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
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.softGray,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.borderGray,
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<_NameSortOrder>(
                        value: _sortOrder,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.blue,
                        ),
                        style: AppText.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blue,
                        ),
                        dropdownColor: Colors.white,
                        items: const [
                          DropdownMenuItem(
                            value: _NameSortOrder.az,
                            child: Text('A-Z'),
                          ),
                          DropdownMenuItem(
                            value: _NameSortOrder.za,
                            child: Text('Z-A'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            _sortOrder = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    widget.sectionTitle,
                    style: AppText.calSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                  const Spacer(),
                  AuthButton(
                    text: widget.addButtonText,
                    width: 150,
                    height: 38,
                    type: AuthButtonType.dashboardFilled,
                    onTap: widget.onAdd,
                    textStyle: AppText.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'No items found.',
                          style: AppText.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.placeholderGray,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 12);
                        },
                        itemBuilder: (context, index) {
                          final T item = items[index];

                          return _ManageRow(
                            title: widget.getTitle(item),
                            onEdit: () => widget.onEdit(item),
                            onDelete: () => widget.onDelete(item),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: AuthButton(
                  text: 'Close',
                  width: 120,
                  height: 42,
                  type: AuthButtonType.dashboardOutline,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  textStyle: AppText.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManageRow extends StatelessWidget {
  const _ManageRow({
    required this.title,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: DashboardStyles.lightPanel,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: AppText.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.blue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _ProgramActionTextButton(
            text: 'Edit',
            icon: Icons.edit_outlined,
            onTap: onEdit,
          ),
          const SizedBox(width: 10),
          _ProgramActionTextButton(
            text: 'Delete',
            icon: Icons.delete_outline_rounded,
            onTap: onDelete,
            isDelete: true,
          ),
        ],
      ),
    );
  }
}

class _ProgramActionTextButton extends StatefulWidget {
  const _ProgramActionTextButton({
    required this.text,
    required this.icon,
    required this.onTap,
    this.isDelete = false,
  });

  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDelete;

  @override
  State<_ProgramActionTextButton> createState() =>
      _ProgramActionTextButtonState();
}

class _ProgramActionTextButtonState extends State<_ProgramActionTextButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Color color =
        widget.isDelete ? const Color(0xFFC43030) : AppColors.blue;

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
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 160),
          opacity: _hovered ? 0.7 : 1,
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 17,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                widget.text,
                style: AppText.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _ProjectDraft {
  const _ProjectDraft({
    required this.title,
    required this.description,
    required this.program,
  });

  final String title;
  final String description;
  final String program;
}

class _ProjectDetailsDialog extends StatefulWidget {
  const _ProjectDetailsDialog({
    required this.title,
    required this.buttonText,
    required this.programs,
    required this.initialProgram,
    this.initialTitle = '',
    this.initialDescription = '',
  });

  final String title;
  final String buttonText;
  final List<String> programs;
  final String initialProgram;
  final String initialTitle;
  final String initialDescription;

  @override
  State<_ProjectDetailsDialog> createState() => _ProjectDetailsDialogState();
}

class _ProjectDetailsDialogState extends State<_ProjectDetailsDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late String _selectedProgram;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(
      text: widget.initialDescription,
    );
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

    if (title.isEmpty || _selectedProgram.isEmpty) {
      return;
    }

    Navigator.pop(
      context,
      _ProjectDraft(
        title: title,
        description: _descriptionController.text.trim(),
        program: _selectedProgram,
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
              _fieldLabel('Program*'),
              const SizedBox(height: 8),
              Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.softGray,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.borderGray,
                    width: 1,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedProgram,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.blue,
                    ),
                    style: AppText.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue,
                    ),
                    dropdownColor: Colors.white,
                    items: widget.programs
                        .map(
                          (program) => DropdownMenuItem<String>(
                            value: program,
                            child: Text(program),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        _selectedProgram = value;
                      });
                    },
                  ),
                ),
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

class _NameDialog extends StatefulWidget {
  const _NameDialog({
    required this.title,
    required this.label,
    required this.buttonText,
    this.initialValue = '',
  });

  final String title;
  final String label;
  final String buttonText;
  final String initialValue;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.initialValue,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final String name = _nameController.text.trim();

    if (name.isEmpty) {
      return;
    }

    Navigator.pop(context, name);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 520,
        ),
        child: Container(
          height: 300,
          padding: const EdgeInsets.fromLTRB(40, 38, 40, 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: AppShadows.card,
          ),
          child: Column(
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
              Text(
                widget.label,
                style: AppText.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 46,
                child: TextField(
                  controller: _nameController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  style: AppText.dmSans(
                    fontSize: 15,
                    color: AppColors.blue,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.softGray,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
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
                  ),
                ),
              ),
              const Spacer(),
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
}

class _OverviewCards extends StatelessWidget {
  const _OverviewCards({
    required this.selectedProgram,
    required this.completionPercent,
  });

  final String selectedProgram;
  final double completionPercent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: _CalendarCard(),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _CompletionCard(
            selectedProgram: selectedProgram,
            completionPercent: completionPercent,
          ),
        ),
      ],
    );
  }
}

class _CompletionCard extends StatelessWidget {
  const _CompletionCard({
    required this.selectedProgram,
    required this.completionPercent,
  });

  final String selectedProgram;
  final double completionPercent;

  @override
  Widget build(BuildContext context) {
    final Color progressColor = DashboardStyles.progressColor(
      completionPercent,
    );

    return Container(
      height: 420,
      decoration: DashboardStyles.cardDecoration,
      padding: const EdgeInsets.symmetric(vertical: 34),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: _DonutChart(
                percent: completionPercent,
                color: progressColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            selectedProgram.isEmpty
                ? 'No Program'
                : 'Total $selectedProgram Progress',
            style: DashboardStyles.cardTitle,
          ),
          const SizedBox(height: 20),
          _DashboardButton(
            text: 'See Program',
            width: 126,
            filled: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _DonutChart extends StatelessWidget {
  const _DonutChart({
    required this.percent,
    required this.color,
  });

  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double clampedPercent = percent.clamp(0, 100).toDouble();

    return SizedBox(
      width: 255,
      height: 255,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(255, 255),
            painter: _DonutPainter(
              percent: clampedPercent,
              color: color,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Completed',
                style: AppText.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),
              ),
              Text(
                '${clampedPercent.toInt()}%',
                style: AppText.calSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({
    required this.percent,
    required this.color,
  });

  final double percent;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 26;
    final Offset center = size.center(Offset.zero);
    final double radius = (size.width - strokeWidth) / 2;

    final Paint basePaint = Paint()
      ..color = const Color(0xFFF4F4F4)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Paint progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    final double clampedPercent = percent.clamp(0, 100).toDouble();
    final double sweepAngle = 6.28318 * (clampedPercent / 100);

    canvas.drawCircle(center, radius, basePaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.percent != percent || oldDelegate.color != color;
  }
}

class _CalendarCard extends StatefulWidget {
  const _CalendarCard();

  @override
  State<_CalendarCard> createState() => _CalendarCardState();
}

class _CalendarCardState extends State<_CalendarCard> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  final List<String> _days = const [
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
    'Su',
  ];

  final List<String> _months = const [
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

  @override
  void initState() {
    super.initState();

    final DateTime now = DateTime.now();

    _displayedMonth = DateTime(now.year, now.month);
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  void _goToPreviousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  List<_CalendarDay> _buildCalendarDays() {
    final DateTime firstDayOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    );

    final int daysBeforeMonth = firstDayOfMonth.weekday - 1;

    final DateTime gridStart = firstDayOfMonth.subtract(
      Duration(days: daysBeforeMonth),
    );

    return List.generate(42, (index) {
      final DateTime date = gridStart.add(Duration(days: index));
      final bool isCurrentMonth = date.month == _displayedMonth.month &&
          date.year == _displayedMonth.year;

      return _CalendarDay(
        date: date,
        isCurrentMonth: isCurrentMonth,
      );
    });
  }

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  @override
  Widget build(BuildContext context) {
    final List<_CalendarDay> calendarDays = _buildCalendarDays();

    const double calendarWidth = 650;
    const double calendarHeight = 310;

    return Container(
      height: 420,
      decoration: DashboardStyles.cardDecoration,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${_months[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                style: DashboardStyles.cardTitle,
              ),
              const Spacer(),
              _CalendarArrowButton(
                icon: Icons.chevron_left,
                color: const Color(0xFFB7B7B7),
                onTap: _goToPreviousMonth,
              ),
              const SizedBox(width: 18),
              _CalendarArrowButton(
                icon: Icons.chevron_right,
                color: Colors.black,
                onTap: _goToNextMonth,
              ),
            ],
          ),
          const SizedBox(height: 22),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: calendarWidth,
              height: calendarHeight,
              child: Column(
                children: [
                  Row(
                    children: _days.map((day) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: DashboardStyles.calendarDayText,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: calendarDays.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1.95,
                      ),
                      itemBuilder: (context, index) {
                        final _CalendarDay calendarDay = calendarDays[index];

                        final bool selected = _isSameDate(
                          calendarDay.date,
                          _selectedDate,
                        );

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = calendarDay.date;
                              _displayedMonth = DateTime(
                                calendarDay.date.year,
                                calendarDay.date.month,
                              );
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.blue
                                  : calendarDay.isCurrentMonth
                                      ? Colors.white
                                      : const Color(0xFFF0F0F4),
                              border: Border.all(
                                color: DashboardStyles.calendarBorder,
                                width: 0.8,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${calendarDay.date.day}',
                                style:
                                    DashboardStyles.calendarNumberText.copyWith(
                                  color: selected
                                      ? Colors.white
                                      : calendarDay.isCurrentMonth
                                          ? Colors.black
                                          : const Color(0xFFA7A7A7),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarDay {
  const _CalendarDay({
    required this.date,
    required this.isCurrentMonth,
  });

  final DateTime date;
  final bool isCurrentMonth;
}

class _CalendarArrowButton extends StatelessWidget {
  const _CalendarArrowButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          icon,
          size: 22,
          color: color,
        ),
      ),
    );
  }
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
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
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
                      onTap: () {
                        Navigator.pop(context, true);
                      },
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



class _ProjectsPanel extends StatelessWidget {
  const _ProjectsPanel({
    required this.selectedProgram,
    required this.selectedProjectIndex,
    required this.projects,
    required this.activities,
    required this.resetVersion,
    required this.onProjectSelected,
    required this.onActivitySelected,
  });

  final String selectedProgram;
  final int selectedProjectIndex;
  final List<_DashboardProject> projects;
  final List<_DashboardActivity> activities;
  final int resetVersion;
  final ValueChanged<int> onProjectSelected;
  final ValueChanged<_DashboardActivity> onActivitySelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 425,
      decoration: DashboardStyles.cardDecoration,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
      child: selectedProgram.isEmpty
          ? Center(
              child: Text(
                'No program selected.',
                style: AppText.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.placeholderGray,
                ),
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 430,
                  child: _SearchableProgressList<_DashboardProject>(
                    key: ValueKey('projects-$selectedProgram'),
                    title: '$selectedProgram Projects',
                    searchHint: 'Search project',
                    items: projects,
                    selectedIndex: selectedProjectIndex,
                    resetVersion: resetVersion,
                    getTitle: (project) => project.title,
                    getDescription: (project) => project.description,
                    getPercent: (project) => project.percent,
                    onItemTap: (project) {
                      final int originalIndex = projects.indexOf(project);

                      if (originalIndex != -1) {
                        onProjectSelected(originalIndex);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 26),
                Expanded(
                  child: _SearchableProgressList<_DashboardActivity>(
                    key: ValueKey(
                      'activities-$selectedProgram-$selectedProjectIndex',
                    ),
                    title: projects.isNotEmpty &&
                            selectedProjectIndex < projects.length
                        ? '${projects[selectedProjectIndex].title} Activities'
                        : '$selectedProgram Activities',
                    searchHint: 'Search activity',
                    items: activities,
                    selectedIndex: -1,
                    resetVersion: resetVersion,
                    getTitle: (activity) => activity.title,
                    getDescription: (activity) => activity.description,
                    getPercent: (activity) => activity.percent,
                    onItemTap: onActivitySelected,
                  ),
                ),
              ],
            ),
    );
  }
}

class _SearchableProgressList<T> extends StatefulWidget {
  const _SearchableProgressList({
    super.key,
    required this.title,
    required this.searchHint,
    required this.items,
    required this.selectedIndex,
    required this.resetVersion,
    required this.getTitle,
    required this.getDescription,
    required this.getPercent,
    required this.onItemTap,
  });

  final String title;
  final String searchHint;
  final List<T> items;
  final int selectedIndex;
  final int resetVersion;
  final String Function(T item) getTitle;
  final String Function(T item) getDescription;
  final int Function(T item) getPercent;
  final ValueChanged<T> onItemTap;

  @override
  State<_SearchableProgressList<T>> createState() =>
      _SearchableProgressListState<T>();
}

class _SearchableProgressListState<T>
    extends State<_SearchableProgressList<T>> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  _DashboardSortOrder _sortOrder = _DashboardSortOrder.az;

  @override
  void didUpdateWidget(covariant _SearchableProgressList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.resetVersion != oldWidget.resetVersion &&
        _scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<T> get _filteredItems {
    final String searchText = _searchController.text.trim().toLowerCase();

    final List<T> filtered = widget.items.where((item) {
      final String title = widget.getTitle(item).toLowerCase();
      final String description = widget.getDescription(item).toLowerCase();

      return title.contains(searchText) || description.contains(searchText);
    }).toList();

    filtered.sort((a, b) {
      switch (_sortOrder) {
        case _DashboardSortOrder.az:
          return widget
              .getTitle(a)
              .toLowerCase()
              .compareTo(widget.getTitle(b).toLowerCase());

        case _DashboardSortOrder.za:
          return widget
              .getTitle(b)
              .toLowerCase()
              .compareTo(widget.getTitle(a).toLowerCase());

        case _DashboardSortOrder.highToLow:
          return widget.getPercent(b).compareTo(widget.getPercent(a));

        case _DashboardSortOrder.lowToHigh:
          return widget.getPercent(a).compareTo(widget.getPercent(b));
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final List<T> filteredItems = _filteredItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                style: AppText.calSans(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 38,
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) {
                    setState(() {});
                  },
                  style: AppText.dmSans(
                    fontSize: 13,
                    color: AppColors.blue,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    hintStyle: AppText.dmSans(
                      fontSize: 13,
                      color: AppColors.placeholderGray,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.blue,
                      size: 18,
                    ),
                    filled: true,
                    fillColor: AppColors.softGray,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
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
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.softGray,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.borderGray,
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<_DashboardSortOrder>(
                  value: _sortOrder,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.blue,
                    size: 18,
                  ),
                  style: AppText.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue,
                  ),
                  dropdownColor: Colors.white,
                  items: const [
                    DropdownMenuItem(
                      value: _DashboardSortOrder.az,
                      child: Text('A-Z'),
                    ),
                    DropdownMenuItem(
                      value: _DashboardSortOrder.za,
                      child: Text('Z-A'),
                    ),
                    DropdownMenuItem(
                      value: _DashboardSortOrder.highToLow,
                      child: Text('High-Low'),
                    ),
                    DropdownMenuItem(
                      value: _DashboardSortOrder.lowToHigh,
                      child: Text('Low-High'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      _sortOrder = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: filteredItems.isEmpty
              ? Center(
                  child: Text(
                    'No items found.',
                    style: AppText.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.placeholderGray,
                    ),
                  ),
                )
              : Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  radius: const Radius.circular(20),
                  thickness: 10,
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(right: 18),
                    itemCount: filteredItems.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16);
                    },
                    itemBuilder: (context, index) {
                      final T item = filteredItems[index];
                      final int originalIndex = widget.items.indexOf(item);

                      return _ProgressListTile(
                        title: widget.getTitle(item),
                        description: widget.getDescription(item),
                        percent: widget.getPercent(item),
                        selected: originalIndex == widget.selectedIndex,
                        onTap: () {
                          widget.onItemTap(item);
                        },
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

class _ProgressStatusIndicator extends StatelessWidget {
  const _ProgressStatusIndicator({
    required this.percent,
  });

  final double percent;

  String get _label {
    if (percent >= 100) {
      return 'Completed';
    }

    if (percent <= 0) {
      return 'Not Started';
    }

    return 'In Progress';
  }

  Color get _statusColor {
    if (percent >= 100) {
      return DashboardStyles.green;
    }

    if (percent <= 0) {
      return const Color(0xFF8A8A8A);
    }

    return AppColors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final Color color = _statusColor;

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
            _label,
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
}

class _ProgressListTile extends StatelessWidget {
  const _ProgressListTile({
    required this.title,
    required this.description,
    required this.percent,
    required this.onTap,
    this.selected = false,
  });

  final String title;
  final String description;
  final int percent;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final double clampedPercent = percent.clamp(0, 100).toDouble();
    final Color progressColor = DashboardStyles.progressColor(
      clampedPercent,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
        height: 104,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.blue.withOpacity(0.12)
              : DashboardStyles.lightPanel,
          borderRadius: BorderRadius.circular(9),
          border: selected
              ? Border.all(
                  color: AppColors.blue,
                  width: 1.5,
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: progressColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${clampedPercent.toInt()}%',
                  style: AppText.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: DashboardStyles.cardTitle.copyWith(
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _ProgressStatusIndicator(
                        percent: clampedPercent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF777777),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: clampedPercent / 100,
                      minHeight: 9,
                      backgroundColor: const Color(0xFFE0E0E0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progressColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 18),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFB7B7B7),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
