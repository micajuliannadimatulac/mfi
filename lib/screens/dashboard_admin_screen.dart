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

  void _toggleSidebar() {
    setState(() {
      _sidebarExpanded = !_sidebarExpanded;
    });
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
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _DashboardHeader(),
                          SizedBox(height: 28),
                          _HeroCard(),
                          SizedBox(height: 40),
                          _OverviewTitle(),
                          SizedBox(height: 28),
                          _ProgramActionRow(),
                          SizedBox(height: 30),
                          _OverviewCards(),
                          SizedBox(height: 32),
                          _ProjectsPanel(),
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
  const _ProgramActionRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _DashboardButton(
          text: 'IBG',
          width: 68,
          onTap: () {},
        ),
        const SizedBox(width: 14),
        _DashboardButton(
          text: 'DSS',
          width: 70,
          onTap: () {},
        ),
        const SizedBox(width: 14),
        _DashboardButton(
          text: 'ENVI',
          width: 76,
          onTap: () {},
        ),
        const SizedBox(width: 14),
        _DashboardButton(
          text: 'KMI',
          width: 68,
          onTap: () {},
        ),
        const Spacer(),
        _DashboardButton(
          text: '+ Add Project',
          width: 138,
          filled: true,
          onTap: () {},
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
      type:
          filled ? AuthButtonType.dashboardFilled : AuthButtonType.dashboardOutline,
      onTap: onTap,
      textStyle: filled ? DashboardStyles.buttonText : DashboardStyles.chipText,
    );
  }
}

class _OverviewCards extends StatelessWidget {
  const _OverviewCards();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _CalendarCard(),
        ),
        SizedBox(width: 24),
        Expanded(
          child: _CompletionCard(),
        ),
      ],
    );
  }
}

class _CompletionCard extends StatelessWidget {
  const _CompletionCard();

  @override
  Widget build(BuildContext context) {
    const double completionPercent = 70;
    final Color progressColor = DashboardStyles.progressColor(
      completionPercent,
    );

    return Container(
      height: 420,
      decoration: DashboardStyles.cardDecoration,
      padding: const EdgeInsets.symmetric(vertical: 38),
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
          Text(
            'IBG',
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
    return SizedBox(
      width: 255,
      height: 255,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(255, 255),
            painter: _DonutPainter(
              percent: percent,
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
                '${percent.toInt()}%',
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
          date.month == _displayedMonth.month && date.year == _displayedMonth.year;

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

    // Adjust these two values only.
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
                                style: DashboardStyles.calendarNumberText.copyWith(
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
  const _ProjectsPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 425,
      decoration: DashboardStyles.cardDecoration,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
      child: Row(
        children: [
          const SizedBox(
            width: 342,
            child: Column(
              children: [
                _ProjectTile(
                  title: 'Project1',
                  percent: 85,
                ),
                SizedBox(height: 22),
                _ProjectTile(
                  title: 'Project2',
                  percent: 50,
                ),
                SizedBox(height: 22),
                _ProjectTile(
                  title: 'Project3',
                  percent: 10,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 20,
            decoration: const BoxDecoration(
              color: Color(0xFFE3E3E3),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              width: 10,
              height: 110,
              decoration: const BoxDecoration(
                color: Color(0xFFC9C9C9),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({
    required this.title,
    required this.percent,
  });

  final String title;
  final int percent;

  @override
  Widget build(BuildContext context) {
    final double clampedPercent = percent.clamp(0, 100).toDouble();
    final Color progressColor = DashboardStyles.progressColor(
      clampedPercent,
    );

    return Container(
      height: 82,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: DashboardStyles.smallPanelDecoration,
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
                Text(
                  title,
                  style: DashboardStyles.cardTitle.copyWith(
                    fontSize: 17,
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
    );
  }
}