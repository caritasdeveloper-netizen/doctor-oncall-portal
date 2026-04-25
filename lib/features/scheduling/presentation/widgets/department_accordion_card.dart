import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/departments/domain/department.dart';
import 'package:oncall_doctor/features/doctors/domain/doctor.dart';
import 'package:oncall_doctor/features/scheduling/application/scheduling_controller.dart';
import 'package:oncall_doctor/features/scheduling/domain/schedule.dart';
import 'package:oncall_doctor/features/scheduling/presentation/widgets/doctor_chip_selector.dart';

class DepartmentAccordionCard extends ConsumerWidget {
  final Department department;
  final DailySchedule? draft;
  final AsyncValue<List<Doctor>> doctorsAsync;

  const DepartmentAccordionCard({
    super.key,
    required this.department,
    required this.draft,
    required this.doctorsAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isStaffed = (draft?.firstOnCallDoctorIds.isNotEmpty ?? false) && 
                           (draft?.secondOnCallDoctorIds.isNotEmpty ?? false);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isStaffed ? AppTheme.primaryColor.withOpacity(0.1) : AppTheme.borderColor,
          width: isStaffed ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Status Indicator
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isStaffed ? AppTheme.primaryColor : Colors.orange.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        department.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textColor,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        isStaffed ? 'Fully Staffed' : 'Staffing Incomplete',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                          color: isStaffed ? AppTheme.primaryColor : Colors.orange.shade700,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildActionIcon(),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderColor),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    _buildAssignmentRow(
                      context,
                      ref,
                      label: 'Primary',
                      ids: draft?.firstOnCallDoctorIds ?? [],
                      onChanged: (ids) => ref.read(schedulingControllerProvider.notifier).updateAssignment(
                        department.id,
                        firstOnCall: ids,
                      ),
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 24),
                    _buildAssignmentRow(
                      context,
                      ref,
                      label: 'Secondary',
                      ids: draft?.secondOnCallDoctorIds ?? [],
                      onChanged: (ids) => ref.read(schedulingControllerProvider.notifier).updateAssignment(
                        department.id,
                        secondOnCall: ids,
                      ),
                      color: AppTheme.secondaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentRow(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required List<String> ids,
    required Function(List<String>) onChanged,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: AppTheme.textSecondaryColor,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
            if (ids.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${ids.length} DR',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    color: color,
                    fontSize: 9,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        DoctorChipSelector(
          selectedIds: ids,
          onChanged: onChanged,
          doctorsAsync: doctorsAsync,
          departmentId: department.id,
        ),
      ],
    );
  }

  Widget _buildActionIcon() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.more_vert_rounded, size: 16, color: AppTheme.textSecondaryColor),
    );
  }
}
