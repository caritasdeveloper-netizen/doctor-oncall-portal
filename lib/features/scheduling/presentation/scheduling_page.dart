import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/scheduling/application/scheduling_controller.dart';
import 'package:oncall_doctor/features/scheduling/presentation/widgets/bulk_assignment_view.dart';
import 'package:oncall_doctor/features/scheduling/presentation/widgets/day_by_day_view.dart';
import 'package:oncall_doctor/features/scheduling/application/scheduling_ui_providers.dart';

class SchedulingPage extends ConsumerWidget {
  const SchedulingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(schedulingControllerProvider);
    final viewIndex = ref.watch(schedulingViewIndexProvider);

    return PopScope(
      canPop: !state.hasUnsavedChanges,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmation(context);
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFDFF),
        body: Column(
          children: [
            // ── Custom Header ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isSmall = constraints.maxWidth < 600;
                  return isSmall
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Schedule Management',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textColor,
                                letterSpacing: -0.5,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  viewIndex == 0 ? 'Daily Roster' : 'Bulk Configuration',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryColor,
                                    letterSpacing: 0.5,
                                    height: 1.0,
                                  ),
                                ),
                                const Spacer(),
                                _ViewToggleButton(
                                  index: viewIndex,
                                  onTap: () {
                                    ref.read(schedulingViewIndexProvider.notifier).setIndex(viewIndex == 0 ? 1 : 0);
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Schedule Management',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textColor,
                                    letterSpacing: -0.5,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  viewIndex == 0 ? 'Daily Roster' : 'Bulk Configuration',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryColor,
                                    letterSpacing: 0.5,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            _ViewToggleButton(
                              index: viewIndex,
                              onTap: () {
                                ref.read(schedulingViewIndexProvider.notifier).setIndex(viewIndex == 0 ? 1 : 0);
                              },
                            ),
                          ],
                        );
                },
              ),
            ),
            const SizedBox(height: 24),

            // ── Main Content ───────────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: viewIndex == 0 
                    ? const DayByDayView() 
                    : const BulkAssignmentView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 0,
            child: Container(
              width: 450,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.warning_amber_rounded, color: Colors.amber.shade700, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Unsaved Changes',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          color: AppTheme.textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'You have unsaved changes in the schedule. Are you sure you want to discard them and exit?',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppTheme.textColor,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Any progress made on the current schedule will be lost. This action cannot be undone.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Continue Editing',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppTheme.textSecondaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Colors.red.shade600,
                          elevation: 0,
                        ),
                        child: Text(
                          'Discard Changes',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;
  }
}

class _ViewToggleButton extends StatelessWidget {
  final int index;
  final VoidCallback onTap;

  const _ViewToggleButton({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isBulk = index == 1;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isBulk ? AppTheme.textColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isBulk ? AppTheme.textColor : AppTheme.borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
           
            const SizedBox(width: 10),
            Text(
              isBulk ? 'Back to Daily View' : 'Bulk Assignment',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: isBulk ? Colors.white : AppTheme.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
