import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../state/sidebar_state.dart';
import '../styles/activities_styles.dart';
import '../styles/app_styles.dart';
import '../widgets/auth_buttons.dart';
import 'projects_admin_screen.dart';


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



class ActivityAdminItem {
  const ActivityAdminItem({
    required this.title,
    required this.description,
    required this.code,
    required this.componentName,
    required this.program,
    required this.scheduleFrom,
    required this.scheduleTo,
    required this.percent,
    required this.status,
  });

  final String title;
  final String description;
  final String code;
  final String componentName;
  final String program;
  final String scheduleFrom;
  final String scheduleTo;
  final int percent;
  final String status;

  ActivityAdminItem copyWith({
    String? title,
    String? description,
    String? code,
    String? componentName,
    String? program,
    String? scheduleFrom,
    String? scheduleTo,
    int? percent,
    String? status,
  }) {
    return ActivityAdminItem(
      title: title ?? this.title,
      description: description ?? this.description,
      code: code ?? this.code,
      componentName: componentName ?? this.componentName,
      program: program ?? this.program,
      scheduleFrom: scheduleFrom ?? this.scheduleFrom,
      scheduleTo: scheduleTo ?? this.scheduleTo,
      percent: percent ?? this.percent,
      status: status ?? this.status,
    );
  }
}

class ActivityDraft {
  const ActivityDraft({
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

class SubmittedFileItem {
  const SubmittedFileItem({
    required this.name,
    required this.uploader,
    required this.type,
    required this.dateSubmitted,
  });

  final String name;
  final String uploader;
  final String type;
  final String dateSubmitted;

  SubmittedFileItem copyWith({
    String? name,
    String? uploader,
    String? type,
    String? dateSubmitted,
  }) {
    return SubmittedFileItem(
      name: name ?? this.name,
      uploader: uploader ?? this.uploader,
      type: type ?? this.type,
      dateSubmitted: dateSubmitted ?? this.dateSubmitted,
    );
  }
}

class ActivitiesAdminDetailsScreen extends StatefulWidget {
  const ActivitiesAdminDetailsScreen({
    super.key,
    required this.projectTitle,
    this.projectDescription,
    this.projectProgram,
    this.projectProgress,
    required this.activity,
    required this.onActivityChanged,
    required this.onActivityDeleted,
    this.onBackToProjectActivities,
    this.openedFromCalendar = false,
  });

  final String projectTitle;
  final String? projectDescription;
  final String? projectProgram;
  final int? projectProgress;
  final ActivityAdminItem activity;
  final ValueChanged<ActivityAdminItem> onActivityChanged;
  final VoidCallback onActivityDeleted;
  final VoidCallback? onBackToProjectActivities;
  final bool openedFromCalendar;

  @override
  State<ActivitiesAdminDetailsScreen> createState() =>
      _ActivitiesAdminDetailsScreenState();
}

class _ActivitiesAdminDetailsScreenState
    extends State<ActivitiesAdminDetailsScreen> {
  late ActivityAdminItem _activity;
  late List<SubmittedFileItem> _submittedFiles;

  @override
  void initState() {
    super.initState();
    _activity = widget.activity;
    _submittedFiles = _defaultSubmittedFiles(_activity);
  }

  List<SubmittedFileItem> _defaultSubmittedFiles(ActivityAdminItem activity) {
    return [
      SubmittedFileItem(
        name: '${activity.code}-Narrative-Report.pdf',
        uploader: 'Juan Dela Cruz',
        type: 'PDF',
        dateSubmitted: 'May 25, 2026',
      ),
      SubmittedFileItem(
        name: '${activity.code}-Attendance-Sheet.xlsx',
        uploader: 'Maria Santos',
        type: 'Spreadsheet',
        dateSubmitted: 'May 27, 2026',
      ),
      SubmittedFileItem(
        name: '${activity.code}-Photo-Documentation.zip',
        uploader: 'Admin User',
        type: 'Archive',
        dateSubmitted: 'May 29, 2026',
      ),
    ];
  }

  Future<void> _editActivity() async {
    final ActivityDraft? draft = await showDialog<ActivityDraft>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return ActivityDetailsDialog(
          title: 'Edit Activity',
          buttonText: 'Save',
          initialTitle: _activity.title,
          initialDescription: _activity.description,
          initialCode: _activity.code,
          initialComponentName: _activity.componentName,
          initialScheduleFrom: _activity.scheduleFrom,
          initialScheduleTo: _activity.scheduleTo,
        );
      },
    );

    if (draft == null || draft.title.trim().isEmpty) {
      return;
    }

    final ActivityAdminItem updatedActivity = _activity.copyWith(
      title: draft.title.trim(),
      description: draft.description.trim().isEmpty
          ? 'No description added yet.'
          : draft.description.trim(),
      code: draft.code.trim().isEmpty ? _activity.code : draft.code.trim(),
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
      _activity = updatedActivity;
    });

    widget.onActivityChanged(updatedActivity);
  }

  void _deleteActivity() {
    showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return DeleteConfirmationDialog(
          title: 'Delete Activity',
          message:
              'Are you sure you want to delete "${_activity.title}" from activities? This cannot be undone.',
        );
      },
    ).then((confirmed) {
      if (confirmed != true) {
        return;
      }

      widget.onActivityDeleted();
      Navigator.pop(context);
    });
  }

  Future<void> _editFile(SubmittedFileItem file) async {
    final SubmittedFileItem? draft = await showDialog<SubmittedFileItem>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return SubmittedFileDialog(
          title: 'Edit Submitted File',
          buttonText: 'Save',
          initialFile: file,
        );
      },
    );

    if (draft == null || draft.name.trim().isEmpty) {
      return;
    }

    setState(() {
      final int index = _submittedFiles.indexOf(file);

      if (index != -1) {
        _submittedFiles[index] = draft;
      }
    });
  }

  void _deleteFile(SubmittedFileItem file) {
    showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return DeleteConfirmationDialog(
          title: 'Delete File',
          message:
              'Are you sure you want to delete "${file.name}" from submitted files? This cannot be undone.',
        );
      },
    ).then((confirmed) {
      if (confirmed != true) {
        return;
      }

      setState(() {
        _submittedFiles.remove(file);
      });
    });
  }

  void _goToProjectsPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ProjectsAdminScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double clampedProgress = _activity.percent.clamp(0, 100).toDouble();
    final Color progressColor = ActivitiesStyles.progressColor(clampedProgress);

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
                                  _buildBreadcrumbs(),
                                  const SizedBox(height: 24),
                                  _buildActivityDetailsCard(
                                    progressColor: progressColor,
                                    clampedProgress: clampedProgress,
                                  ),
                                  const SizedBox(height: 26),
                                  _buildSubmittedFilesSection(),
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

  Widget _buildBreadcrumbs() {
    return Wrap(
      spacing: 14,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        BackTextButton(
          label: 'Back to Projects',
          onTap: _goToProjectsPage,
        ),
        BackTextButton(
          label: 'Back to ${widget.projectTitle} Activities',
          onTap: widget.onBackToProjectActivities ?? () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildActivityDetailsCard({
    required Color progressColor,
    required double clampedProgress,
  }) {
    return Container(
      decoration: ActivitiesStyles.cardDecoration,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _activity.title,
                      style: ActivitiesStyles.pageTitle,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _activity.program,
                          style: ActivitiesStyles.meta.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.blue,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ActivityStatusChip(status: _activity.status),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _activity.description,
                      style: ActivitiesStyles.description,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ActivityIconActionButton(
                tooltip: 'Edit activity',
                icon: Icons.edit_outlined,
                onTap: _editActivity,
              ),
              const SizedBox(width: 10),
              ActivityIconActionButton(
                tooltip: 'Delete activity',
                icon: Icons.delete_outline_rounded,
                onTap: _deleteActivity,
                isDelete: true,
              ),
            ],
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              InfoPill(label: 'Code', value: _activity.code),
              InfoPill(label: 'Component', value: _activity.componentName),
              InfoPill(
                label: 'Schedule',
                value: '${_activity.scheduleFrom} - ${_activity.scheduleTo}',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: clampedProgress / 100,
                    backgroundColor: const Color(0xFFE0E0E0),
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                '${clampedProgress.toInt()}%',
                style: ActivitiesStyles.percentText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmittedFilesSection() {
    return Container(
      decoration: ActivitiesStyles.cardDecoration,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Submitted Files',
            style: ActivitiesStyles.sectionTitle,
          ),
          const SizedBox(height: 6),
          Text(
            'Files are viewable by all users. Admin users can edit or delete submitted file records.',
            style: ActivitiesStyles.description,
          ),
          const SizedBox(height: 20),
          if (_submittedFiles.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: ActivitiesStyles.softPanelDecoration,
              child: Text(
                'No submitted files yet.',
                style: ActivitiesStyles.description,
              ),
            )
          else
            Column(
              children: _submittedFiles
                  .map(
                    (file) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SubmittedFileCard(
                        file: file,
                        onEdit: () => _editFile(file),
                        onDelete: () => _deleteFile(file),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}


class ActivitiesAdminSidebar extends StatelessWidget {
  const ActivitiesAdminSidebar({
    super.key,
    required this.isExpanded,
  });

  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      clipBehavior: Clip.hardEdge,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      width: isExpanded
          ? ActivitiesStyles.expandedSidebarWidth
          : ActivitiesStyles.sidebarWidth,
      height: double.infinity,
      decoration: ActivitiesStyles.sidebarDecoration,
      child: Column(
        children: [
          const SizedBox(height: 24),
          isExpanded
              ? Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 22),
                    child: _ActivitiesSidebarMenuButton(),
                  ),
                )
              : Center(child: _ActivitiesSidebarMenuButton()),
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
              style: ActivitiesStyles.orgName,
            ),
            const SizedBox(height: 4),
            Text(
              '“Building Resiliency, Sustaining Development”',
              textAlign: TextAlign.center,
              style: ActivitiesStyles.orgTagline,
            ),
            const SizedBox(height: 44),
          ] else ...[
            const SizedBox(height: 126),
          ],
          _ActivitiesSidebarItem(
            icon: Icons.grid_view_rounded,
            label: 'Dashboard',
            selected: false,
            isExpanded: isExpanded,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/dashboard-admin');
            },
          ),
          _ActivitiesSidebarItem(
            icon: Icons.folder_open_rounded,
            label: 'Projects & Activities',
            selected: true,
            isExpanded: isExpanded,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/projects-admin');
            },
          ),
          _ActivitiesSidebarItem(
            icon: Icons.calendar_month_rounded,
            label: 'Calendar',
            selected: false,
            isExpanded: isExpanded,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/calendar-admin');
            },
          ),
          _ActivitiesSidebarItem(
            icon: Icons.person,
            label: 'Account Settings',
            selected: false,
            isExpanded: isExpanded,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/settings-admin');
            },
          ),
          _ActivitiesSidebarThemeToggle(isExpanded: isExpanded),
          _ActivitiesSidebarItem(
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
}


class _ActivitiesSidebarThemeToggle extends StatelessWidget {
  const _ActivitiesSidebarThemeToggle({
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
                style: ActivitiesStyles.sidebarLabel,
              ),
            ),
            const SizedBox(width: 12),
            const _ActivitiesSidebarToggleSwitch(),
          ],
        ],
      ),
    );
  }
}

class _ActivitiesSidebarToggleSwitch extends StatelessWidget {
  const _ActivitiesSidebarToggleSwitch();

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

class _ActivitiesSidebarMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

class _ActivitiesSidebarItem extends StatelessWidget {
  const _ActivitiesSidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.isExpanded,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool isExpanded;
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
          color: selected ? ActivitiesStyles.selectedSidebar : Colors.transparent,
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
                    style: ActivitiesStyles.sidebarLabel,
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

class BackTextButton extends StatefulWidget {
  const BackTextButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  State<BackTextButton> createState() => _BackTextButtonState();
}

class _BackTextButtonState extends State<BackTextButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 160),
          opacity: _hovered ? 0.7 : 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.chevron_left_rounded,
                size: 24,
                color: AppColors.blue,
              ),
              Text(
                widget.label,
                style: ActivitiesStyles.backText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityStatusChip extends StatelessWidget {
  const ActivityStatusChip({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final Color color = ActivitiesStyles.statusColor(status);

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: AppText.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityIconActionButton extends StatefulWidget {
  const ActivityIconActionButton({
    super.key,
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
  State<ActivityIconActionButton> createState() =>
      _ActivityIconActionButtonState();
}

class _ActivityIconActionButtonState extends State<ActivityIconActionButton> {
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
              size: 20,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

class InfoPill extends StatelessWidget {
  const InfoPill({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: ActivitiesStyles.softPanelDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: ActivitiesStyles.label.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: ActivitiesStyles.value,
          ),
        ],
      ),
    );
  }
}

class ActivityDetailsDialog extends StatefulWidget {
  const ActivityDetailsDialog({
    super.key,
    required this.title,
    required this.buttonText,
    this.initialTitle = '',
    this.initialDescription = '',
    this.initialCode = '',
    this.initialComponentName = '',
    this.initialScheduleFrom = '',
    this.initialScheduleTo = '',
  });

  final String title;
  final String buttonText;
  final String initialTitle;
  final String initialDescription;
  final String initialCode;
  final String initialComponentName;
  final String initialScheduleFrom;
  final String initialScheduleTo;

  @override
  State<ActivityDetailsDialog> createState() => _ActivityDetailsDialogState();
}

class _ActivityDetailsDialogState extends State<ActivityDetailsDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _codeController;
  late final TextEditingController _componentController;
  late final TextEditingController _scheduleFromController;
  late final TextEditingController _scheduleToController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(
      text: widget.initialDescription,
    );
    _codeController = TextEditingController(text: widget.initialCode);
    _componentController = TextEditingController(
      text: widget.initialComponentName,
    );
    _scheduleFromController = TextEditingController(
      text: widget.initialScheduleFrom,
    );
    _scheduleToController = TextEditingController(text: widget.initialScheduleTo);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    _componentController.dispose();
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
      ActivityDraft(
        title: title,
        description: _descriptionController.text.trim(),
        code: _codeController.text.trim(),
        componentName: _componentController.text.trim(),
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
        constraints: const BoxConstraints(
          maxWidth: 620,
        ),
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
                DialogField(
                  label: 'Title*',
                  controller: _titleController,
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
                    Expanded(
                      child: DialogField(
                        label: 'Code',
                        controller: _codeController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DialogField(
                        label: 'Component Name',
                        controller: _componentController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DialogField(
                        label: 'Schedule From',
                        controller: _scheduleFromController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DialogField(
                        label: 'Schedule To',
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
}

class DialogField extends StatelessWidget {
  const DialogField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.height = 46,
    this.hintText,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final double height;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
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
          height: height,
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            textInputAction:
                maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
            style: AppText.dmSans(
              fontSize: 15,
              color: AppColors.blue,
            ),
            decoration: ActivitiesStyles.fieldDecoration(hintText: hintText),
          ),
        ),
      ],
    );
  }
}

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

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
                title,
                textAlign: TextAlign.center,
                style: AppText.calSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                message,
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
                    text: 'Delete',
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

class SubmittedFileDialog extends StatefulWidget {
  const SubmittedFileDialog({
    super.key,
    required this.title,
    required this.buttonText,
    required this.initialFile,
  });

  final String title;
  final String buttonText;
  final SubmittedFileItem initialFile;

  @override
  State<SubmittedFileDialog> createState() => _SubmittedFileDialogState();
}

class _SubmittedFileDialogState extends State<SubmittedFileDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _uploaderController;
  late final TextEditingController _typeController;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialFile.name);
    _uploaderController = TextEditingController(
      text: widget.initialFile.uploader,
    );
    _typeController = TextEditingController(text: widget.initialFile.type);
    _dateController = TextEditingController(
      text: widget.initialFile.dateSubmitted,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _uploaderController.dispose();
    _typeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _submit() {
    final String name = _nameController.text.trim();

    if (name.isEmpty) {
      return;
    }

    Navigator.pop(
      context,
      SubmittedFileItem(
        name: name,
        uploader: _uploaderController.text.trim().isEmpty
            ? 'Unknown User'
            : _uploaderController.text.trim(),
        type: _typeController.text.trim().isEmpty
            ? 'File'
            : _typeController.text.trim(),
        dateSubmitted: _dateController.text.trim().isEmpty
            ? 'Not set'
            : _dateController.text.trim(),
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
              DialogField(label: 'File Name*', controller: _nameController),
              const SizedBox(height: 16),
              DialogField(label: 'Uploader', controller: _uploaderController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DialogField(label: 'File Type', controller: _typeController),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DialogField(label: 'Date Submitted', controller: _dateController),
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

class SubmittedFileCard extends StatelessWidget {
  const SubmittedFileCard({
    super.key,
    required this.file,
    required this.onEdit,
    required this.onDelete,
  });

  final SubmittedFileItem file;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ActivitiesStyles.softPanelDecoration,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.insert_drive_file_outlined,
              color: AppColors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ActivitiesStyles.label,
                ),
                const SizedBox(height: 4),
                Text(
                  '${file.type} • Submitted by ${file.uploader} • ${file.dateSubmitted}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ActivitiesStyles.meta,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ActivityIconActionButton(
            tooltip: 'View file',
            icon: Icons.visibility_outlined,
            onTap: () {},
          ),
          const SizedBox(width: 10),
          ActivityIconActionButton(
            tooltip: 'Edit file',
            icon: Icons.edit_outlined,
            onTap: onEdit,
          ),
          const SizedBox(width: 10),
          ActivityIconActionButton(
            tooltip: 'Delete file',
            icon: Icons.delete_outline_rounded,
            onTap: onDelete,
            isDelete: true,
          ),
        ],
      ),
    );
  }
}
