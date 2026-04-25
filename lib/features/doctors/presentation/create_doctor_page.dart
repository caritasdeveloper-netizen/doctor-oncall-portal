import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/departments/application/department_provider.dart';
import 'package:oncall_doctor/features/doctors/application/doctor_provider.dart';

class CreateDoctorPage extends ConsumerWidget {
  const CreateDoctorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We use ValueNotifier for local form state to avoid StatefulWidget
    final employeeIdController = ValueNotifier<String>('');
    final nameController = ValueNotifier<String>('');
    final phoneController = ValueNotifier<String>('');
    final selectedDepts = ValueNotifier<List<String>>([]);

    final departmentsAsync = ref.watch(departmentsProvider);
    final doctorControllerState = ref.watch(doctorControllerProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textColor),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Text('Create New Doctor', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 32),
              _buildFieldHeader('Employee ID'),
              TextField(
                onChanged: (v) => employeeIdController.value = v,
                decoration: const InputDecoration(hintText: 'e.g. DOC-001'),
              ),
              const SizedBox(height: 24),

              _buildFieldHeader('Doctor Name'),
              TextField(
                onChanged: (v) => nameController.value = v,
                decoration: const InputDecoration(hintText: 'e.g. Dr. John Doe'),
              ),
              const SizedBox(height: 24),

              _buildFieldHeader('Phone Number'),
              TextField(
                onChanged: (v) => phoneController.value = v,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: '+1 234 567 890'),
              ),
              const SizedBox(height: 24),

              _buildFieldHeader('Departments'),
              departmentsAsync.when(
                data: (depts) => ValueListenableBuilder(
                  valueListenable: selectedDepts,
                  builder: (context, selected, _) {
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: depts.map((dept) {
                        final isSelected = selected.contains(dept.id);
                        return FilterChip(
                          label: Text(dept.name),
                          selected: isSelected,
                          onSelected: (val) {
                            final newList = List<String>.from(selected);
                            if (val) {
                              newList.add(dept.id);
                            } else {
                              newList.remove(dept.id);
                            }
                            selectedDepts.value = newList;
                          },
                          selectedColor: AppTheme.primaryColor.withOpacity(0.1),
                          checkmarkColor: AppTheme.primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                          side: BorderSide(
                            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, s) => Text('Error: $e'),
              ),
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: doctorControllerState.isLoading
                      ? null
                      : () async {
                          if (employeeIdController.value.isEmpty || nameController.value.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill required fields'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }
                          await ref.read(doctorControllerProvider.notifier).createDoctor(
                                employeeId: employeeIdController.value,
                                name: nameController.value,
                                phoneNumber: phoneController.value,
                                departmentIds: selectedDepts.value,
                              );
                          if (context.mounted) {
                            context.pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Doctor created successfully'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AppTheme.primaryColor,
                              ),
                            );
                          }
                        },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: doctorControllerState.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Create Doctor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textColor),
      ),
    );
  }
}
