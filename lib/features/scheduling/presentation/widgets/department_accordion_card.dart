import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/departments/domain/department.dart';
import 'package:oncall_doctor/features/doctors/domain/doctor.dart';
import 'package:oncall_doctor/features/scheduling/application/scheduling_controller.dart';
import 'package:oncall_doctor/features/scheduling/domain/schedule.dart';
import 'package:oncall_doctor/features/scheduling/presentation/widgets/doctor_chip_selector.dart';

class DepartmentAccordionCard extends ConsumerStatefulWidget {
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
  ConsumerState<DepartmentAccordionCard> createState() => _DepartmentAccordionCardState();
}

class _DepartmentAccordionCardState extends ConsumerState<DepartmentAccordionCard> {
  bool _isExpanded = false;
  int _selectedShiftIndex = 0; // 0 for Day, 1 for Night

  @override
  Widget build(BuildContext context) {
    final bool isDayStaffed = (widget.draft?.dayFirstOnCallDoctorIds.isNotEmpty ?? false) && 
                              (widget.draft?.daySecondOnCallDoctorIds.isNotEmpty ?? false);
    final bool isNightStaffed = (widget.draft?.nightFirstOnCallDoctorIds.isNotEmpty ?? false) && 
                                (widget.draft?.nightSecondOnCallDoctorIds.isNotEmpty ?? false);
    final bool isStaffed = isDayStaffed && isNightStaffed;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isStaffed ? AppTheme.primaryColor.withOpacity(0.3) : Colors.orange.shade300,
          width: 1.5,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (Always visible)
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isStaffed ? AppTheme.primaryLight : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isStaffed ? Icons.check_circle_rounded : Icons.warning_rounded,
                      color: isStaffed ? AppTheme.primaryColor : Colors.orange.shade600,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.department.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isStaffed ? AppTheme.primaryColor.withOpacity(0.1) : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isStaffed ? AppTheme.primaryColor.withOpacity(0.2) : Colors.orange.shade200,
                                ),
                              ),
                              child: Text(
                                isStaffed ? 'Fully Staffed' : 'Staffing Incomplete',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  color: isStaffed ? AppTheme.primaryColor : Colors.orange.shade800,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildSummaryBadges(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      color: AppTheme.textSecondaryColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Expanded Content (Static for performance)
          if (_isExpanded) ...[
            const Divider(height: 1, color: AppTheme.borderColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  children: [
                    _buildShiftTab(0, 'Day Shift', Icons.wb_sunny_rounded),
                    _buildShiftTab(1, 'Night Shift', Icons.nightlight_round),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildAssignmentColumn(
                      context,
                      label: 'Primary On-Call',
                      ids: _selectedShiftIndex == 0 
                          ? (widget.draft?.dayFirstOnCallDoctorIds ?? [])
                          : (widget.draft?.nightFirstOnCallDoctorIds ?? []),
                      onChanged: (ids) => ref.read(schedulingControllerProvider.notifier).updateAssignment(
                        widget.department.id,
                        firstOnCall: ids,
                        isNight: _selectedShiftIndex == 1,
                      ),
                      color: AppTheme.primaryColor,
                      icon: Icons.looks_one_rounded,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildAssignmentColumn(
                      context,
                      label: 'Secondary On-Call',
                      ids: _selectedShiftIndex == 0 
                          ? (widget.draft?.daySecondOnCallDoctorIds ?? [])
                          : (widget.draft?.nightSecondOnCallDoctorIds ?? []),
                      onChanged: (ids) => ref.read(schedulingControllerProvider.notifier).updateAssignment(
                        widget.department.id,
                        secondOnCall: ids,
                        isNight: _selectedShiftIndex == 1,
                      ),
                      color: AppTheme.secondaryColor,
                      icon: Icons.looks_two_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShiftTab(int index, String label, IconData icon) {
    final bool isSelected = _selectedShiftIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedShiftIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBadges() {
    final dayCount = (widget.draft?.dayFirstOnCallDoctorIds.length ?? 0) + (widget.draft?.daySecondOnCallDoctorIds.length ?? 0);
    final nightCount = (widget.draft?.nightFirstOnCallDoctorIds.length ?? 0) + (widget.draft?.nightSecondOnCallDoctorIds.length ?? 0);
    
    return Row(
      children: [
        _buildShiftCountBadge('Day', dayCount, Icons.wb_sunny_rounded, Colors.orange.shade500),
        const SizedBox(width: 8),
        _buildShiftCountBadge('Night', nightCount, Icons.nightlight_round, Colors.indigo.shade400),
      ],
    );
  }

  Widget _buildShiftCountBadge(String label, int count, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 6),
          Text(
            '$label: $count',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: AppTheme.textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentColumn(
    BuildContext context, {
    required String label,
    required List<String> ids,
    required Function(List<String>) onChanged,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC), // Very light slate for contrast against white card
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textColor,
                  fontSize: 15,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              if (ids.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${ids.length} Assigned',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      color: color,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          DoctorChipSelector(
            selectedIds: ids,
            onChanged: onChanged,
            doctorsAsync: widget.doctorsAsync,
            departmentId: widget.department.id,
          ),
        ],
      ),
    );
  }
}
