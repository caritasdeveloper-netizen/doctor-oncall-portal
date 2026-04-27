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
              child: Row(
                children: [
                  // Left side: New Heading
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
                        ),
                      ),
                      Text(
                        viewIndex == 0 ? 'Daily Roster' : 'Bulk Configuration',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Right side: View Toggle Button
                  _ViewToggleButton(
                    index: viewIndex,
                    onTap: () {
                      ref.read(schedulingViewIndexProvider.notifier).setIndex(
                          viewIndex == 0 ? 1 : 0);
                    },
                  ),
                ],
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
            Icon(
              isBulk ? Icons.calendar_today_rounded : Icons.auto_awesome_rounded,
              size: 18,
              color: isBulk ? Colors.white : AppTheme.primaryColor,
            ),
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
