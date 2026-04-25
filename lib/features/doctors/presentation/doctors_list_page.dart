import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/doctors/application/doctor_provider.dart';

class DoctorsListPage extends ConsumerWidget {
  const DoctorsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorsAsync = ref.watch(doctorsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Doctor Management',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
              ),
              FilledButton.icon(
                onPressed: () => context.pushNamed('create-doctor'),
                icon: const Icon(Icons.person_add_rounded, size: 18),
                label: const Text('Add New Doctor'),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: doctorsAsync.when(
              data: (doctors) {
                if (doctors.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline_rounded, size: 64, color: AppTheme.textSecondaryColor.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        const Text('No doctors found. Add your first doctor!'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          child: Text(
                            doctor.name[0].toUpperCase(),
                            style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          doctor.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                        ),
                        subtitle: Text('${doctor.employeeId} • ${doctor.phoneNumber}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              onPressed: () {
                                // TODO: Implement edit
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent),
                              onPressed: () {
                                // TODO: Implement delete
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
