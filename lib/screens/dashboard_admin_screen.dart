import 'package:flutter/material.dart';

import '../styles/app_styles.dart';
import '../styles/dashboard_styles.dart';
import '../widgets/auth_buttons.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  bool _sidebarExpanded = false;

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

  List<_DashboardProject> _defaultProjectsFor(String program) {
    final List<int> projectPercents = _projectPercentsFor(program);

    return List.generate(projectPercents.length, (index) {
      final int projectNumber = index + 1;

      return _DashboardProject(
        title: '$program Project $projectNumber',
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
        percent: selectedProjectActivities[index],
      );
    });
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
        activities: updatedActivities,
      );
    }).toList();
  }

  void _toggleSidebar() {
    setState(() {
      _sidebarExpanded = !_sidebarExpanded;
    });
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
        child: Row(
          children: [
            _DashboardSidebar(
              isExpanded: _sidebarExpanded,
              onToggle: _toggleSidebar,
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
                            onManageProjects: _showManageProjectsDialog,
                            onManageActivities: _showManageActivitiesDialog,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardProject {
  const _DashboardProject({
    required this.title,
    required this.percent,
    required this.activities,
  });

  final String title;
  final int percent;
  final List<_DashboardActivity> activities;

  _DashboardProject copyWith({
    String? title,
    int? percent,
    List<_DashboardActivity>? activities,
  }) {
    return _DashboardProject(
      title: title ?? this.title,
      percent: percent ?? this.percent,
      activities: activities ?? this.activities,
    );
  }
}

class _DashboardActivity {
  const _DashboardActivity({
    required this.title,
    required this.percent,
  });

  final String title;
  final int percent;

  _DashboardActivity copyWith({
    String? title,
    int? percent,
  }) {
    return _DashboardActivity(
      title: title ?? this.title,
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

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
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
            icon: Icons.person,
            label: 'Account Settings',
            isExpanded: isExpanded,
            selected: false,
            onTap: () {},
          ),
          _SidebarItem(
            icon: Icons.wb_sunny_outlined,
            label: 'Dark/Light Mode',
            isExpanded: isExpanded,
            selected: false,
            onTap: () {},
          ),
          _SidebarItem(
            icon: Icons.logout_rounded,
            label: 'Log Out',
            isExpanded: isExpanded,
            selected: false,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
          ),
          if (isExpanded) ...[
            const Spacer(),
            Text(
              'Created by:',
              textAlign: TextAlign.center,
              style: AppText.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF888888),
              ),
            ),
            Text(
              '- J.Casia & M.Dimatulac -',
              textAlign: TextAlign.center,
              style: AppText.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF888888),
              ),
            ),
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
              alignment: Alignment.bottomCenter,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.white.withOpacity(0.98),
                    Colors.white.withOpacity(0.86),
                    Colors.white.withOpacity(0.08),
                  ],
                ),
              ),
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
  late List<String> _localPrograms;

  @override
  void initState() {
    super.initState();

    _localPrograms = List<String>.from(widget.programs);
  }

  void _syncDashboardPrograms() {
    widget.onProgramsChanged(List<String>.from(_localPrograms));
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

    _syncDashboardPrograms();
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

    _syncDashboardPrograms();
  }

  void _deleteProgram(String programName) {
    setState(() {
      _localPrograms.remove(programName);
    });

    _syncDashboardPrograms();
  }

  @override
  Widget build(BuildContext context) {
    return _ManageListDialog<String>(
      title: 'Manage Programs',
      sectionTitle: 'Programs',
      searchHint: 'Search program',
      addButtonText: '+ Add Program',
      items: _localPrograms,
      getTitle: (program) => program,
      onAdd: _addProgram,
      onEdit: _editProgram,
      onDelete: _deleteProgram,
    );
  }
}

class _ManageProjectsDialog extends StatefulWidget {
  const _ManageProjectsDialog({
    required this.program,
    required this.projects,
    required this.onProjectsChanged,
  });

  final String program;
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
    final String? projectName = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return const _NameDialog(
          title: 'Add Project',
          label: 'Project Name*',
          buttonText: 'Add',
        );
      },
    );

    if (projectName == null || projectName.trim().isEmpty) {
      return;
    }

    setState(() {
      _localProjects.add(
        _DashboardProject(
          title: projectName.trim(),
          percent: 0,
          activities: const [],
        ),
      );
    });

    _syncDashboardProjects();
  }

  Future<void> _editProject(_DashboardProject oldProject) async {
    final String? newName = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _NameDialog(
          title: 'Edit Project',
          label: 'Project Name*',
          buttonText: 'Save',
          initialValue: oldProject.title,
        );
      },
    );

    if (newName == null || newName.trim().isEmpty) {
      return;
    }

    setState(() {
      final int index = _localProjects.indexOf(oldProject);

      if (index != -1) {
        _localProjects[index] = oldProject.copyWith(
          title: newName.trim(),
        );
      }
    });

    _syncDashboardProjects();
  }

  void _deleteProject(_DashboardProject project) {
    setState(() {
      _localProjects.remove(project);
    });

    _syncDashboardProjects();
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
  State<_ManageActivitiesDialog> createState() => _ManageActivitiesDialogState();
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

  Future<void> _addActivity() async {
    final String? activityName = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return const _NameDialog(
          title: 'Add Activity',
          label: 'Activity Name*',
          buttonText: 'Add',
        );
      },
    );

    if (activityName == null || activityName.trim().isEmpty) {
      return;
    }

    setState(() {
      _localActivities.add(
        _DashboardActivity(
          title: activityName.trim(),
          percent: 0,
        ),
      );
    });

    _syncDashboardActivities();
  }

  Future<void> _editActivity(_DashboardActivity oldActivity) async {
    final String? newName = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _NameDialog(
          title: 'Edit Activity',
          label: 'Activity Name*',
          buttonText: 'Save',
          initialValue: oldActivity.title,
        );
      },
    );

    if (newName == null || newName.trim().isEmpty) {
      return;
    }

    setState(() {
      final int index = _localActivities.indexOf(oldActivity);

      if (index != -1) {
        _localActivities[index] = oldActivity.copyWith(
          title: newName.trim(),
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
            selectedProgram.isEmpty ? 'No Program' : 'Total $selectedProgram Progress',
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
      final bool isCurrentMonth =
          date.month == _displayedMonth.month &&
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

class _ProjectsPanel extends StatelessWidget {
  const _ProjectsPanel({
    required this.selectedProgram,
    required this.selectedProjectIndex,
    required this.projects,
    required this.activities,
    required this.resetVersion,
    required this.onProjectSelected,
    required this.onManageProjects,
    required this.onManageActivities,
  });

  final String selectedProgram;
  final int selectedProjectIndex;
  final List<_DashboardProject> projects;
  final List<_DashboardActivity> activities;
  final int resetVersion;
  final ValueChanged<int> onProjectSelected;
  final VoidCallback onManageProjects;
  final VoidCallback onManageActivities;

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
                    manageButtonText: 'Manage Projects',
                    items: projects,
                    selectedIndex: selectedProjectIndex,
                    resetVersion: resetVersion,
                    getTitle: (project) => project.title,
                    getPercent: (project) => project.percent,
                    onItemTap: (project) {
                      final int originalIndex = projects.indexOf(project);

                      if (originalIndex != -1) {
                        onProjectSelected(originalIndex);
                      }
                    },
                    onManagePressed: onManageProjects,
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
                    manageButtonText: 'Manage Activities',
                    items: activities,
                    selectedIndex: -1,
                    resetVersion: resetVersion,
                    getTitle: (activity) => activity.title,
                    getPercent: (activity) => activity.percent,
                    onItemTap: (_) {},
                    onManagePressed: onManageActivities,
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
    required this.manageButtonText,
    required this.items,
    required this.selectedIndex,
    required this.resetVersion,
    required this.getTitle,
    required this.getPercent,
    required this.onItemTap,
    required this.onManagePressed,
  });

  final String title;
  final String searchHint;
  final String manageButtonText;
  final List<T> items;
  final int selectedIndex;
  final int resetVersion;
  final String Function(T item) getTitle;
  final int Function(T item) getPercent;
  final ValueChanged<T> onItemTap;
  final VoidCallback onManagePressed;

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
      return widget.getTitle(item).toLowerCase().contains(searchText);
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
            const SizedBox(width: 12),
            AuthButton(
              text: widget.manageButtonText,
              width: 150,
              height: 32,
              type: AuthButtonType.dashboardFilled,
              onTap: widget.onManagePressed,
              textStyle: AppText.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
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
    required this.percent,
    required this.onTap,
    this.selected = false,
  });

  final String title;
  final int percent;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final double clampedPercent = percent.clamp(0, 100).toDouble();
    final Color progressColor = DashboardStyles.progressColor(
      clampedPercent,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 82,
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
    );
  }
}