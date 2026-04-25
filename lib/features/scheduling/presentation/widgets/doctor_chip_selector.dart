import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/doctors/domain/doctor.dart';
import 'package:oncall_doctor/features/scheduling/application/scheduling_ui_providers.dart';

// ── Chip Selector (stateless) ─────────────────────────────────────────────────

class DoctorChipSelector extends StatelessWidget {
  final List<String> selectedIds;
  final Function(List<String>) onChanged;
  final AsyncValue<List<Doctor>> doctorsAsync;
  final String departmentId;

  const DoctorChipSelector({
    super.key,
    required this.selectedIds,
    required this.onChanged,
    required this.doctorsAsync,
    required this.departmentId,
  });

  @override
  Widget build(BuildContext context) {
    return doctorsAsync.when(
      data: (allDoctors) {
        final deptDoctors = allDoctors
            .where((d) => d.departmentIds.contains(departmentId))
            .toList();
        final selectedDoctors =
            allDoctors.where((d) => selectedIds.contains(d.id)).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selected doctor rows
            if (selectedDoctors.isNotEmpty)
              ...selectedDoctors.map(
                (doctor) => _AssignedDoctorRow(
                  doctor: doctor,
                  selectedIds: selectedIds,
                  onChanged: onChanged,
                ),
              ),
            // Assign / Add Another button
            _AssignButton(
              hasAssigned: selectedDoctors.isNotEmpty,
              onTap: () => _showDoctorPicker(context, deptDoctors),
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(minHeight: 2),
      ),
      error: (e, s) =>
          Text('Error: $e', style: const TextStyle(color: Colors.red, fontSize: 10)),
    );
  }

  void _showDoctorPicker(BuildContext context, List<Doctor> availableDoctors) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: _DoctorPickerSheet(
          availableDoctors: availableDoctors,
          initialSelectedIds: selectedIds,
          onSave: onChanged,
        ),
      ),
    );
  }
}

// ── Assigned Doctor Row ───────────────────────────────────────────────────────

class _AssignedDoctorRow extends StatelessWidget {
  final Doctor doctor;
  final List<String> selectedIds;
  final Function(List<String>) onChanged;

  const _AssignedDoctorRow({
    required this.doctor,
    required this.selectedIds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.primaryLight,
            child: Text(
              doctor.name[0].toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textColor,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  doctor.employeeId,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          // Remove button
          InkWell(
            onTap: () {
              final newIds = List<String>.from(selectedIds)..remove(doctor.id);
              onChanged(newIds);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded, size: 14, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Assign Button ─────────────────────────────────────────────────────────────

class _AssignButton extends StatelessWidget {
  final bool hasAssigned;
  final VoidCallback onTap;
  const _AssignButton({required this.hasAssigned, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: hasAssigned
              ? AppTheme.backgroundColor
              : AppTheme.primaryLight.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasAssigned
                ? AppTheme.borderColor
                : AppTheme.primaryColor.withOpacity(0.4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasAssigned ? Icons.add_rounded : Icons.add_circle_outline_rounded,
              size: 16,
              color: hasAssigned
                  ? AppTheme.textSecondaryColor
                  : AppTheme.primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              hasAssigned ? 'Add Another' : 'Assign Doctor',
              style: GoogleFonts.plusJakartaSans(
                color: hasAssigned
                    ? AppTheme.textSecondaryColor
                    : AppTheme.primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Doctor Picker Bottom Sheet (ConsumerWidget = stateless + Riverpod) ────────

class _DoctorPickerSheet extends ConsumerWidget {
  final List<Doctor> availableDoctors;
  final List<String> initialSelectedIds;
  final Function(List<String>) onSave;

  const _DoctorPickerSheet({
    required this.availableDoctors,
    required this.initialSelectedIds,
    required this.onSave,
  });

  // Unique key based on the hash of initialSelectedIds content
  String get _pickerKey =>
      'picker_${initialSelectedIds.join("_")}_${availableDoctors.map((d) => d.id).join("_")}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = _pickerKey;

    // Lazily initialise selection in the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(doctorPickerSelectionProvider.notifier).reset(key, initialSelectedIds);
      ref.read(doctorPickerSearchProvider.notifier).clear(key);
    });

    final selected = ref.watch(
      doctorPickerSelectionProvider.select((s) => s[key] ?? initialSelectedIds),
    );
    final query = ref.watch(
      doctorPickerSearchProvider.select((s) => s[key] ?? ''),
    );

    final filtered = availableDoctors
        .where(
          (d) =>
              d.name.toLowerCase().contains(query.toLowerCase()) ||
              d.employeeId.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle bar
            const SizedBox(height: 12),
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
            const SizedBox(height: 20),

            // Header row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Select Staff',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                            color: AppTheme.textColor,
                          ),
                        ),
                        Text(
                          '${selected.length} selected',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Confirm button
                  FilledButton(
                    onPressed: () {
                      onSave(selected);
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      minimumSize: Size.zero,
                    ),
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.borderColor),
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
                            .read(doctorPickerSearchProvider.notifier)
                            .setQuery(key, v),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppTheme.textColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search by name or ID…',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (query.isNotEmpty)
                      GestureDetector(
                        onTap: () => ref
                            .read(doctorPickerSearchProvider.notifier)
                            .clear(key),
                        child: const Icon(
                          Icons.clear_rounded,
                          size: 16,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Empty state
            if (filtered.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_search_rounded,
                        size: 48,
                        color: AppTheme.textSecondaryColor.withOpacity(0.3),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No doctors found',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.textSecondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final doctor = filtered[index];
                    final isSelected = selected.contains(doctor.id);

                    return _DoctorPickerTile(
                      doctor: doctor,
                      isSelected: isSelected,
                      onTap: () => ref
                          .read(doctorPickerSelectionProvider.notifier)
                          .toggle(key, doctor.id),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Doctor Picker Tile ────────────────────────────────────────────────────────

class _DoctorPickerTile extends StatelessWidget {
  final Doctor doctor;
  final bool isSelected;
  final VoidCallback onTap;

  const _DoctorPickerTile({
    required this.doctor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryColor.withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: AppTheme.primaryColor.withOpacity(0.2))
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.backgroundColor,
                child: Text(
                  doctor.name[0].toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.textColor,
                      ),
                    ),
                    Text(
                      doctor.employeeId,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // Check indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppTheme.primaryColor
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.borderColor,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
