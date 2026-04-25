import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/departments/application/department_controller.dart';

class CreateDepartmentPage extends ConsumerWidget {
  const CreateDepartmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = ValueNotifier<String>('');
    final controllerState = ref.watch(departmentControllerProvider);

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
                  Text('Create New Department', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 32),
              
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8.0),
                child: Text(
                  'Department Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textColor),
                ),
              ),
              TextField(
                onChanged: (v) => nameController.value = v,
                decoration: const InputDecoration(hintText: 'e.g. Cardiology, Radiology, etc.'),
              ),
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: controllerState.isLoading
                      ? null
                      : () async {
                          if (nameController.value.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a department name'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }
                          await ref.read(departmentControllerProvider.notifier).createDepartment(
                                name: nameController.value.trim(),
                              );
                          if (context.mounted) {
                            context.pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Department created successfully'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AppTheme.primaryColor,
                              ),
                            );
                          }
                        },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: controllerState.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Create Department', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
