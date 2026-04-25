import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/departments/application/department_provider.dart';
import 'package:oncall_doctor/features/doctors/application/doctor_provider.dart';
import 'package:oncall_doctor/features/scheduling/application/scheduling_controller.dart';
import 'package:oncall_doctor/features/scheduling/presentation/widgets/department_accordion_card.dart';

class DayByDayView extends ConsumerWidget {
  const DayByDayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(schedulingControllerProvider);
    final departmentsAsync = ref.watch(departmentsProvider);
    final doctorsAsync = ref.watch(doctorsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Top bar: date navigator + stats ───────────────────────────
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Column(
            children: [
              // Month label + prev/next arrows
              Row(
                children: [
                  Text(
                    DateFormat('MMMM yyyy').format(state.selectedDate),
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: AppTheme.textColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  _NavArrowButton(
                    icon: Icons.chevron_left_rounded,
                    tooltip: 'Previous day',
                    onTap: () {
                      final prev = state.selectedDate
                          .subtract(const Duration(days: 1));
                      ref
                          .read(schedulingControllerProvider.notifier)
                          .setDate(prev);
                    },
                  ),
                  const SizedBox(width: 4),
                  _NavArrowButton(
                    icon: Icons.chevron_right_rounded,
                    tooltip: 'Next day',
                    onTap: () {
                      final next =
                          state.selectedDate.add(const Duration(days: 1));
                      ref
                          .read(schedulingControllerProvider.notifier)
                          .setDate(next);
                    },
                  ),
                  const SizedBox(width: 8),
                  // Today button
                  _TodayButton(
                    isToday: DateUtils.isSameDay(
                      state.selectedDate,
                      DateTime.now(),
                    ),
                    onTap: () => ref
                        .read(schedulingControllerProvider.notifier)
                        .setDate(DateTime.now()),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 7-day pill strip
              SizedBox(
                height: 72,
                child: _DateStrip(state: state, ref: ref),
              ),
              const SizedBox(height: 16),

              // Stats row
              _StatsBar(state: state, deptsAsync: departmentsAsync),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Thin shadow separator
        Container(
          height: 1,
          decoration: BoxDecoration(
            color: AppTheme.borderColor.withOpacity(0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: AppTheme.textSecondaryColor,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (v) => ref
                        .read(schedulingControllerProvider.notifier)
                        .setSearchQuery(v),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppTheme.textColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search department…',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
                if (state.searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () => ref
                        .read(schedulingControllerProvider.notifier)
                        .setSearchQuery(''),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.clear_rounded,
                        size: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Department list
        Expanded(
          child: departmentsAsync.when(
            data: (departments) {
              final filtered = departments
                  .where(
                    (d) => d.name
                        .toLowerCase()
                        .contains(state.searchQuery.toLowerCase()),
                  )
                  .toList();

              if (filtered.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final dept = filtered[index];
                  final draft = state.draftSchedules[dept.id];
                  return DepartmentAccordionCard(
                    department: dept,
                    draft: draft,
                    doctorsAsync: doctorsAsync,
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            ),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 56,
            color: AppTheme.textSecondaryColor.withOpacity(0.2),
          ),
          const SizedBox(height: 12),
          Text(
            'No departments found',
            style: GoogleFonts.plusJakartaSans(
              color: AppTheme.textSecondaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try a different search term',
            style: GoogleFonts.plusJakartaSans(
              color: AppTheme.textSecondaryColor.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Date Strip ────────────────────────────────────────────────────────────────

class _DateStrip extends StatelessWidget {
  final SchedulingState state;
  final WidgetRef ref;

  const _DateStrip({required this.state, required this.ref});

  @override
  Widget build(BuildContext context) {
    final dates = List.generate(7, (i) {
      final start = state.selectedDate.subtract(const Duration(days: 3));
      return start.add(Duration(days: i));
    });

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: dates.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final date = dates[index];
        final isSelected = DateUtils.isSameDay(date, state.selectedDate);
        final isToday = DateUtils.isSameDay(date, DateTime.now());

        return GestureDetector(
          onTap: () =>
              ref.read(schedulingControllerProvider.notifier).setDate(date),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryColor
                    : isToday
                    ? AppTheme.primaryColor.withOpacity(0.4)
                    : AppTheme.borderColor,
                width: isSelected ? 0 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('E').format(date).toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? Colors.white.withOpacity(0.7)
                        : AppTheme.textSecondaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date.day.toString(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : AppTheme.textColor,
                  ),
                ),
                if (isToday && !isSelected)
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Stats Bar ─────────────────────────────────────────────────────────────────

class _StatsBar extends StatelessWidget {
  final SchedulingState state;
  final AsyncValue<List<dynamic>> deptsAsync;

  const _StatsBar({required this.state, required this.deptsAsync});

  @override
  Widget build(BuildContext context) {
    return deptsAsync.when(
      data: (depts) {
        int staffed = 0;
        int partial = 0;
        for (final dept in depts) {
          final draft = state.draftSchedules[dept.id];
          final isDayStaffed =
              (draft?.dayFirstOnCallDoctorIds.isNotEmpty ?? false) &&
              (draft?.daySecondOnCallDoctorIds.isNotEmpty ?? false);
          final isNightStaffed =
              (draft?.nightFirstOnCallDoctorIds.isNotEmpty ?? false) &&
              (draft?.nightSecondOnCallDoctorIds.isNotEmpty ?? false);
          if (isDayStaffed && isNightStaffed) {
            staffed++;
          } else if (isDayStaffed || isNightStaffed) {
            partial++;
          }
        }
        final needs = depts.length - staffed - partial;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Row(
            children: [
              _StatChip(
                label: 'Total',
                value: depts.length.toString(),
                color: AppTheme.textColor,
                icon: Icons.domain_rounded,
              ),
              _StatDivider(),
              _StatChip(
                label: 'Staffed',
                value: staffed.toString(),
                color: const Color(0xFF16A34A),
                icon: Icons.check_circle_rounded,
              ),
              _StatDivider(),
              _StatChip(
                label: 'Partial',
                value: partial.toString(),
                color: Colors.orange.shade700,
                icon: Icons.warning_amber_rounded,
              ),
              _StatDivider(),
              _StatChip(
                label: 'Empty',
                value: needs.toString(),
                color: Colors.red.shade500,
                icon: Icons.radio_button_unchecked_rounded,
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: color.withOpacity(0.7)),
          const SizedBox(width: 6),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: color,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: AppTheme.borderColor,
    );
  }
}

// ── Nav Arrow Button ──────────────────────────────────────────────────────────

class _NavArrowButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _NavArrowButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Icon(icon, size: 18, color: AppTheme.textSecondaryColor),
        ),
      ),
    );
  }
}

// ── Today Button ──────────────────────────────────────────────────────────────

class _TodayButton extends StatelessWidget {
  final bool isToday;
  final VoidCallback onTap;

  const _TodayButton({required this.isToday, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isToday ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isToday
              ? AppTheme.primaryColor.withOpacity(0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isToday
                ? AppTheme.primaryColor.withOpacity(0.3)
                : AppTheme.borderColor,
          ),
        ),
        child: Text(
          'Today',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isToday ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
          ),
        ),
      ),
    );
  }
}
