import 'package:flutter/material.dart';

import '../state/sidebar_state.dart';
import '../styles/activities_styles.dart';
import '../styles/app_styles.dart';
import '../widgets/auth_buttons.dart';
import 'activities_admin_details_screen.dart';
import 'projects_admin_screen.dart';

class ActivitiesAdminScreen extends StatefulWidget {
  const ActivitiesAdminScreen({
    super.key,
    required this.projectTitle,
    required this.projectDescription,
    required this.projectProgram,
    required this.projectProgress,
    this.openedFromCalendar = false,
  });

  final String projectTitle;
  final String projectDescription;
  final String projectProgram;
  final int projectProgress;
  final bool openedFromCalendar;

  @override
  State<ActivitiesAdminScreen> createState() => _ActivitiesAdminScreenState();
}

enum _ActivitySortOrder { recent, oldest }

const List<String> _activityCodeOptions = <String>['A1', 'A2', 'A3', 'A4', 'A5'];

const Map<String, List<String>> _defaultComponentNamesByCode = <String, List<String>>{
  'A1': <String>[
    'Stakeholder Coordination',
    'Field Assessment',
    'Planning Review',
  ],
  'A2': <String>[
    'Community Mobilization',
    'Training Support',
    'Resource Preparation',
  ],
  'A3': <String>[
    'Implementation Monitoring',
    'Data Collection',
    'Technical Assistance',
  ],
  'A4': <String>[
    'Documentation Review',
    'Report Validation',
    'Output Consolidation',
  ],
  'A5': <String>[
    'Evaluation Support',
    'Learning Session',
    'Closeout Documentation',
  ],
};

class _ActivityComponentDraft {
  const _ActivityComponentDraft({
    required this.code,
    required this.name,
    required this.scheduleFrom,
    required this.scheduleTo,
  });

  final String code;
  final String name;
  final String scheduleFrom;
  final String scheduleTo;
}

String _defaultComponentNameForCode(String code, [int index = 0]) {
  final List<String> names = _defaultComponentNamesByCode[code] ??
      _defaultComponentNamesByCode[_activityCodeOptions.first]!;
  return names[index % names.length];
}

List<_ActivityComponentDraft> _defaultComponentDrafts() {
  return _defaultComponentNamesByCode.entries.expand((entry) {
    return entry.value.map((name) {
      return _ActivityComponentDraft(
        code: entry.key,
        name: name,
        scheduleFrom: '',
        scheduleTo: '',
      );
    });
  }).toList();
}

class _ActivitiesAdminScreenState extends State<ActivitiesAdminScreen> {
  late List<ActivityAdminItem> _activities;
  late List<_ActivityComponentDraft> _components;
  late final TextEditingController _searchController;

  String _searchQuery = '';
  String _selectedComponent = 'All Components';
  _ActivitySortOrder _sortOrder = _ActivitySortOrder.recent;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _activities = _defaultActivitiesForProject();
    _components = _defaultComponentsFromActivities(_activities);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goToProjectsPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ProjectsAdminScreen(),
      ),
    );
  }

  List<ActivityAdminItem> _defaultActivitiesForProject() {
    final int projectNumber = _projectNumberFromTitle(widget.projectTitle);
    final List<int> percents = _activityPercentsFor(
      widget.projectProgram,
      projectNumber,
    );

    return List.generate(percents.length, (index) {
      final int activityNumber = index + 1;
      final int percent = percents[index];
      final String code = _activityCodeOptions[index % _activityCodeOptions.length];

      return ActivityAdminItem(
        title: '${widget.projectProgram} Activity $activityNumber',
        description: _activityDescriptionFor(
          widget.projectProgram,
          activityNumber,
        ),
        code: code,
        componentName: _defaultComponentNameForCode(code, index),
        program: widget.projectProgram,
        scheduleFrom: _scheduleFromFor(activityNumber),
        scheduleTo: _scheduleToFor(activityNumber),
        percent: percent,
        status: _statusForProgress(percent),
      );
    });
  }

  List<_ActivityComponentDraft> _defaultComponentsFromActivities(
    List<ActivityAdminItem> activities,
  ) {
    final Set<String> seenKeys = <String>{};
    final List<_ActivityComponentDraft> components = [];

    void addComponent(_ActivityComponentDraft component) {
      final String key = '${component.code.toLowerCase()}|${component.name.toLowerCase()}';
      if (seenKeys.add(key)) {
        components.add(component);
      }
    }

    for (final _ActivityComponentDraft component in _defaultComponentDrafts()) {
      addComponent(component);
    }

    for (final ActivityAdminItem activity in activities) {
      addComponent(
        _ActivityComponentDraft(
          code: activity.code,
          name: activity.componentName,
          scheduleFrom: activity.scheduleFrom,
          scheduleTo: activity.scheduleTo,
        ),
      );
    }

    return components;
  }

  int _projectNumberFromTitle(String title) {
    final RegExpMatch? match = RegExp(r'(\d+)$').firstMatch(title.trim());

    if (match == null) {
      return 1;
    }

    return int.tryParse(match.group(1) ?? '1') ?? 1;
  }

  List<int> _activityPercentsFor(String program, int projectNumber) {
    final List<List<int>> percentsByProject;

    switch (program.toUpperCase()) {
      case 'IBG':
        percentsByProject = [
          [100, 95, 90, 85, 80],
          [95, 90, 85, 80, 75],
          [90, 85, 80, 75, 70],
          [85, 80, 75, 70, 65],
          [80, 75, 70, 65, 60],
          [75, 70, 65, 60, 55],
        ];
        break;
      case 'DSS':
        percentsByProject = [
          [80, 75, 70, 65, 60],
          [75, 70, 65, 60, 55],
          [70, 65, 60, 55, 50],
          [60, 55, 50, 45, 40],
          [55, 50, 45, 40, 35],
          [45, 40, 35, 30, 25],
        ];
        break;
      case 'ENVI':
        percentsByProject = [
          [65, 55, 50, 45, 40],
          [55, 50, 45, 40, 35],
          [45, 40, 35, 30, 25],
          [35, 30, 25, 20, 15],
          [25, 20, 15, 10, 5],
          [20, 15, 10, 5, 0],
        ];
        break;
      case 'KMI':
        percentsByProject = [
          [95, 90, 85, 80, 75],
          [85, 80, 75, 70, 65],
          [80, 75, 70, 65, 60],
          [70, 65, 60, 55, 50],
          [60, 55, 50, 45, 40],
          [50, 45, 40, 35, 30],
        ];
        break;
      default:
        percentsByProject = [
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
        ];
    }

    if (projectNumber <= 0 || projectNumber > percentsByProject.length) {
      return percentsByProject.first;
    }

    return percentsByProject[projectNumber - 1];
  }

  String _activityDescriptionFor(String program, int activityNumber) {
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

  String _scheduleFromFor(int activityNumber) {
    return 'Jun ${activityNumber.toString().padLeft(2, '0')}, 2026';
  }

  String _scheduleToFor(int activityNumber) {
    final int day = activityNumber + 4;
    return 'Jun ${day.toString().padLeft(2, '0')}, 2026';
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

  List<String> get _componentOptions {
    final List<String> components = _components
        .map((component) => component.name)
        .where((name) => name.trim().isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return ['All Components', ...components];
  }

  List<ActivityAdminItem> get _filteredActivities {
    final String query = _searchQuery.trim().toLowerCase();
    final List<ActivityAdminItem> filtered = _activities.where((activity) {
      final bool matchesSearch = query.isEmpty ||
          activity.title.toLowerCase().contains(query) ||
          activity.description.toLowerCase().contains(query) ||
          activity.code.toLowerCase().contains(query) ||
          activity.componentName.toLowerCase().contains(query);
      final bool matchesComponent = _selectedComponent == 'All Components' ||
          activity.componentName == _selectedComponent;

      return matchesSearch && matchesComponent;
    }).toList();

    switch (_sortOrder) {
      case _ActivitySortOrder.recent:
        return filtered.reversed.toList();
      case _ActivitySortOrder.oldest:
        return filtered;
    }
  }

  Future<void> _addActivity() async {
    final ActivityDraft? draft = await showDialog<ActivityDraft>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _AddActivityDialog(
          components: _components,
        );
      },
    );

    if (draft == null || draft.title.trim().isEmpty) {
      return;
    }

    final int nextIndex = _activities.length + 1;

    setState(() {
      _activities.add(
        ActivityAdminItem(
          title: draft.title.trim(),
          description: draft.description.trim().isEmpty
              ? 'No description added yet.'
              : draft.description.trim(),
          code: draft.code.trim().isEmpty
              ? _activityCodeOptions[(nextIndex - 1) % _activityCodeOptions.length]
              : draft.code.trim(),
          componentName: draft.componentName.trim().isEmpty
              ? 'General Component'
              : draft.componentName.trim(),
          program: widget.projectProgram,
          scheduleFrom: draft.scheduleFrom.trim(),
          scheduleTo: draft.scheduleTo.trim(),
          percent: 0,
          status: 'Not Started',
        ),
      );

      if (draft.componentName.trim().isNotEmpty &&
          !_components.any((component) => component.name == draft.componentName.trim())) {
        _components.add(
          _ActivityComponentDraft(
            code: draft.code.trim(),
            name: draft.componentName.trim(),
            scheduleFrom: draft.scheduleFrom.trim(),
            scheduleTo: draft.scheduleTo.trim(),
          ),
        );
      }
    });
  }

  Future<void> _manageComponents() async {
    final List<_ActivityComponentDraft>? updatedComponents =
        await showDialog<List<_ActivityComponentDraft>>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _ManageComponentsDialog(
          components: _components,
        );
      },
    );

    if (updatedComponents == null) {
      return;
    }

    setState(() {
      _components = updatedComponents;
      if (!_componentOptions.contains(_selectedComponent)) {
        _selectedComponent = 'All Components';
      }
    });
  }

  Future<void> _editActivity(ActivityAdminItem activity) async {
    final ActivityDraft? draft = await showDialog<ActivityDraft>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return ActivityDetailsDialog(
          title: 'Edit Activity',
          buttonText: 'Save',
          initialTitle: activity.title,
          initialDescription: activity.description,
          initialCode: activity.code,
          initialComponentName: activity.componentName,
          initialScheduleFrom: activity.scheduleFrom,
          initialScheduleTo: activity.scheduleTo,
        );
      },
    );

    if (draft == null || draft.title.trim().isEmpty) {
      return;
    }

    final ActivityAdminItem updatedActivity = activity.copyWith(
      title: draft.title.trim(),
      description: draft.description.trim().isEmpty
          ? 'No description added yet.'
          : draft.description.trim(),
      code: draft.code.trim().isEmpty ? activity.code : draft.code.trim(),
      componentName: draft.componentName.trim().isEmpty
          ? 'No component name added yet.'
          : draft.componentName.trim(),
      scheduleFrom: draft.scheduleFrom.trim().isEmpty
          ? 'Not set'
          : draft.scheduleFrom.trim(),
      scheduleTo:
          draft.scheduleTo.trim().isEmpty ? 'Not set' : draft.scheduleTo.trim(),
    );

    setState(() {
      final int index = _activities.indexOf(activity);

      if (index != -1) {
        _activities[index] = updatedActivity;
      }

      if (draft.componentName.trim().isNotEmpty &&
          !_components.any((component) => component.name == draft.componentName.trim())) {
        _components.add(
          _ActivityComponentDraft(
            code: updatedActivity.code,
            name: updatedActivity.componentName,
            scheduleFrom: updatedActivity.scheduleFrom,
            scheduleTo: updatedActivity.scheduleTo,
          ),
        );
      }
    });
  }

  void _deleteActivity(ActivityAdminItem activity) {
    showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return DeleteConfirmationDialog(
          title: 'Delete Activity',
          message:
              'Are you sure you want to delete "${activity.title}" from activities? This cannot be undone.',
        );
      },
    ).then((confirmed) {
      if (confirmed != true) {
        return;
      }

      setState(() {
        _activities.remove(activity);
      });
    });
  }

  void _openActivityDetails(ActivityAdminItem activity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ActivitiesAdminDetailsScreen(
            projectTitle: widget.projectTitle,
            activity: activity,
            onActivityChanged: (updatedActivity) {
              setState(() {
                final int index = _activities.indexOf(activity);

                if (index != -1) {
                  _activities[index] = updatedActivity;
                }
              });
            },
            onActivityDeleted: () {
              setState(() {
                _activities.remove(activity);
              });
            },
            openedFromCalendar: widget.openedFromCalendar,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: ActivitiesStyles.pageBackground,
        child: Stack(
          children: [
            _buildBackgroundImage(),
            ValueListenableBuilder<bool>(
              valueListenable: SidebarState.isExpanded,
              builder: (context, isExpanded, child) {
                return Row(
                  children: [
                    ActivitiesAdminSidebar(isExpanded: isExpanded),
                    Expanded(
                      child: SafeArea(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(42, 28, 42, 60),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: ActivitiesStyles.contentMaxWidth,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  BackTextButton(
                                    label: 'Back to Projects',
                                    onTap: _goToProjectsPage,
                                  ),
                                  const SizedBox(height: 24),
                                  _buildProjectHeader(),
                                  const SizedBox(height: 24),
                                  _buildActivitiesHeader(),
                                  const SizedBox(height: 14),
                                  _buildActivityControls(),
                                  const SizedBox(height: 16),
                                  if (_filteredActivities.isEmpty)
                                    _buildEmptyCard()
                                  else
                                    Column(
                                      children: _filteredActivities
                                          .map(
                                            (activity) => Padding(
                                              padding: const EdgeInsets.only(bottom: 16),
                                              child: _activityCard(activity),
                                            ),
                                          )
                                          .toList(),
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

  Widget _buildProjectHeader() {
    final double progress = widget.projectProgress.clamp(0, 100).toDouble();
    final Color progressColor = ActivitiesStyles.progressColor(progress);

    return Container(
      decoration: ActivitiesStyles.cardDecoration,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.projectTitle,
            style: ActivitiesStyles.pageTitle,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.projectProgram,
                style: ActivitiesStyles.meta.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(width: 10),
              ActivityStatusChip(status: _statusForProgress(progress.toInt())),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.projectDescription,
            style: ActivitiesStyles.description,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: progress / 100,
                    backgroundColor: const Color(0xFFE0E0E0),
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                '${progress.toInt()}%',
                style: ActivitiesStyles.percentText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesHeader() {
    return Text(
      'Activities',
      style: ActivitiesStyles.sectionTitle,
    );
  }

  Widget _buildActivityControls() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool stackControls = constraints.maxWidth < 960;

        if (stackControls) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchField(),
              const SizedBox(height: 12),
              _buildComponentFilter(),
              const SizedBox(height: 12),
              _buildSortFilter(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildAddComponentButton()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildAddActivityButton()),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildSearchField(),
            ),
            const SizedBox(width: 12),
            Expanded(child: _buildComponentFilter()),
            const SizedBox(width: 12),
            Expanded(child: _buildSortFilter()),
            const SizedBox(width: 12),
            _buildAddComponentButton(),
            const SizedBox(width: 12),
            _buildAddActivityButton(),
          ],
        );
      },
    );
  }

  Widget _buildAddComponentButton() {
    return AuthButton(
      text: 'Manage Components',
      width: 180,
      height: 44,
      type: AuthButtonType.dashboardFilled,
      onTap: _manageComponents,
      textStyle: ActivitiesStyles.buttonText,
    );
  }

  Widget _buildAddActivityButton() {
    return AuthButton(
      text: '+ Add Activity',
      width: 145,
      height: 44,
      type: AuthButtonType.dashboardFilled,
      onTap: _addActivity,
      textStyle: ActivitiesStyles.buttonText,
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
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
        decoration: ActivitiesStyles.fieldDecoration(
          hintText: 'Search activities',
        ).copyWith(
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.blue,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildComponentFilter() {
    final List<String> options = _componentOptions;
    final String selectedValue = options.contains(_selectedComponent)
        ? _selectedComponent
        : 'All Components';

    return SizedBox(
      height: 44,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.blue,
        ),
        isExpanded: true,
        decoration: ActivitiesStyles.fieldDecoration(),
        style: AppText.dmSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.blue,
        ),
        items: options.map((component) {
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
            _selectedComponent = value;
          });
        },
      ),
    );
  }

  Widget _buildSortFilter() {
    return SizedBox(
      height: 44,
      child: DropdownButtonFormField<_ActivitySortOrder>(
        value: _sortOrder,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.blue,
        ),
        isExpanded: true,
        decoration: ActivitiesStyles.fieldDecoration(),
        style: AppText.dmSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.blue,
        ),
        items: const [
          DropdownMenuItem(
            value: _ActivitySortOrder.recent,
            child: Text('Most Recent'),
          ),
          DropdownMenuItem(
            value: _ActivitySortOrder.oldest,
            child: Text('Most Old'),
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
  }

  Widget _activityCard(ActivityAdminItem activity) {
    final double clampedProgress = activity.percent.clamp(0, 100).toDouble();
    final Color progressColor = ActivitiesStyles.progressColor(clampedProgress);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _openActivityDetails(activity),
        child: Container(
          decoration: ActivitiesStyles.cardDecoration,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: progressColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${clampedProgress.toInt()}%',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            activity.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ActivitiesStyles.cardTitle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ActivityStatusChip(status: activity.status),
                        const SizedBox(width: 10),
                        ActivityIconActionButton(
                          tooltip: 'Edit activity',
                          icon: Icons.edit_outlined,
                          onTap: () => _editActivity(activity),
                        ),
                        const SizedBox(width: 10),
                        ActivityIconActionButton(
                          tooltip: 'Delete activity',
                          icon: Icons.delete_outline_rounded,
                          onTap: () => _deleteActivity(activity),
                          isDelete: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activity.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: ActivitiesStyles.description,
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        minHeight: 9,
                        value: clampedProgress / 100,
                        backgroundColor: const Color(0xFFE0E0E0),
                        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              const Icon(
                Icons.chevron_right_rounded,
                size: 32,
                color: Color(0xFFB7B7B7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: ActivitiesStyles.cardDecoration,
      child: Text(
        'No activities found.',
        style: ActivitiesStyles.description,
      ),
    );
  }
}

class _AddActivityDialog extends StatefulWidget {
  const _AddActivityDialog({
    super.key,
    required this.components,
  });

  final List<_ActivityComponentDraft> components;

  @override
  State<_AddActivityDialog> createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<_AddActivityDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _targetController;
  late final TextEditingController _scheduleFromController;
  late final TextEditingController _scheduleToController;

  String? _selectedCode;
  String? _selectedComponentName;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _targetController = TextEditingController();
    _scheduleFromController = TextEditingController();
    _scheduleToController = TextEditingController();

    _selectedCode = _firstAvailableCode;
    _selectedComponentName = _componentsForCode(_selectedCode).isNotEmpty
        ? _componentsForCode(_selectedCode).first.name
        : null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetController.dispose();
    _scheduleFromController.dispose();
    _scheduleToController.dispose();
    super.dispose();
  }

  List<String> get _availableCodes {
    final Set<String> codes = widget.components
        .map((component) => component.code.trim())
        .where((code) => code.isNotEmpty)
        .toSet();

    final List<String> sortedCodes = codes.toList()..sort();
    return sortedCodes.isEmpty ? List<String>.from(_activityCodeOptions) : sortedCodes;
  }

  String get _firstAvailableCode {
    for (final String code in _availableCodes) {
      if (_componentsForCode(code).isNotEmpty) {
        return code;
      }
    }

    return _availableCodes.first;
  }

  List<_ActivityComponentDraft> _componentsForCode(String? code) {
    if (code == null) {
      return <_ActivityComponentDraft>[];
    }

    return widget.components
        .where((component) => component.code == code)
        .toList();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 5),
    );

    if (picked == null) {
      return;
    }

    controller.text = _formatDate(picked);
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

    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  void _submit() {
    final String title = _titleController.text.trim();
    final String code = (_selectedCode ?? '').trim();
    final String componentName = (_selectedComponentName ?? '').trim();
    final String target = _targetController.text.trim();
    final String scheduleFrom = _scheduleFromController.text.trim();
    final String scheduleTo = _scheduleToController.text.trim();

    if (title.isEmpty ||
        code.isEmpty ||
        componentName.isEmpty ||
        target.isEmpty ||
        scheduleFrom.isEmpty ||
        scheduleTo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required fields.'),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      ActivityDraft(
        title: title,
        description: _descriptionController.text.trim(),
        code: code,
        componentName: componentName,
        scheduleFrom: scheduleFrom,
        scheduleTo: scheduleTo,
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
                  'Add Activity',
                  textAlign: TextAlign.center,
                  style: AppText.calSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 28),
                DialogField(
                  label: 'Activity Name*',
                  controller: _titleController,
                  hintText: 'Courtesy Visits',
                ),
                const SizedBox(height: 16),
                DialogField(
                  label: 'Description',
                  controller: _descriptionController,
                  maxLines: 3,
                  height: 84,
                  hintText: 'Add a short activity description',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _codeDropdown()),
                    const SizedBox(width: 16),
                    Expanded(child: _componentDropdown()),
                  ],
                ),
                const SizedBox(height: 16),
                DialogField(
                  label: 'Target/Indicators*',
                  controller: _targetController,
                  hintText: 'Type target or indicator',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _calendarField(
                        label: 'Schedule From*',
                        controller: _scheduleFromController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _calendarField(
                        label: 'Schedule To*',
                        controller: _scheduleToController,
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
                      onTap: () => Navigator.pop(context),
                      textStyle: AppText.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(width: 24),
                    AuthButton(
                      text: 'Add',
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

  Widget _codeDropdown() {
    return _DialogDropdown<String>(
      label: 'Code*',
      value: _selectedCode,
      items: _availableCodes,
      itemLabel: (code) => code,
      onChanged: (value) {
        if (value == null) {
          return;
        }

        final List<_ActivityComponentDraft> filteredComponents =
            _componentsForCode(value);

        setState(() {
          _selectedCode = value;
          _selectedComponentName = filteredComponents.isNotEmpty
              ? filteredComponents.first.name
              : null;
        });
      },
    );
  }

  Widget _componentDropdown() {
    final List<_ActivityComponentDraft> components =
        _componentsForCode(_selectedCode);

    return _DialogDropdown<_ActivityComponentDraft>(
      label: 'Component Name*',
      value: components
              .any((component) => component.name == _selectedComponentName)
          ? components.firstWhere(
              (component) => component.name == _selectedComponentName,
            )
          : null,
      items: components,
      itemLabel: (component) => component.name,
      hintText: components.isEmpty ? 'Create component first' : null,
      onChanged: (value) {
        setState(() {
          _selectedComponentName = value?.name;
        });
      },
    );
  }

  Widget _calendarField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
            controller: controller,
            readOnly: true,
            onTap: () => _pickDate(controller),
            style: AppText.dmSans(
              fontSize: 15,
              color: AppColors.blue,
            ),
            decoration: ActivitiesStyles.fieldDecoration(
              hintText: 'Select date',
            ).copyWith(
              suffixIcon: const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: AppColors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ManageComponentsDialog extends StatefulWidget {
  const _ManageComponentsDialog({
    super.key,
    required this.components,
  });

  final List<_ActivityComponentDraft> components;

  @override
  State<_ManageComponentsDialog> createState() => _ManageComponentsDialogState();
}

class _ManageComponentsDialogState extends State<_ManageComponentsDialog> {
  late final TextEditingController _searchController;
  late List<_ActivityComponentDraft> _localComponents;

  String _searchQuery = '';
  String _selectedCodeFilter = 'All Codes';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _localComponents = List<_ActivityComponentDraft>.from(widget.components);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _codeFilterOptions {
    final Set<String> codes = _localComponents.map((component) => component.code).toSet();
    final List<String> sortedCodes = codes.toList()..sort();
    return ['All Codes', ...sortedCodes];
  }

  List<_ActivityComponentDraft> get _filteredComponents {
    final String query = _searchQuery.trim().toLowerCase();
    final List<_ActivityComponentDraft> filtered = _localComponents.where((component) {
      final bool matchesSearch = query.isEmpty ||
          component.code.toLowerCase().contains(query) ||
          component.name.toLowerCase().contains(query);
      final bool matchesCode = _selectedCodeFilter == 'All Codes' ||
          component.code == _selectedCodeFilter;
      return matchesSearch && matchesCode;
    }).toList();

    filtered.sort((a, b) {
      final int codeCompare = a.code.compareTo(b.code);
      if (codeCompare != 0) {
        return codeCompare;
      }
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return filtered;
  }

  bool _hasDuplicate(_ActivityComponentDraft draft, {_ActivityComponentDraft? except}) {
    return _localComponents.any((component) {
      if (except != null && identical(component, except)) {
        return false;
      }

      return component.code.toLowerCase() == draft.code.toLowerCase() &&
          component.name.toLowerCase() == draft.name.toLowerCase();
    });
  }

  Future<void> _addComponent() async {
    final _ActivityComponentDraft? draft = await showDialog<_ActivityComponentDraft>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return const _ComponentDetailsDialog(
          title: 'Add Component',
          buttonText: 'Add',
        );
      },
    );

    if (draft == null) {
      return;
    }

    if (_hasDuplicate(draft)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This component already exists for the selected code.'),
        ),
      );
      return;
    }

    setState(() {
      _localComponents.add(draft);
      _selectedCodeFilter = 'All Codes';
    });
  }

  Future<void> _editComponent(_ActivityComponentDraft component) async {
    final _ActivityComponentDraft? draft = await showDialog<_ActivityComponentDraft>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return _ComponentDetailsDialog(
          title: 'Edit Component',
          buttonText: 'Save',
          initialCode: component.code,
          initialComponentName: component.name,
        );
      },
    );

    if (draft == null) {
      return;
    }

    if (_hasDuplicate(draft, except: component)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This component already exists for the selected code.'),
        ),
      );
      return;
    }

    setState(() {
      final int index = _localComponents.indexOf(component);
      if (index != -1) {
        _localComponents[index] = draft;
      }
    });
  }

  void _deleteComponent(_ActivityComponentDraft component) {
    showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return DeleteConfirmationDialog(
          title: 'Delete Component',
          message:
              'Are you sure you want to delete "${component.name}" from components? This cannot be undone.',
        );
      },
    ).then((confirmed) {
      if (confirmed != true || !mounted) {
        return;
      }

      setState(() {
        _localComponents.remove(component);
        if (!_codeFilterOptions.contains(_selectedCodeFilter)) {
          _selectedCodeFilter = 'All Codes';
        }
      });
    });
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
                'Manage Components',
                textAlign: TextAlign.center,
                style: AppText.calSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 24),
              _buildControls(),
              const SizedBox(height: 16),
              Flexible(
                child: _buildComponentsList(),
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
                    onTap: () => Navigator.pop(context, _localComponents),
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

  Widget _buildControls() {
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
            decoration: ActivitiesStyles.fieldDecoration(
              hintText: 'Search components',
            ).copyWith(
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.blue,
                size: 22,
              ),
            ),
          ),
        );

        final Widget filter = SizedBox(
          height: 44,
          child: DropdownButtonFormField<String>(
            value: _codeFilterOptions.contains(_selectedCodeFilter)
                ? _selectedCodeFilter
                : 'All Codes',
            decoration: ActivitiesStyles.fieldDecoration(),
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
            items: _codeFilterOptions.map((code) {
              return DropdownMenuItem<String>(
                value: code,
                child: Text(code, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                _selectedCodeFilter = value;
              });
            },
          ),
        );

        final Widget addButton = AuthButton(
          text: '+ Add Component',
          width: 165,
          height: 44,
          type: AuthButtonType.dashboardFilled,
          onTap: _addComponent,
          textStyle: ActivitiesStyles.buttonText,
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              search,
              const SizedBox(height: 12),
              filter,
              const SizedBox(height: 12),
              addButton,
            ],
          );
        }

        return Row(
          children: [
            Expanded(flex: 2, child: search),
            const SizedBox(width: 12),
            SizedBox(width: 150, child: filter),
            const SizedBox(width: 12),
            addButton,
          ],
        );
      },
    );
  }

  Widget _buildComponentsList() {
    final List<_ActivityComponentDraft> components = _filteredComponents;

    if (components.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: ActivitiesStyles.cardDecoration.copyWith(
          boxShadow: const <BoxShadow>[],
        ),
        child: Text(
          'No components found.',
          style: ActivitiesStyles.description,
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
          children: components.map((component) {
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
                      component.code,
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
                      component.name,
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
                    tooltip: 'Edit component',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.blue,
                      size: 20,
                    ),
                    onPressed: () => _editComponent(component),
                  ),
                  IconButton(
                    tooltip: 'Delete component',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFD64545),
                      size: 20,
                    ),
                    onPressed: () => _deleteComponent(component),
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

class _ComponentDetailsDialog extends StatefulWidget {
  const _ComponentDetailsDialog({
    super.key,
    required this.title,
    required this.buttonText,
    this.initialCode = 'A1',
    this.initialComponentName = '',
  });

  final String title;
  final String buttonText;
  final String initialCode;
  final String initialComponentName;

  @override
  State<_ComponentDetailsDialog> createState() => _ComponentDetailsDialogState();
}

class _ComponentDetailsDialogState extends State<_ComponentDetailsDialog> {
  late final TextEditingController _codeController;
  late final TextEditingController _componentController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.initialCode);
    _componentController = TextEditingController(text: widget.initialComponentName);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _componentController.dispose();
    super.dispose();
  }

  void _submit() {
    final String code = _codeController.text.trim();
    final String componentName = _componentController.text.trim();

    if (code.isEmpty || componentName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required fields.'),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      _ActivityComponentDraft(
        code: code,
        name: componentName,
        scheduleFrom: '',
        scheduleTo: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
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
              _CodeAutocompleteField(
                label: 'Code*',
                controller: _codeController,
                suggestions: _activityCodeOptions,
                hintText: 'A1, A2, or type your own code',
              ),
              const SizedBox(height: 16),
              DialogField(
                label: 'Component Name*',
                controller: _componentController,
                hintText: 'Create new component name',
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
    );
  }
}

class _CodeAutocompleteField extends StatefulWidget {
  const _CodeAutocompleteField({
    required this.label,
    required this.controller,
    required this.suggestions,
    this.hintText,
  });

  final String label;
  final TextEditingController controller;
  final List<String> suggestions;
  final String? hintText;

  @override
  State<_CodeAutocompleteField> createState() => _CodeAutocompleteFieldState();
}

class _CodeAutocompleteFieldState extends State<_CodeAutocompleteField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppText.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.blue,
          ),
        ),
        const SizedBox(height: 8),
        RawAutocomplete<String>(
          textEditingController: widget.controller,
          focusNode: _focusNode,
          optionsBuilder: (TextEditingValue textEditingValue) {
            final String query = textEditingValue.text.trim().toLowerCase();
            if (query.isEmpty) {
              return widget.suggestions;
            }

            return widget.suggestions.where(
              (code) => code.toLowerCase().contains(query),
            );
          },
          onSelected: (String value) {
            widget.controller.text = value;
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return SizedBox(
              height: 46,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                style: AppText.dmSans(
                  fontSize: 15,
                  color: AppColors.blue,
                ),
                decoration: ActivitiesStyles.fieldDecoration(
                  hintText: widget.hintText,
                ).copyWith(
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.blue,
                  ),
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            final List<String> optionList = options.toList();

            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 180,
                    maxWidth: 440,
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: optionList.length,
                    itemBuilder: (context, index) {
                      final String option = optionList[index];

                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Text(
                            option,
                            style: AppText.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _DialogDropdown<T> extends StatelessWidget {
  const _DialogDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.hintText,
  });

  final String label;
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final bool hasSelectedValue = value != null && items.contains(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.blue,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 46,
          child: DropdownButtonFormField<T>(
            value: hasSelectedValue ? value : null,
            hint: hintText == null
                ? null
                : Text(
                    hintText!,
                    overflow: TextOverflow.ellipsis,
                  ),
            decoration: ActivitiesStyles.fieldDecoration(),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.blue,
            ),
            isExpanded: true,
            style: AppText.dmSans(
              fontSize: 15,
              color: AppColors.blue,
            ),
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemLabel(item),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: items.isEmpty ? null : onChanged,
          ),
        ),
      ],
    );
  }
}
