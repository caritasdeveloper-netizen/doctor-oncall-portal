import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/scheduling/application/scheduling_controller.dart';
import 'package:oncall_doctor/features/scheduling/presentation/widgets/bulk_assignment_view.dart';
import 'package:oncall_doctor/features/scheduling/presentation/widgets/day_by_day_view.dart';

class SchedulingPage extends ConsumerWidget {
  const SchedulingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(schedulingControllerProvider);


    return DefaultTabController(
      length: 2,
      child: PopScope(
        canPop: !state.hasUnsavedChanges,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          final shouldPop = await _showExitConfirmation(context);
          if (shouldPop && context.mounted) {
            context.pop();
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Modern Pill TabBar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppTheme.primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: AppTheme.textSecondaryColor,
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        tabs: const [
                          Tab(text: 'Day-by-Day View'),
                          Tab(text: 'Bulk Assignment'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        DayByDayView(),
                        BulkAssignmentView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // if (state.hasUnsavedChanges)
            //   Positioned(
            //     right: 24,
            //     bottom: 24,
            //     child: FloatingActionButton.extended(
            //       onPressed: () async {
            //         await ref.read(schedulingControllerProvider.notifier).saveChanges();
            //         if (context.mounted) {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             SnackBar(
            //               content: Row(
            //                 children: [
            //                   const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            //                   const SizedBox(width: 12),
            //                   Text(
            //                     'Changes saved successfully',
            //                     style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            //                   ),
            //                 ],
            //               ),
            //               behavior: SnackBarBehavior.floating,
            //               backgroundColor: AppTheme.textColor,
            //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            //               margin: const EdgeInsets.all(24),
            //             ),
            //           );
            //         }
            //       },
            //       backgroundColor: AppTheme.primaryColor,
            //       elevation: 8,
            //       label: Text(
            //         'Save Changes',
            //         style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w700),
            //       ),
            //       icon: state.isSaving
            //           ? const SizedBox(
            //               width: 18,
            //               height: 18,
            //               child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            //             )
            //           : const Icon(Icons.save_rounded, color: Colors.white),
            //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              'Unsaved Changes',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
            ),
            content: Text(
              'You have unsaved changes in the schedule. Are you sure you want to discard them?',
              style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondaryColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Continue Editing',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Discard Changes',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                ),
              ),
            ],
            actionsPadding: const EdgeInsets.all(24),
          ),
        ) ??
        false;
  }
}

