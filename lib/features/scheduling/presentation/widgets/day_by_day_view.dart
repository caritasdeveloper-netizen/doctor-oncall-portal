import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/departments/application/department_provider.dart';
import 'package:oncall_doctor/features/departments/domain/department.dart';
import 'package:oncall_doctor/features/doctors/application/doctor_provider.dart';
import 'package:oncall_doctor/features/doctors/domain/doctor.dart';
import 'package:oncall_doctor/features/scheduling/application/scheduling_controller.dart';
import 'package:oncall_doctor/features/scheduling/application/scheduling_ui_providers.dart';
import 'package:oncall_doctor/features/scheduling/presentation/widgets/department_accordion_card.dart';

class DayByDayView extends ConsumerWidget {
  final bool onlyList;
  final bool useOverlapInjector;
  const DayByDayView({super.key, this.onlyList = false, this.useOverlapInjector = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(schedulingControllerProvider);
    final departmentsAsync = ref.watch(departmentsProvider);
    final doctorsAsync = ref.watch(doctorsProvider);

    if (onlyList) {
      return _buildDepartmentList(context, departmentsAsync, state, doctorsAsync);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Top bar: date navigator + stats ───────────────────────────
        _DayByDayHeader(state: state, ref: ref),

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

        // Department list
        Expanded(
          child: _buildDepartmentList(context, departmentsAsync, state, doctorsAsync),
        ),
      ],
    );
  }

  Widget _buildDepartmentList(BuildContext context, AsyncValue<List<Department>> departmentsAsync, SchedulingState state, AsyncValue<List<Doctor>> doctorsAsync) {
    return departmentsAsync.when(
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

        return CustomScrollView(
          slivers: [
            if (useOverlapInjector)
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index.isOdd) return const SizedBox(height: 12);
                    final itemIndex = index ~/ 2;
                    final dept = filtered[itemIndex];
                    final draft = state.draftSchedules[dept.id];
                    return DepartmentAccordionCard(
                      department: dept,
                      draft: draft,
                      doctorsAsync: doctorsAsync,
                    );
                  },
                  childCount: filtered.length > 0 ? filtered.length * 2 - 1 : 0,
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      ),
      error: (e, s) => Center(child: Text('Error: $e')),
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

// ── Shared Header Component ──────────────────────────────────────────────────

class _DayByDayHeader extends StatelessWidget {
  final SchedulingState state;
  final WidgetRef ref;

  const _DayByDayHeader({required this.state, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        children: [
          // Header Row: Swaps between Date Info and Search Bar
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: ref.watch(schedulingSearchExpandedProvider)
                ? _ExpandedSearchBar(state: state, ref: ref)
                : Row(
                    key: const ValueKey('date_header'),
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
                    ],
                  ),
          ),
          const SizedBox(height: 16),

          // 7-day pill strip with arrows
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 600;
              return Column(
                children: [
                  Row(
                    children: [
                      _NavArrowButton(
                        icon: Icons.chevron_left_rounded,
                        tooltip: 'Previous day',
                        onTap: () {
                          final prev = state.selectedDate.subtract(const Duration(days: 1));
                          ref.read(schedulingControllerProvider.notifier).setDate(prev);
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _DateStrip(state: state, ref: ref)),
                      const SizedBox(width: 12),
                      _NavArrowButton(
                        icon: Icons.chevron_right_rounded,
                        tooltip: 'Next day',
                        onTap: () {
                          final next = state.selectedDate.add(const Duration(days: 1));
                          ref.read(schedulingControllerProvider.notifier).setDate(next);
                        },
                      ),
                      if (!isSmall) ...[
                        const Spacer(),
                        _NavArrowButton(
                          icon: Icons.search_rounded,
                          tooltip: 'Search departments',
                          onTap: () => ref.read(schedulingSearchExpandedProvider.notifier).setExpanded(true),
                        ),
                        const SizedBox(width: 8),
                        _TodayButton(
                          isToday: DateUtils.isSameDay(state.selectedDate, DateTime.now()),
                          onTap: () => ref.read(schedulingControllerProvider.notifier).setDate(DateTime.now()),
                        ),
                      ],
                    ],
                  ),
                  if (isSmall) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Spacer(),
                        _NavArrowButton(
                          icon: Icons.search_rounded,
                          tooltip: 'Search departments',
                          onTap: () => ref.read(schedulingSearchExpandedProvider.notifier).setExpanded(true),
                        ),
                        const SizedBox(width: 8),
                        _TodayButton(
                          isToday: DateUtils.isSameDay(state.selectedDate, DateTime.now()),
                          onTap: () => ref.read(schedulingControllerProvider.notifier).setDate(DateTime.now()),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Sticky Header Delegate ───────────────────────────────────────────────────

class DayByDayHeaderDelegate extends SliverPersistentHeaderDelegate {
  final SchedulingState state;
  final WidgetRef ref;
  final bool isSmall;
  final bool isSearchExpanded;

  DayByDayHeaderDelegate({
    required this.state,
    required this.ref,
    required this.isSmall,
    required this.isSearchExpanded,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: overlapsContent ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: _DayByDayHeader(state: state, ref: ref),
    );
  }

  @override
  double get maxExtent => isSmall ? 240 : 190;

  @override
  double get minExtent => isSmall ? 240 : 190;

  @override
  bool shouldRebuild(covariant DayByDayHeaderDelegate oldDelegate) {
    return oldDelegate.state != state || 
           oldDelegate.isSmall != isSmall || 
           oldDelegate.isSearchExpanded != isSearchExpanded;
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

    return SizedBox(
      height: 72,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: dates.map((date) {
            final isSelected = DateUtils.isSameDay(date, state.selectedDate);
            final isToday = DateUtils.isSameDay(date, DateTime.now());

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () =>
                    ref.read(schedulingControllerProvider.notifier).setDate(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52,
                  height: 72,
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
              ),
            );
          }).toList(),
        ),
      ),
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

// ── Expanded Search Bar ──────────────────────────────────────────────────────

class _ExpandedSearchBar extends StatelessWidget {
  final SchedulingState state;
  final WidgetRef ref;

  const _ExpandedSearchBar({required this.state, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('search_header'),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          const Icon(
            Icons.search_rounded,
            color: AppTheme.primaryColor,
            size: 26,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              autofocus: true,
              onChanged: (v) => ref
                  .read(schedulingControllerProvider.notifier)
                  .setSearchQuery(v),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: AppTheme.textColor,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'Search department…',
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 22),
              ),
            ),
          ),
          // Close/Clear button
          IconButton(
            onPressed: () {
              ref.read(schedulingControllerProvider.notifier).setSearchQuery('');
              ref.read(schedulingSearchExpandedProvider.notifier).setExpanded(false);
            },
            icon: const Icon(Icons.close_rounded),
            color: AppTheme.textSecondaryColor,
            iconSize: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
