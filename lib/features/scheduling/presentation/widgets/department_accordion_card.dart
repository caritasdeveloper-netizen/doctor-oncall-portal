import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/departments/domain/department.dart';
import 'package:oncall_doctor/features/doctors/domain/doctor.dart';
import 'package:oncall_doctor/features/scheduling/application/scheduling_controller.dart';
import 'package:oncall_doctor/features/scheduling/application/scheduling_ui_providers.dart';
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
    final isExpanded = ref.watch(
      accordionExpandedStateProvider.select((s) => s[department.id] ?? false),
    );

    final bool isDayStaffed =
        (draft?.dayFirstOnCallDoctorIds.isNotEmpty ?? false) &&
        (draft?.daySecondOnCallDoctorIds.isNotEmpty ?? false);
    final bool isNightStaffed =
        (draft?.nightFirstOnCallDoctorIds.isNotEmpty ?? false) &&
        (draft?.nightSecondOnCallDoctorIds.isNotEmpty ?? false);
    final bool isStaffed = isDayStaffed && isNightStaffed;

    final original = ref.watch(
      schedulingControllerProvider
          .select((s) => s.originalSchedules[department.id]),
    );
    final bool hasChanges = draft != original;
    final isSaving = ref.watch(
      schedulingControllerProvider.select((s) => s.isSaving),
    );

    // Status color semantics
    final Color statusColor = isStaffed
        ? const Color(0xFF16A34A) // green-600
        : isDayStaffed || isNightStaffed
        ? Colors.orange.shade600
        : Colors.red.shade500;
    final Color statusBg = isStaffed
        ? const Color(0xFFDCFCE7)
        : isDayStaffed || isNightStaffed
        ? Colors.orange.shade50
        : Colors.red.shade50;
    final String statusLabel = isStaffed
        ? 'Fully Staffed'
        : isDayStaffed || isNightStaffed
        ? 'Partially Staffed'
        : 'Not Staffed';
    final IconData statusIcon = isStaffed
        ? Icons.check_circle_rounded
        : isDayStaffed || isNightStaffed
        ? Icons.warning_amber_rounded
        : Icons.radio_button_unchecked_rounded;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded
              ? AppTheme.primaryColor.withOpacity(0.4)
              : isStaffed
              ? AppTheme.borderColor
              : Colors.orange.withOpacity(0.4),
          width: isExpanded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded
                ? AppTheme.primaryColor.withOpacity(0.06)
                : Colors.black.withOpacity(0.03),
            blurRadius: isExpanded ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──────────────────────────────────────────────────
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => ref
                  .read(accordionExpandedStateProvider.notifier)
                  .toggle(department.id),
              borderRadius: isExpanded
                  ? const BorderRadius.vertical(top: Radius.circular(15))
                  : BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    // Status icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(statusIcon, color: statusColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    // Dept name + badges
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
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              _StatusBadge(
                                label: statusLabel,
                                color: statusColor,
                                bg: statusBg,
                              ),
                              const SizedBox(width: 8),
                              _ShiftCountBadge(
                                label: 'Day',
                                count:
                                    (draft?.dayFirstOnCallDoctorIds.length ??
                                        0) +
                                    (draft?.daySecondOnCallDoctorIds.length ??
                                        0),
                                icon: Icons.wb_sunny_rounded,
                                color: Colors.orange.shade600,
                              ),
                              const SizedBox(width: 6),
                              _ShiftCountBadge(
                                label: 'Night',
                                count:
                                    (draft?.nightFirstOnCallDoctorIds.length ??
                                        0) +
                                    (draft?.nightSecondOnCallDoctorIds.length ??
                                        0),
                                icon: Icons.nightlight_round,
                                color: Colors.indigo.shade400,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Unsaved dot indicator
                    if (hasChanges)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                      ),
                    // Chevron
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isExpanded
                              ? AppTheme.primaryColor.withOpacity(0.08)
                              : AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: isExpanded
                              ? AppTheme.primaryColor
                              : AppTheme.textSecondaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Expanded Content ─────────────────────────────────────────
          if (isExpanded) ...[
            const Divider(height: 1, thickness: 1, color: AppTheme.borderColor),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day Shift
                  Expanded(
                    child: _ShiftPanel(
                      label: 'Day Shift',
                      icon: Icons.wb_sunny_rounded,
                      shiftColor: Colors.orange.shade600,
                      department: department,
                      draft: draft,
                      doctorsAsync: doctorsAsync,
                      isNight: false,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Night Shift
                  Expanded(
                    child: _ShiftPanel(
                      label: 'Night Shift',
                      icon: Icons.nightlight_round,
                      shiftColor: Colors.indigo.shade500,
                      department: department,
                      draft: draft,
                      doctorsAsync: doctorsAsync,
                      isNight: true,
                    ),
                  ),
                ],
              ),
            ),

            // Unsaved changes footer
            if (hasChanges)
              _UnsavedChangesBar(isSaving: isSaving)
            else
              const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}

// ── Shift Panel ────────────────────────────────────────────────────────────────

class _ShiftPanel extends ConsumerWidget {
  final String label;
  final IconData icon;
  final Color shiftColor;
  final Department department;
  final DailySchedule? draft;
  final AsyncValue<List<Doctor>> doctorsAsync;
  final bool isNight;

  const _ShiftPanel({
    required this.label,
    required this.icon,
    required this.shiftColor,
    required this.department,
    required this.draft,
    required this.doctorsAsync,
    required this.isNight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryIds = isNight
        ? (draft?.nightFirstOnCallDoctorIds ?? [])
        : (draft?.dayFirstOnCallDoctorIds ?? []);
    final secondaryIds = isNight
        ? (draft?.nightSecondOnCallDoctorIds ?? [])
        : (draft?.daySecondOnCallDoctorIds ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shift header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: shiftColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14, color: shiftColor),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: AppTheme.textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Primary on-call
        _AssignmentSlot(
          slotLabel: 'Primary On-Call',
          slotSubtitle: 'Main emergency contact',
          icon: Icons.looks_one_rounded,
          color: AppTheme.primaryColor,
          ids: primaryIds,
          doctorsAsync: doctorsAsync,
          departmentId: department.id,
          onChanged: (ids) => ref
              .read(schedulingControllerProvider.notifier)
              .updateAssignment(
                department.id,
                firstOnCall: ids,
                isNight: isNight,
              ),
        ),
        const SizedBox(height: 12),

        // Secondary on-call
        _AssignmentSlot(
          slotLabel: 'Secondary On-Call',
          slotSubtitle: 'Backup contact',
          icon: Icons.looks_two_rounded,
          color: AppTheme.secondaryColor,
          ids: secondaryIds,
          doctorsAsync: doctorsAsync,
          departmentId: department.id,
          onChanged: (ids) => ref
              .read(schedulingControllerProvider.notifier)
              .updateAssignment(
                department.id,
                secondOnCall: ids,
                isNight: isNight,
              ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

// ── Assignment Slot ────────────────────────────────────────────────────────────

class _AssignmentSlot extends StatelessWidget {
  final String slotLabel;
  final String slotSubtitle;
  final IconData icon;
  final Color color;
  final List<String> ids;
  final AsyncValue<List<Doctor>> doctorsAsync;
  final String departmentId;
  final ValueChanged<List<String>> onChanged;

  const _AssignmentSlot({
    required this.slotLabel,
    required this.slotSubtitle,
    required this.icon,
    required this.color,
    required this.ids,
    required this.doctorsAsync,
    required this.departmentId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasAssignment = ids.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: hasAssignment
            ? color.withOpacity(0.04)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasAssignment
              ? color.withOpacity(0.25)
              : AppTheme.borderColor.withOpacity(0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slotLabel,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: AppTheme.textColor,
                      ),
                    ),
                    Text(
                      slotSubtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasAssignment)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${ids.length}',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      color: color,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          DoctorChipSelector(
            selectedIds: ids,
            onChanged: onChanged,
            doctorsAsync: doctorsAsync,
            departmentId: departmentId,
          ),
        ],
      ),
    );
  }
}

// ── Unsaved Changes Bar ────────────────────────────────────────────────────────

class _UnsavedChangesBar extends ConsumerWidget {
  final bool isSaving;
  const _UnsavedChangesBar({required this.isSaving});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFBEB),
        border: Border(top: BorderSide(color: Color(0xFFFEF08A))),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.edit_note_rounded, size: 24, color: Colors.amber),
          const SizedBox(width: 12),
          Text(
            'Unsaved changes',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              color: const Color(0xFF92400E),
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: isSaving
                ? null
                : () =>
                      ref
                          .read(schedulingControllerProvider.notifier)
                          .resetChanges(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            child: Text(
              'Discard',
              style: GoogleFonts.plusJakartaSans(
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 14),
          FilledButton.icon(
            onPressed: isSaving
                ? null
                : () => ref
                      .read(schedulingControllerProvider.notifier)
                      .saveChanges(),
            icon: isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Icon(Icons.save_rounded, size: 18),
            label: Text(
              'Save Changes',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Small reusable badge widgets ───────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  const _StatusBadge({
    required this.label,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          color: color,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _ShiftCountBadge extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;
  const _ShiftCountBadge({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            '$label $count',
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
}
