import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/departments/application/department_provider.dart';
import 'package:oncall_doctor/features/doctors/application/doctor_provider.dart';
import 'package:oncall_doctor/features/doctors/domain/doctor.dart';

class CreateDoctorPage extends ConsumerWidget {
  final Doctor? doctor;
  const CreateDoctorPage({super.key, this.doctor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We use ValueNotifier for local form state to avoid StatefulWidget
    final employeeIdController = ValueNotifier<String>(doctor?.employeeId ?? '');
    final nameController = ValueNotifier<String>(doctor?.name ?? '');
    final phoneController = ValueNotifier<String>(doctor?.phoneNumber ?? '');
    final selectedDepts = ValueNotifier<List<String>>(doctor?.departmentIds ?? []);

    final departmentsAsync = ref.watch(departmentsProvider);
    final doctorControllerState = ref.watch(doctorControllerProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back_rounded, color: AppTheme.textColor, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Back to Doctors',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Main Form Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.person_add_rounded, color: AppTheme.primaryColor, size: 22),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            doctor != null ? 'Edit Professional' : 'Professional Details',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppTheme.borderColor),

                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  label: 'Employee ID',
                                  hint: 'e.g. DOC-001',
                                  icon: Icons.badge_outlined,
                                  initialValue: employeeIdController.value,
                                  onChanged: (v) => employeeIdController.value = v,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: _buildInputField(
                                  label: 'Doctor Name',
                                  hint: 'e.g. Dr. John Doe',
                                  icon: Icons.person_outline_rounded,
                                  initialValue: nameController.value,
                                  onChanged: (v) => nameController.value = v,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildInputField(
                            label: 'Phone Number',
                            hint: '+1 234 567 890',
                            icon: Icons.phone_android_rounded,
                            keyboardType: TextInputType.phone,
                            initialValue: phoneController.value,
                            onChanged: (v) => phoneController.value = v,
                          ),
                          const SizedBox(height: 32),

                          departmentsAsync.when(
                            data: (depts) => ValueListenableBuilder(
                              valueListenable: selectedDepts,
                              builder: (context, selected, _) {
                                return _buildDepartmentSearchableDropdown(
                                  context: context,
                                  departments: depts,
                                  selectedDepts: selectedDepts,
                                );
                              },
                            ),
                            loading: () => const LinearProgressIndicator(),
                            error: (e, s) => Text('Error: $e'),
                          ),

                          const SizedBox(height: 48),

                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: FilledButton(
                              onPressed: doctorControllerState.isLoading
                                  ? null
                                  : () async {
                                      if (employeeIdController.value.isEmpty || nameController.value.isEmpty) {
                                        _showSnackBar(context, 'Please fill required fields', isError: true);
                                        return;
                                      }
                                      if (doctor != null) {
                                        await ref.read(doctorControllerProvider.notifier).updateDoctor(
                                              id: doctor!.id,
                                              employeeId: employeeIdController.value,
                                              name: nameController.value,
                                              phoneNumber: phoneController.value,
                                              departmentIds: selectedDepts.value,
                                            );
                                      } else {
                                        await ref.read(doctorControllerProvider.notifier).createDoctor(
                                              employeeId: employeeIdController.value,
                                              name: nameController.value,
                                              phoneNumber: phoneController.value,
                                              departmentIds: selectedDepts.value,
                                            );
                                      }
                                      if (context.mounted) {
                                        context.pop();
                                        _showSnackBar(
                                          context,
                                          doctor != null ? 'Doctor updated successfully' : 'Doctor registered successfully',
                                        );
                                      }
                                    },
                              style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              child: doctorControllerState.isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.check_circle_outline_rounded, size: 20),
                                        const SizedBox(width: 12),
                                        Text(
                                          doctor != null ? 'Update Doctor' : 'Register Doctor',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Information Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.info_outline_rounded, color: AppTheme.primaryColor, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Administrative Note',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Once registered, the doctor will be available for on-call assignments in their respective departments.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppTheme.textSecondaryColor,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    String? initialValue,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppTheme.textColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppTheme.textSecondaryColor, size: 20),
            filled: true,
            fillColor: AppTheme.backgroundColor.withOpacity(0.5),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentSearchableDropdown({
    required BuildContext context,
    required List<dynamic> departments,
    required ValueNotifier<List<String>> selectedDepts,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assigned Departments',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppTheme.textColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 10),
        SearchAnchor(
          builder: (context, controller) {
            return TextField(
              controller: controller,
              readOnly: true,
              onTap: () => controller.openView(),
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: 'Search and select departments...',
                prefixIcon: const Icon(Icons.business_rounded, color: AppTheme.textSecondaryColor, size: 20),
                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.textSecondaryColor),
                filled: true,
                fillColor: AppTheme.backgroundColor.withOpacity(0.5),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppTheme.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                ),
              ),
            );
          },
          suggestionsBuilder: (context, controller) {
            final query = controller.text.toLowerCase();
            final filtered = departments.where((d) => d.name.toLowerCase().contains(query)).toList();

            if (filtered.isEmpty) {
              return [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'No departments found matching "$query"',
                      style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondaryColor),
                    ),
                  ),
                )
              ];
            }

            return [
              ListenableBuilder(
                listenable: selectedDepts,
                builder: (context, _) {
                  final selectedIds = selectedDepts.value;
                  return Column(
                    children: filtered.map((dept) {
                      final isSelected = selectedIds.contains(dept.id);
                      return ListTile(
                        title: Text(
                          dept.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
                          ),
                        ),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isSelected ? Icons.check_circle_rounded : Icons.business_rounded,
                            color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                            size: 20,
                          ),
                        ),
                        trailing: Checkbox(
                          value: isSelected,
                          activeColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (val) {
                            final newList = List<String>.from(selectedIds);
                            if (val == true) {
                              newList.add(dept.id);
                            } else {
                              newList.remove(dept.id);
                            }
                            selectedDepts.value = newList;
                          },
                        ),
                        onTap: () {
                          final newList = List<String>.from(selectedIds);
                          if (isSelected) {
                            newList.remove(dept.id);
                          } else {
                            newList.add(dept.id);
                          }
                          selectedDepts.value = newList;
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => controller.closeView(null),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Done Selecting'),
                  ),
                ),
              ),
            ];
          },
        ),
        ListenableBuilder(
          listenable: selectedDepts,
          builder: (context, _) {
            final selectedIds = selectedDepts.value;
            if (selectedIds.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedIds.map((id) {
                    final dept = departments.firstWhere((d) => d.id == id);
                    return Chip(
                      label: Text(dept.name),
                      onDeleted: () {
                        final newList = List<String>.from(selectedIds)..remove(id);
                        selectedDepts.value = newList;
                      },
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.05),
                      labelStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                      deleteIconColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.2)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              message,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red.shade600 : AppTheme.textColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(24),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

