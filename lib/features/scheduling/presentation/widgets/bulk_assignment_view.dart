import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/departments/application/department_provider.dart';
import 'package:oncall_doctor/features/departments/domain/department.dart';
import 'package:oncall_doctor/features/doctors/domain/doctor.dart';
import 'package:oncall_doctor/features/doctors/application/doctor_provider.dart';
import 'package:oncall_doctor/features/scheduling/application/bulk_assignment_controller.dart';

class BulkAssignmentView extends ConsumerWidget {
  const BulkAssignmentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bulkAssignmentControllerProvider);
    final deptsAsync = ref.watch(departmentsProvider);
    final doctorsAsync = ref.watch(doctorsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            context,
            '01',
            'Select Departments',
            'Choose the departments for bulk assignment',
          ),
          deptsAsync.when(
            data: (depts) => _buildMultiSelect(
              context,
              label: 'Departments',
              selectedCount: state.selectedDepartmentIds.length,
              onTap: () => _showMultiPicker(
                context,
                title: 'Select Departments',
                items: depts
                    .map((Department d) => _PickerItem(id: d.id, name: d.name))
                    .toList(),
                initialSelectedIds: state.selectedDepartmentIds,
                onChanged: (ids) => ref
                    .read(bulkAssignmentControllerProvider.notifier)
                    .updateDepartments(ids),
              ),
            ),
            loading: () => const LinearProgressIndicator(minHeight: 2),
            error: (e, s) =>
                Text('Error: $e', style: const TextStyle(color: Colors.red)),
          ),
          const SizedBox(height: 40),

          _buildStepHeader(
            context,
            '02',
            'Select Date Range',
            'Define the timeframe for this schedule',
          ),
          _buildDateConfig(context, ref, state),
          const SizedBox(height: 40),

          _buildStepHeader(
            context,
            '03',
            'Staff Assignment',
            'Assign doctors to the selected slots',
          ),
          doctorsAsync.when(
            data: (docs) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShiftHeader('Day Shift', Icons.wb_sunny_rounded),
                const SizedBox(height: 12),
                _buildDoctorSelector(
                  context,
                  label: 'First On-Call',
                  selectedIds: state.dayFirstOnCallDoctorIds,
                  allDoctors: docs,
                  onChanged: (ids) => ref
                      .read(bulkAssignmentControllerProvider.notifier)
                      .updateDayFirstOnCall(ids),
                  icon: Icons.looks_one_rounded,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 20),
                _buildDoctorSelector(
                  context,
                  label: 'Second On-Call',
                  selectedIds: state.daySecondOnCallDoctorIds,
                  allDoctors: docs,
                  onChanged: (ids) => ref
                      .read(bulkAssignmentControllerProvider.notifier)
                      .updateDaySecondOnCall(ids),
                  icon: Icons.looks_two_rounded,
                  color: AppTheme.secondaryColor,
                ),
                const SizedBox(height: 32),
                _buildShiftHeader('Night Shift', Icons.nightlight_round),
                const SizedBox(height: 12),
                _buildDoctorSelector(
                  context,
                  label: 'First On-Call',
                  selectedIds: state.nightFirstOnCallDoctorIds,
                  allDoctors: docs,
                  onChanged: (ids) => ref
                      .read(bulkAssignmentControllerProvider.notifier)
                      .updateNightFirstOnCall(ids),
                  icon: Icons.looks_one_rounded,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 20),
                _buildDoctorSelector(
                  context,
                  label: 'Second On-Call',
                  selectedIds: state.nightSecondOnCallDoctorIds,
                  allDoctors: docs,
                  onChanged: (ids) => ref
                      .read(bulkAssignmentControllerProvider.notifier)
                      .updateNightSecondOnCall(ids),
                  icon: Icons.looks_two_rounded,
                  color: AppTheme.secondaryColor,
                ),
              ],
            ),
            loading: () => const LinearProgressIndicator(minHeight: 2),
            error: (e, s) =>
                Text('Error: $e', style: const TextStyle(color: Colors.red)),
          ),
          const SizedBox(height: 48),

          SizedBox(
            width: double.infinity,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient:
                    (state.selectedDepartmentIds.isEmpty ||
                        state.selectedDates.isEmpty ||
                        state.isApplying)
                    ? null
                    : const LinearGradient(
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.secondaryColor,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                boxShadow:
                    (state.selectedDepartmentIds.isEmpty ||
                        state.selectedDates.isEmpty ||
                        state.isApplying)
                    ? null
                    : [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: ElevatedButton(
                onPressed:
                    (state.selectedDepartmentIds.isEmpty ||
                        state.selectedDates.isEmpty ||
                        state.isApplying)
                    ? null
                    : () async {
                        await ref
                            .read(bulkAssignmentControllerProvider.notifier)
                            .apply();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Bulk assignment applied successfully',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppTheme.textColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.all(24),
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: state.isApplying
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Apply Bulk Assignment',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildStepHeader(
    BuildContext context,
    String number,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              number,
              style: GoogleFonts.plusJakartaSans(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textColor,
                    fontSize: 18,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftHeader(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondaryColor),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppTheme.textSecondaryColor,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Divider(color: AppTheme.borderColor.withOpacity(0.8))),
      ],
    );
  }

  Widget _buildMultiSelect(
    BuildContext context, {
    required String label,
    required int selectedCount,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedCount > 0;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.05 : 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.add_circle_outline_rounded,
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondaryColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  selectedCount == 0
                      ? 'Select $label'
                      : '$selectedCount $label selected',
                  style: GoogleFonts.plusJakartaSans(
                    color: isSelected
                        ? AppTheme.textColor
                        : AppTheme.textSecondaryColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.textSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateConfig(
    BuildContext context,
    WidgetRef ref,
    BulkAssignmentState state,
  ) {
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.8,
          children: [
            _buildPatternButton(
              context,
              label: 'Whole Month',
              icon: Icons.calendar_month_rounded,
              onTap: () {
                final now = DateTime.now();
                final days = DateTime(now.year, now.month + 1, 0).day;
                final dates = List.generate(
                  days,
                  (i) => DateTime(now.year, now.month, i + 1),
                );
                ref
                    .read(bulkAssignmentControllerProvider.notifier)
                    .updateDates(dates);
              },
            ),
            _buildPatternButton(
              context,
              label: 'Weekdays',
              icon: Icons.work_outline_rounded,
              onTap: () {
                final now = DateTime.now();
                final days = DateTime(now.year, now.month + 1, 0).day;
                final dates = List.generate(
                  days,
                  (i) => DateTime(now.year, now.month, i + 1),
                ).where((d) => d.weekday < 6).toList();
                ref
                    .read(bulkAssignmentControllerProvider.notifier)
                    .updateDates(dates);
              },
            ),
            _buildPatternButton(
              context,
              label: 'Weekends',
              icon: Icons.weekend_outlined,
              onTap: () {
                final now = DateTime.now();
                final days = DateTime(now.year, now.month + 1, 0).day;
                final dates = List.generate(
                  days,
                  (i) => DateTime(now.year, now.month, i + 1),
                ).where((d) => d.weekday >= 6).toList();
                ref
                    .read(bulkAssignmentControllerProvider.notifier)
                    .updateDates(dates);
              },
            ),
            _buildPatternButton(
              context,
              label: 'Custom Range',
              icon: Icons.date_range_rounded,
              onTap: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppTheme.primaryColor,
                          onPrimary: Colors.white,
                          onSurface: AppTheme.textColor,
                        ),
                        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
                      ),
                      child: child!,
                    );
                  },
                );
                if (range != null) {
                  final dates = <DateTime>[];
                  for (
                    int i = 0;
                    i <= range.end.difference(range.start).inDays;
                    i++
                  ) {
                    dates.add(range.start.add(Duration(days: i)));
                  }
                  ref
                      .read(bulkAssignmentControllerProvider.notifier)
                      .updateDates(dates);
                }
              },
            ),
          ],
        ),
        if (state.selectedDates.isNotEmpty) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    color: AppTheme.primaryColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Timeframe Configured',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${state.selectedDates.length} days selected (${DateFormat('MMM d').format(state.selectedDates.first)} - ${DateFormat('MMM d').format(state.selectedDates.last)})',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPatternButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primaryColor),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorSelector(
    BuildContext context, {
    required String label,
    required List<String> selectedIds,
    required List<Doctor> allDoctors,
    required Function(List<String>) onChanged,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        _buildMultiSelect(
          context,
          label: 'Doctors',
          selectedCount: selectedIds.length,
          onTap: () => _showMultiPicker(
            context,
            title: 'Select $label',
            items: allDoctors
                .map((Doctor d) => _PickerItem(id: d.id, name: d.name))
                .toList(),
            initialSelectedIds: selectedIds,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void _showMultiPicker(
    BuildContext context, {
    required String title,
    required List<_PickerItem> items,
    required List<String> initialSelectedIds,
    required Function(List<String>) onChanged,
  }) {
    final selectionNotifier = ValueNotifier<List<String>>(
      List.from(initialSelectedIds),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      onChanged(selectionNotifier.value);
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: Text(
                      'Done',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ValueListenableBuilder<List<String>>(
                  valueListenable: selectionNotifier,
                  builder: (context, selected, _) {
                    return ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, color: AppTheme.borderColor),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final isSelected = selected.contains(item.id);
                        return InkWell(
                          onTap: () {
                            final newList = List<String>.from(
                              selectionNotifier.value,
                            );
                            if (!isSelected) {
                              newList.add(item.id);
                            } else {
                              newList.remove(item.id);
                            }
                            selectionNotifier.value = newList;
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 8,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.primaryLight
                                        : AppTheme.backgroundColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.name[0].toUpperCase(),
                                      style: GoogleFonts.plusJakartaSans(
                                        color: isSelected
                                            ? AppTheme.primaryColor
                                            : AppTheme.textSecondaryColor,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppTheme.primaryColor,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PickerItem {
  final String id;
  final String name;
  _PickerItem({required this.id, required this.name});
}
