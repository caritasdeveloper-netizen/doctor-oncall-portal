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
  final String departmentName;
  final bool requireConfirmation;

  const DoctorChipSelector({
    super.key,
    required this.selectedIds,
    required this.onChanged,
    required this.doctorsAsync,
    required this.departmentId,
    this.departmentName = '',
    this.requireConfirmation = true,
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
                  departmentName: departmentName,
                  requireConfirmation: requireConfirmation,
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
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: _DoctorPickerDialog(
          availableDoctors: availableDoctors,
          initialSelectedIds: selectedIds,
          onSave: (newIds) async {
            if (!requireConfirmation) {
              onChanged(newIds);
              return;
            }

            final addedIds = newIds.where((id) => !selectedIds.contains(id)).toList();
            final removedIds = selectedIds.where((id) => !newIds.contains(id)).toList();

            if (addedIds.isEmpty && removedIds.isEmpty) return;

            final addedDocs = availableDoctors.where((d) => addedIds.contains(d.id)).map((d) => d.name).toList();
            final removedDocs = availableDoctors.where((d) => removedIds.contains(d.id)).map((d) => d.name).toList();

            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Text(
                  'Confirm Schedule Update',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: AppTheme.textColor),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Are you sure you want to update the schedule for $departmentName?',
                      style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondaryColor, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    if (addedDocs.isNotEmpty) ...[
                      Text(
                        'Adding Doctors:',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.green.shade700),
                      ),
                      const SizedBox(height: 4),
                      ...addedDocs.map((name) => Text('• $name', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600))),
                    ],
                    if (addedDocs.isNotEmpty && removedDocs.isNotEmpty) const SizedBox(height: 12),
                    if (removedDocs.isNotEmpty) ...[
                      Text(
                        'Removing Doctors:',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.red.shade700),
                      ),
                      const SizedBox(height: 4),
                      ...removedDocs.map((name) => Text('• $name', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600))),
                    ],
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondaryColor, fontWeight: FontWeight.w700)),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Confirm & Save', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              onChanged(newIds);
            }
          },
        ),
      ),
    );
  }
}

// ── Assigned Doctor Row ───────────────────────────────────────────────────────

class _AssignedDoctorRow extends StatelessWidget {
  final Doctor doctor;
  final List<String> selectedIds;
  final String departmentName;
  final bool requireConfirmation;
  final Function(List<String>) onChanged;

  const _AssignedDoctorRow({
    required this.doctor,
    required this.selectedIds,
    required this.departmentName,
    this.requireConfirmation = true,
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
            onTap: () async {
              if (!requireConfirmation) {
                final newIds = List<String>.from(selectedIds)..remove(doctor.id);
                onChanged(newIds);
                return;
              }

              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: Text(
                    'Remove Doctor',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: AppTheme.textColor),
                  ),
                  content: Text(
                    'Remove ${doctor.name} from $departmentName schedule?',
                    style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondaryColor, fontSize: 14),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondaryColor, fontWeight: FontWeight.w700)),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Remove & Save', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                final newIds = List<String>.from(selectedIds)..remove(doctor.id);
                onChanged(newIds);
              }
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
        padding: const EdgeInsets.symmetric(vertical: 14),
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

// ── Doctor Picker Dialog (ConsumerWidget = stateless + Riverpod) ──────────────

class _DoctorPickerDialog extends ConsumerStatefulWidget {
  final List<Doctor> availableDoctors;
  final List<String> initialSelectedIds;
  final Function(List<String>) onSave;

  const _DoctorPickerDialog({
    required this.availableDoctors,
    required this.initialSelectedIds,
    required this.onSave,
  });

  @override
  ConsumerState<_DoctorPickerDialog> createState() => _DoctorPickerDialogState();
}

class _DoctorPickerDialogState extends ConsumerState<_DoctorPickerDialog> {
  String get _pickerKey =>
      'picker_${widget.initialSelectedIds.join("_")}_${widget.availableDoctors.map((d) => d.id).join("_")}';

  @override
  void initState() {
    super.initState();
    // Initialise state only once when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final key = _pickerKey;
        ref.read(doctorPickerSelectionProvider.notifier).reset(key, widget.initialSelectedIds);
        ref.read(doctorPickerSearchProvider.notifier).clear(key);
      }
    });
  }

  @override
  void dispose() {
    final key = _pickerKey;
    // Clean up state synchronously to avoid accessing 'ref' after unmounting
    ref.read(doctorPickerSelectionProvider.notifier).remove(key);
    ref.read(doctorPickerSearchProvider.notifier).remove(key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final key = _pickerKey;

    final selected = ref.watch(
      doctorPickerSelectionProvider.select((s) => s[key] ?? widget.initialSelectedIds),
    );
    final query = ref.watch(
      doctorPickerSearchProvider.select((s) => s[key] ?? ''),
    );

    final filtered = widget.availableDoctors
        .where(
          (d) =>
              d.name.toLowerCase().contains(query.toLowerCase()) ||
              d.employeeId.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480, maxHeight: 560),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.white,
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(20, 18, 12, 14),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppTheme.borderColor),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Assign Doctor',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: AppTheme.textColor,
                            ),
                          ),
                          if (selected.isNotEmpty)
                            Text(
                              '${selected.length} selected',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Close button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      color: AppTheme.textSecondaryColor,
                      iconSize: 20,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // ── Search bar ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: AppTheme.textSecondaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          autofocus: true,
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
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
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

              // ── Doctor list ──────────────────────────────────────────
              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_search_rounded,
                        size: 40,
                        color: AppTheme.textSecondaryColor.withOpacity(0.3),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No doctors found',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.textSecondaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
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

              // ── Footer action bar ────────────────────────────────────
              LayoutBuilder(
                builder: (context, constraints) {
                  final isSmall = constraints.maxWidth < 320;
                  
                  final selectedChip = selected.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${selected.length} selected',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : const SizedBox.shrink();

                  final cancelButton = TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.textSecondaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  );

                  final confirmButton = FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onSave(selected);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      elevation: 0,
                    ),
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  );

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: AppTheme.borderColor)),
                    ),
                    child: isSmall
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (selected.isNotEmpty) ...[
                                Center(child: selectedChip),
                                const SizedBox(height: 12),
                              ],
                              Row(
                                children: [
                                  Expanded(child: cancelButton),
                                  const SizedBox(width: 8),
                                  Expanded(child: confirmButton),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              if (selected.isNotEmpty) selectedChip,
                              const Spacer(),
                              cancelButton,
                              const SizedBox(width: 8),
                              confirmButton,
                            ],
                          ),
                  );
                },
              ),
            ],
          ),
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
