import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/departments/application/department_provider.dart';
import 'package:oncall_doctor/features/doctors/application/doctor_provider.dart';
import 'package:oncall_doctor/features/scheduling/application/scheduling_controller.dart';
import 'package:oncall_doctor/features/scheduling/domain/schedule.dart';
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
        // Horizontal Date Strip & Stats Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateStrip(context, ref, state),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              _buildStatsSummary(state, departmentsAsync),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Search and Filter Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppTheme.textSecondaryColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: (v) => ref.read(schedulingControllerProvider.notifier).setSearchQuery(v),
                    style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppTheme.textColor),
                    decoration: InputDecoration(
                      hintText: 'Filter by department name...',
                      hintStyle: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondaryColor, fontSize: 14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
                if (state.searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () => ref.read(schedulingControllerProvider.notifier).setSearchQuery(''),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Department List/Grid
        Expanded(
          child: departmentsAsync.when(
            data: (departments) {
              final filteredDepts = departments
                  .where((d) => d.name.toLowerCase().contains(state.searchQuery.toLowerCase()))
                  .toList();

              if (filteredDepts.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 120),
                itemCount: filteredDepts.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final dept = filteredDepts[index];
                  final draft = state.draftSchedules[dept.id];

                  return DepartmentAccordionCard(
                    department: dept,
                    draft: draft,
                    doctorsAsync: doctorsAsync,
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildDateStrip(BuildContext context, WidgetRef ref, SchedulingState state) {
    final dates = List.generate(7, (i) {
      final start = state.selectedDate.subtract(const Duration(days: 3));
      return start.add(Duration(days: i));
    });

    return Row(
      children: dates.map((date) {
        final isSelected = DateUtils.isSameDay(date, state.selectedDate);
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            onTap: () => ref.read(schedulingControllerProvider.notifier).setDate(date),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 64,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ] : null,
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('E').format(date).toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white.withOpacity(0.7) : AppTheme.textSecondaryColor,
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
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatsSummary(SchedulingState state, AsyncValue<List<dynamic>> deptsAsync) {
    return deptsAsync.when(
      data: (depts) {
        int staffed = 0;
        for (final dept in depts) {
          final draft = state.draftSchedules[dept.id];
          final isDayStaffed = (draft?.dayFirstOnCallDoctorIds.isNotEmpty ?? false) && 
                              (draft?.daySecondOnCallDoctorIds.isNotEmpty ?? false);
          final isNightStaffed = (draft?.nightFirstOnCallDoctorIds.isNotEmpty ?? false) && 
                                (draft?.nightSecondOnCallDoctorIds.isNotEmpty ?? false);
          if (isDayStaffed && isNightStaffed) staffed++;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Row(
            children: [
              _buildStatItem('All', depts.length.toString(), Colors.blue),
              _buildStatDivider(),
              _buildStatItem('Staffed', staffed.toString(), AppTheme.primaryColor),
              _buildStatDivider(),
              _buildStatItem('Needs Attention', (depts.length - staffed).toString(), Colors.orange),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 24,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: AppTheme.borderColor,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_rounded, size: 64, color: AppTheme.textSecondaryColor.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            'No matching departments',
            style: GoogleFonts.plusJakartaSans(
              color: AppTheme.textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
