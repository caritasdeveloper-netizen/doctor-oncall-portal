import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/core/widgets/shimmer_loading.dart';
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
    // Derive loading from the actual stream — true while Firestore hasn't
    // delivered the first event for the selected date yet.
    final schedulesAsync = ref.watch(dailySchedulesProvider(state.selectedDate));
    final isLoadingSchedule = schedulesAsync.isLoading;

    if (onlyList) {
      return _buildDepartmentList(context, departmentsAsync, state, doctorsAsync, isLoadingSchedule);
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

        // Department list (shimmer while loading)
        Expanded(
          child: _buildDepartmentList(context, departmentsAsync, state, doctorsAsync, isLoadingSchedule),
        ),
      ],
    );
  }

  Widget _buildDepartmentList(
    BuildContext context,
    AsyncValue<List<Department>> departmentsAsync,
    SchedulingState state,
    AsyncValue<List<Doctor>> doctorsAsync,
    bool isLoadingSchedule,
  ) {
    // Show shimmer while schedule data is loading for the selected date.
    // IMPORTANT: when useOverlapInjector is true (NestedScrollView context),
    // the SliverOverlapInjector must still be emitted to avoid the
    // "layoutExtent exceeds paintExtent" SliverGeometry error.
    Widget contentSliver;

    if (isLoadingSchedule) {
      contentSliver = SliverPadding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index.isOdd) return const SizedBox(height: 12);
              return const ShimmerDepartmentAccordion();
            },
            childCount: 11,
          ),
        ),
      );
    } else {
      contentSliver = departmentsAsync.when(
        data: (departments) {
          final filtered = departments
              .where((d) => d.name.toLowerCase().contains(state.searchQuery.toLowerCase()))
              .toList();

          if (filtered.isEmpty) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
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
          );
        },
        loading: () => SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index.isOdd) return const SizedBox(height: 12);
                return const ShimmerDepartmentAccordion();
              },
              childCount: 11,
            ),
          ),
        ),
        error: (e, s) => SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: Text('Error: $e')),
        ),
      );
    }

    return CustomScrollView(
      physics: isLoadingSchedule || departmentsAsync.isLoading ? const NeverScrollableScrollPhysics() : null,
      slivers: [
        if (useOverlapInjector)
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
        contentSliver,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row: Month/Year + Actions
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: ref.watch(schedulingSearchExpandedProvider)
                ? _ExpandedSearchBar(state: state, ref: ref)
                : Row(
                    key: const ValueKey('date_header'),
                    children: [
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: state.selectedDate.isBefore(DateUtils.dateOnly(DateTime.now())) 
                                ? DateUtils.dateOnly(DateTime.now()) 
                                : state.selectedDate,
                            firstDate: DateUtils.dateOnly(DateTime.now()),
                            lastDate: DateTime(2100),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppTheme.primaryColor,
                                    onPrimary: Colors.white,
                                    onSurface: AppTheme.textColor,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            ref.read(schedulingControllerProvider.notifier).setDate(picked);
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_rounded,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
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
                      ),
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
          ),
          const SizedBox(height: 16),

          // 7-day pill strip with arrows
          Row(
            children: [
              _NavArrowButton(
                icon: Icons.chevron_left_rounded,
                tooltip: 'Previous day',
                onTap: DateUtils.isSameDay(state.selectedDate, DateTime.now()) || state.selectedDate.isBefore(DateTime.now())
                    ? null
                    : () {
                        final prev = state.selectedDate.subtract(const Duration(days: 1));
                        ref.read(schedulingControllerProvider.notifier).setDate(prev);
                      },
              ),
              const SizedBox(width: 12),
              Expanded(child: _DateStrip(state: state)),
              const SizedBox(width: 12),
              _NavArrowButton(
                icon: Icons.chevron_right_rounded,
                tooltip: 'Next day',
                onTap: () {
                  final next = state.selectedDate.add(const Duration(days: 1));
                  ref.read(schedulingControllerProvider.notifier).setDate(next);
                },
              ),
            ],
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
  final bool isSearchExpanded;

  DayByDayHeaderDelegate({
    required this.state,
    required this.ref,
    required this.isSearchExpanded,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      // Force rendered height to equal declared sliver extent.
      // Without this the Container takes its natural content height (≈147px)
      // while the delegate reports maxExtent=150, triggering:
      //   "SliverGeometry is not valid: layoutExtent exceeds paintExtent"
      height: maxExtent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: overlapsContent
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: _DayByDayHeader(state: state, ref: ref),
      ),
    );
  }

  @override
  double get maxExtent => isSearchExpanded ? 180 : 150;

  @override
  double get minExtent => isSearchExpanded ? 180 : 150;

  @override
  bool shouldRebuild(covariant DayByDayHeaderDelegate oldDelegate) {
    return oldDelegate.state != state || 
           oldDelegate.isSearchExpanded != isSearchExpanded;
  }
}

// ── Date Strip ────────────────────────────────────────────────────────────────

class _DateStrip extends ConsumerStatefulWidget {
  final SchedulingState state;

  const _DateStrip({super.key, required this.state});

  @override
  ConsumerState<_DateStrip> createState() => _DateStripState();
}

class _DateStripState extends ConsumerState<_DateStrip> {
  late ScrollController _scrollController;
  final double _itemWidth = 60.0; // 52 width + 8 padding

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected(animate: false));
  }

  @override
  void didUpdateWidget(_DateStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.selectedDate != widget.state.selectedDate) {
      _scrollToSelected();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelected({bool animate = true}) {
    if (!_scrollController.hasClients) return;

    final today = DateUtils.dateOnly(DateTime.now());
    final baseDate = today.subtract(const Duration(days: 30));
    final index = widget.state.selectedDate.difference(baseDate).inDays;
    if (index < 0) return;

    final targetOffset = index * _itemWidth;

    if (animate) {
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.jumpTo(targetOffset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final baseDate = today.subtract(const Duration(days: 30));
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = (constraints.maxWidth - 52) / 2;
        
        return SizedBox(
          height: 65,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            physics: const BouncingScrollPhysics(),
            itemCount: 730 + 30, // 2 years + 30 days past
            itemBuilder: (context, index) {
              final date = baseDate.add(Duration(days: index));
              final isSelected = DateUtils.isSameDay(date, widget.state.selectedDate);
              final isToday = DateUtils.isSameDay(date, today);
              final isPast = date.isBefore(today);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: isPast ? null : () => ref.read(schedulingControllerProvider.notifier).setDate(date),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52,
                    height: 65,
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : isToday
                                ? AppTheme.primaryColor.withOpacity(0.4)
                                : isPast
                                    ? AppTheme.borderColor.withOpacity(0.3)
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
                    child: Opacity(
                      opacity: isPast ? 0.4 : 1.0,
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ── Nav Arrow Button ──────────────────────────────────────────────────────────

class _NavArrowButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  const _NavArrowButton({
    required this.icon,
    required this.tooltip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null;
    return Tooltip(
      message: isDisabled ? '' : tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDisabled ? Colors.transparent : AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isDisabled ? AppTheme.borderColor.withOpacity(0.3) : AppTheme.borderColor),
          ),
          child: Icon(icon, size: 16, color: isDisabled ? AppTheme.textSecondaryColor.withOpacity(0.2) : AppTheme.textSecondaryColor),
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
