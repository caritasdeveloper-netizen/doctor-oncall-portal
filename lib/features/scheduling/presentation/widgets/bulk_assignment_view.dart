import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/departments/application/department_provider.dart';
import 'package:oncall_doctor/features/departments/domain/department.dart';
import 'package:oncall_doctor/features/doctors/domain/doctor.dart';
import 'package:oncall_doctor/features/doctors/application/doctor_provider.dart';
import 'package:oncall_doctor/features/scheduling/application/bulk_assignment_controller.dart';
import 'package:oncall_doctor/features/scheduling/presentation/widgets/doctor_chip_selector.dart';

class BulkAssignmentView extends ConsumerWidget {
  const BulkAssignmentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bulkAssignmentControllerProvider);
    final deptsAsync = ref.watch(departmentsProvider);
    final doctorsAsync = ref.watch(doctorsProvider);

    return Container(
      color: const Color(0xFFFBFDFF),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildSectionHeader(
              'Bulk Assignment',
              'Configure and apply schedules across multiple dates for a single department.',
              Icons.auto_awesome_rounded,
            ),
            const SizedBox(height: 32),

            // Step 1: Department Selection
            _buildStepIndicator('01', 'Target Department'),
            const SizedBox(height: 16),
            deptsAsync.when(
              data: (depts) => _DepartmentSelector(
                departments: depts,
                selectedId: state.selectedDepartmentId,
                onSelected: (id) => ref
                    .read(bulkAssignmentControllerProvider.notifier)
                    .updateDepartment(id),
              ),
              loading: () => _buildLoadingPlaceholder(),
              error: (e, s) => _buildErrorState(e.toString()),
            ),
            const SizedBox(height: 40),

            // Step 2: Date Selection
            _buildStepIndicator('02', 'Select Timeframe'),
            const SizedBox(height: 16),
            _DateConfigCard(state: state, ref: ref),
            const SizedBox(height: 40),

            // Step 3: Staff Assignment
            _buildStepIndicator('03', 'Staffing Configuration'),
            const SizedBox(height: 16),
            doctorsAsync.when(
              data: (docs) => _StaffAssignmentSection(
                state: state,
                doctors: docs,
                ref: ref,
              ),
              loading: () => _buildLoadingPlaceholder(),
              error: (e, s) => _buildErrorState(e.toString()),
            ),
            const SizedBox(height: 48),

            // Action Button
            _ApplyButton(state: state, ref: ref),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.textColor,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 52),
          child: Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator(String step, String title) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppTheme.textColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              step,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppTheme.textColor,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 1,
            color: AppTheme.borderColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Text('Error: $error', style: TextStyle(color: Colors.red.shade700)),
    );
  }
}

// ── Department Selector (Searchable Dropdown) ─────────────────────────────────

class _DepartmentSelector extends StatefulWidget {
  final List<Department> departments;
  final String? selectedId;
  final Function(String) onSelected;

  const _DepartmentSelector({
    required this.departments,
    this.selectedId,
    required this.onSelected,
  });

  @override
  State<_DepartmentSelector> createState() => _DepartmentSelectorState();
}

class _DepartmentSelectorState extends State<_DepartmentSelector> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  bool _isOpen = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Department? get _selected =>
      widget.departments.where((d) => d.id == widget.selectedId).firstOrNull;

  List<Department> get _filtered => widget.departments
      .where((d) => d.name.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isOpen ? AppTheme.primaryColor : AppTheme.borderColor,
          width: _isOpen ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Trigger field
          InkWell(
            onTap: () => setState(() => _isOpen = !_isOpen),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.business_rounded, size: 16, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _selected != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Selected Department',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondaryColor, fontWeight: FontWeight.w600)),
                              Text(_selected!.name,
                                  style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textColor)),
                            ],
                          )
                        : Text('Choose a department…',
                            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppTheme.textSecondaryColor, fontWeight: FontWeight.w500)),
                  ),
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.textSecondaryColor),
                  ),
                ],
              ),
            ),
          ),

          // Dropdown panel
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: _isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                const Divider(height: 1, color: AppTheme.borderColor),
                // Search field
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _query = v),
                    style: GoogleFonts.plusJakartaSans(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search departments…',
                      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppTheme.textSecondaryColor),
                      prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppTheme.textSecondaryColor),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 16),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _query = '');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      filled: true,
                      fillColor: AppTheme.backgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppTheme.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppTheme.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
                      ),
                    ),
                    autofocus: true,
                  ),
                ),
                // Results list
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 260),
                  child: _filtered.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Icon(Icons.search_off_rounded, size: 36, color: AppTheme.textSecondaryColor.withOpacity(0.4)),
                              const SizedBox(height: 8),
                              Text('No departments found',
                                  style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondaryColor, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: _filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, color: AppTheme.borderColor),
                          itemBuilder: (context, index) {
                            final dept = _filtered[index];
                            final isSelected = dept.id == widget.selectedId;
                            return InkWell(
                              onTap: () {
                                widget.onSelected(dept.id);
                                setState(() {
                                  _isOpen = false;
                                  _query = '';
                                  _searchCtrl.clear();
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 180),
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
                                          width: isSelected ? 5 : 2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(dept.name,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                            fontSize: 14,
                                            color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
                                          )),
                                    ),
                                    if (isSelected)
                                      const Icon(Icons.check_rounded, size: 16, color: AppTheme.primaryColor),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Date Config Card ─────────────────────────────────────────────────────────

class _DateConfigCard extends ConsumerStatefulWidget {
  final BulkAssignmentState state;
  final WidgetRef ref;

  const _DateConfigCard({required this.state, required this.ref});

  @override
  ConsumerState<_DateConfigCard> createState() => _DateConfigCardState();
}

class _DateConfigCardState extends ConsumerState<_DateConfigCard> {
  final Set<int> _selectedWeekdays = {};
  DateTime? _fromDate;
  DateTime? _toDate;
  final Set<DateTime> _explicitlyIncluded = {};
  final Set<DateTime> _explicitlyExcluded = {};

  late DateTime _calendarMonth;

  @override
  void initState() {
    super.initState();
    _calendarMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  void _updateDates() {
    List<DateTime> dates = [];
    if (_fromDate != null && _toDate != null) {
      DateTime current = _fromDate!;
      while (!current.isAfter(_toDate!)) {
        if (_selectedWeekdays.contains(current.weekday)) {
          dates.add(current);
        }
        current = current.add(const Duration(days: 1));
      }
    }

    Set<DateTime> finalSet = dates.toSet();
    finalSet.addAll(_explicitlyIncluded);
    finalSet.removeAll(_explicitlyExcluded);

    final sortedList = finalSet.toList()..sort();
    widget.ref.read(bulkAssignmentControllerProvider.notifier).updateDates(sortedList);
  }

  void _onWeekdayToggled(int weekday, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedWeekdays.add(weekday);
      } else {
        _selectedWeekdays.remove(weekday);
      }
      _ensureDateRangeSet();
      _updateDates();
    });
  }
  
  void _toggleEveryday(bool isSelected) {
    setState(() {
      if (isSelected) {
         _selectedWeekdays.addAll([1, 2, 3, 4, 5, 6, 7]);
      } else {
         _selectedWeekdays.clear();
      }
      _ensureDateRangeSet();
      _updateDates();
    });
  }

  void _onQuickSelect(List<int> weekdays) {
    setState(() {
      _selectedWeekdays.clear();
      _selectedWeekdays.addAll(weekdays);
      _ensureDateRangeSet();
      _updateDates();
    });
  }

  void _ensureDateRangeSet() {
    if (_selectedWeekdays.isNotEmpty && _fromDate == null && _toDate == null) {
      final now = DateTime.now();
      _fromDate = DateTime(now.year, now.month, now.day);
      _toDate = _fromDate!.add(const Duration(days: 30));
    }
  }

  void _toggleSpecificDate(DateTime date) {
    setState(() {
      final normalized = DateTime(date.year, date.month, date.day);

      bool coveredByRule = false;
      if (_fromDate != null && _toDate != null &&
          !normalized.isBefore(_fromDate!) && !normalized.isAfter(_toDate!)) {
        coveredByRule = _selectedWeekdays.contains(normalized.weekday);
      }

      if (coveredByRule) {
        if (_explicitlyExcluded.contains(normalized)) {
          _explicitlyExcluded.remove(normalized);
        } else {
          _explicitlyExcluded.add(normalized);
        }
      } else {
        if (_explicitlyIncluded.contains(normalized)) {
          _explicitlyIncluded.remove(normalized);
        } else {
          _explicitlyIncluded.add(normalized);
        }
      }

      _updateDates();
    });
  }

  bool _isDateSelected(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    bool coveredByRule = false;
    if (_fromDate != null && _toDate != null &&
        !normalized.isBefore(_fromDate!) && !normalized.isAfter(_toDate!)) {
      coveredByRule = _selectedWeekdays.contains(normalized.weekday);
    }

    if (coveredByRule) {
      return !_explicitlyExcluded.contains(normalized);
    } else {
      return _explicitlyIncluded.contains(normalized);
    }
  }

  Future<void> _editDateRange() async {
     final result = await showDialog<List<DateTime>>(
       context: context,
       builder: (context) => _CustomRangePicker(
         initialFromDate: _fromDate,
         initialToDate: _toDate,
       ),
     );
     if (result != null && result.length == 2) {
       setState(() {
         _fromDate = result[0];
         _toDate = result[1];
         _updateDates();
       });
     }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── 1. Weekly Pattern ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel('Days of Week', '1', Icons.calendar_view_week_rounded),
                const SizedBox(height: 14),
                // Quick presets
                Row(
                  children: [
                    _buildPresetChip(
                      label: 'Weekdays',
                      isActive: _selectedWeekdays.length == 5 && [1,2,3,4,5].every(_selectedWeekdays.contains) && !_selectedWeekdays.contains(6) && !_selectedWeekdays.contains(7),
                      onTap: () => _onQuickSelect([1,2,3,4,5]),
                    ),
                    const SizedBox(width: 8),
                    _buildPresetChip(
                      label: 'Weekends',
                      isActive: _selectedWeekdays.length == 2 && _selectedWeekdays.contains(6) && _selectedWeekdays.contains(7),
                      onTap: () => _onQuickSelect([6,7]),
                    ),
                    const SizedBox(width: 8),
                    _buildPresetChip(
                      label: 'Every Day',
                      isActive: _selectedWeekdays.length == 7,
                      onTap: () => _toggleEveryday(_selectedWeekdays.length != 7),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Day pill chips
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ['S','M','T','W','T','F','S'].asMap().entries.map((e) {
                      final dayMap = [7, 1, 2, 3, 4, 5, 6];
                      final weekday = dayMap[e.key];
                      final fullLabel = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'][e.key];
                      final sel = _selectedWeekdays.contains(weekday);
                      return _buildDayPill(label: e.value, fullLabel: fullLabel, isSelected: sel, onTap: () => _onWeekdayToggled(weekday, !sel));
                    }).toList(),
                  ].expand((w) => w).toList(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderColor),

          // ── 2. Date Boundaries ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionLabel('Date Range', '2', Icons.date_range_rounded),
                    TextButton.icon(
                      onPressed: _editDateRange,
                      icon: const Icon(Icons.edit_outlined, size: 14),
                      label: const Text('Edit'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildDateField(label: 'Start Date', date: _fromDate, onTap: _editDateRange)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(children: [
                        const SizedBox(height: 16),
                        Icon(Icons.arrow_forward_rounded, size: 16, color: AppTheme.textSecondaryColor),
                      ]),
                    ),
                    Expanded(child: _buildDateField(label: 'End Date', date: _toDate, onTap: _editDateRange)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderColor),

          // ── 3. Refine Specific Dates ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel('Refine Dates', '3', Icons.touch_app_rounded),
                const SizedBox(height: 4),
                Text(
                  'Tap any date below to manually include or exclude it.',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textSecondaryColor, height: 1.4),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildCalendar(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            child: Wrap(
              spacing: 16,
              children: [
                _buildLegendDot(AppTheme.primaryColor, 'Included'),
                _buildLegendDot(Colors.red.shade300, 'Excluded'),
                _buildLegendDot(const Color(0xFFF1F5F9), 'Not selected', hasBorder: true),
              ],
            ),
          ),

          // ── Summary Banner ─────────────────────────────────────────────
          if (widget.state.selectedDates.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppTheme.primaryColor.withOpacity(0.07),
                  AppTheme.secondaryColor.withOpacity(0.04),
                ]),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border(top: BorderSide(color: AppTheme.primaryColor.withOpacity(0.15))),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.event_available_rounded, color: AppTheme.primaryColor, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.state.selectedDates.length} days selected',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.primaryColor),
                        ),
                        Text(
                          '${DateFormat('MMM d').format(widget.state.selectedDates.first)} – ${DateFormat('MMM d, yyyy').format(widget.state.selectedDates.last)}',
                          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.primaryColor.withOpacity(0.7), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (widget.state.selectedDates.isEmpty) const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title, String step, IconData icon) {
    return Row(
      children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(7)),
          child: Center(child: Text(step, style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11))),
        ),
        const SizedBox(width: 8),
        Icon(icon, size: 15, color: AppTheme.textSecondaryColor),
        const SizedBox(width: 5),
        Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.textColor)),
      ],
    );
  }

  Widget _buildPresetChip({required String label, required bool isActive, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isActive ? AppTheme.primaryColor : AppTheme.borderColor, width: isActive ? 1.5 : 1),
            boxShadow: isActive ? [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 2))] : [],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12, color: isActive ? Colors.white : AppTheme.textColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayPill({required String label, required String fullLabel, required bool isSelected, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Tooltip(
          message: fullLabel,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 44,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor),
              boxShadow: isSelected ? [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.25), blurRadius: 4, offset: const Offset(0, 2))] : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 13, color: isSelected ? Colors.white : AppTheme.textColor)),
                Text(fullLabel, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, fontSize: 9, color: isSelected ? Colors.white.withOpacity(0.8) : AppTheme.textSecondaryColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({required String label, required DateTime? date, required VoidCallback onTap}) {
    final hasDate = date != null;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textSecondaryColor, letterSpacing: 0.3)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: hasDate ? AppTheme.primaryColor.withOpacity(0.04) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: hasDate ? AppTheme.primaryColor.withOpacity(0.3) : AppTheme.borderColor),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 14, color: hasDate ? AppTheme.primaryColor : AppTheme.textSecondaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hasDate ? DateFormat('MMM d, yyyy').format(date!) : 'Not set',
                    style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: hasDate ? FontWeight.w700 : FontWeight.w500, color: hasDate ? AppTheme.textColor : AppTheme.textSecondaryColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label, {bool hasBorder = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12, height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: hasBorder ? Border.all(color: AppTheme.borderColor) : null,
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondaryColor)),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.textSecondaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: AppTheme.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          // Month navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: () {
                    setState(() {
                      _calendarMonth = DateTime(_calendarMonth.year, _calendarMonth.month - 1);
                    });
                  },
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_calendarMonth),
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: () {
                    setState(() {
                      _calendarMonth = DateTime(_calendarMonth.year, _calendarMonth.month + 1);
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderColor),
          // Days of week header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((d) {
                return Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Grid
          _buildCalendarGrid(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_calendarMonth.year, _calendarMonth.month, 1);
    final lastDayOfMonth = DateTime(_calendarMonth.year, _calendarMonth.month + 1, 0);
    
    // Calculate leading empty cells (Sun = 7 in Dart, we want Sun = 0)
    final leadingEmpty = firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;
    final totalCells = leadingEmpty + lastDayOfMonth.day;
    final rows = (totalCells / 7).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: List.generate(rows, (rowIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (colIndex) {
              final cellIndex = rowIndex * 7 + colIndex;
              final day = cellIndex - leadingEmpty + 1;
              
              if (day < 1 || day > lastDayOfMonth.day) {
                return const Expanded(child: SizedBox(height: 36)); // empty cell
              }
              
              final date = DateTime(_calendarMonth.year, _calendarMonth.month, day);
              final isSelected = _isDateSelected(date);
              
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: InkWell(
                    onTap: () => _toggleSpecificDate(date),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          day.toString(),
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? Colors.white : AppTheme.textColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}

// (old _QuickSelectButton and _DayCheckbox replaced by inline helpers in _DateConfigCardState)

// ── Staff Assignment Section ─────────────────────────────────────────────────

class _StaffAssignmentSection extends StatelessWidget {
  final BulkAssignmentState state;
  final List<Doctor> doctors;
  final WidgetRef ref;

  const _StaffAssignmentSection({
    required this.state,
    required this.doctors,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ShiftCard(
          title: 'Day Shift',
          icon: Icons.wb_sunny_rounded,
          color: Colors.orange.shade600,
          children: state.selectedDepartmentId == null
              ? [
                  _buildLockedPlaceholder(
                      'Select a department first to assign doctors'),
                ]
              : [
                  _StaffingSlot(
                    label: 'Primary On-Call',
                    subtitle: 'First respondent for emergencies',
                    icon: Icons.looks_one_rounded,
                    color: AppTheme.primaryColor,
                    selectedIds: state.dayFirstOnCallDoctorIds,
                    allDoctors: doctors,
                    onChanged: (ids) => ref
                        .read(bulkAssignmentControllerProvider.notifier)
                        .updateDayFirstOnCall(ids),
                    departmentId: state.selectedDepartmentId!,
                  ),
                  const SizedBox(height: 12),
                  _StaffingSlot(
                    label: 'Secondary On-Call',
                    subtitle: 'Backup support contact',
                    icon: Icons.looks_two_rounded,
                    color: AppTheme.secondaryColor,
                    selectedIds: state.daySecondOnCallDoctorIds,
                    allDoctors: doctors,
                    onChanged: (ids) => ref
                        .read(bulkAssignmentControllerProvider.notifier)
                        .updateDaySecondOnCall(ids),
                    departmentId: state.selectedDepartmentId!,
                  ),
                ],
        ),
        const SizedBox(height: 16),
        _ShiftCard(
          title: 'Night Shift',
          icon: Icons.nightlight_round,
          color: Colors.indigo.shade500,
          children: state.selectedDepartmentId == null
              ? [
                  _buildLockedPlaceholder(
                      'Select a department first to assign doctors'),
                ]
              : [
                  _StaffingSlot(
                    label: 'Primary On-Call',
                    subtitle: 'Main overnight contact',
                    icon: Icons.looks_one_rounded,
                    color: AppTheme.primaryColor,
                    selectedIds: state.nightFirstOnCallDoctorIds,
                    allDoctors: doctors,
                    onChanged: (ids) => ref
                        .read(bulkAssignmentControllerProvider.notifier)
                        .updateNightFirstOnCall(ids),
                    departmentId: state.selectedDepartmentId!,
                  ),
                  const SizedBox(height: 12),
                  _StaffingSlot(
                    label: 'Secondary On-Call',
                    subtitle: 'Overnight backup support',
                    icon: Icons.looks_two_rounded,
                    color: AppTheme.secondaryColor,
                    selectedIds: state.nightSecondOnCallDoctorIds,
                    allDoctors: doctors,
                    onChanged: (ids) => ref
                        .read(bulkAssignmentControllerProvider.notifier)
                        .updateNightSecondOnCall(ids),
                    departmentId: state.selectedDepartmentId!,
                  ),
                ],
        ),
      ],
    );
  }

  Widget _buildLockedPlaceholder(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderColor.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(Icons.lock_outline_rounded,
              size: 20, color: AppTheme.textSecondaryColor.withOpacity(0.5)),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.textSecondaryColor.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ShiftCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _ShiftCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 14, color: color),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: AppTheme.textColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderColor),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _StaffingSlot extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<String> selectedIds;
  final List<Doctor> allDoctors;
  final Function(List<String>) onChanged;
  final String departmentId;

  const _StaffingSlot({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.selectedIds,
    required this.allDoctors,
    required this.onChanged,
    required this.departmentId,
  });

  @override
  Widget build(BuildContext context) {
    final hasAssignment = selectedIds.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasAssignment ? color.withOpacity(0.03) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasAssignment ? color.withOpacity(0.2) : AppTheme.borderColor.withOpacity(0.6),
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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: AppTheme.textColor,
                      ),
                    ),
                    Text(
                      subtitle,
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${selectedIds.length}',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      color: color,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          DoctorChipSelector(
            selectedIds: selectedIds,
            onChanged: onChanged,
            doctorsAsync: AsyncValue.data(allDoctors),
            departmentId: departmentId,
          ),
        ],
      ),
    );
  }
}

// ── Apply Button ─────────────────────────────────────────────────────────────

class _ApplyButton extends StatelessWidget {
  final BulkAssignmentState state;
  final WidgetRef ref;

  const _ApplyButton({required this.state, required this.ref});

  @override
  Widget build(BuildContext context) {
    final isReady = state.selectedDepartmentId != null && state.selectedDates.isNotEmpty;

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isReady && !state.isApplying
            ? const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        boxShadow: isReady && !state.isApplying
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isReady && !state.isApplying
            ? () async {
                await ref.read(bulkAssignmentControllerProvider.notifier).apply();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            'Bulk assignment applied successfully',
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppTheme.textColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.all(24),
                    ),
                  );
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isReady ? Colors.transparent : Colors.grey.shade200,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: state.isApplying
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(
                'Apply Bulk Assignment',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}

class _CustomRangePicker extends StatefulWidget {
  final DateTime? initialFromDate;
  final DateTime? initialToDate;
  const _CustomRangePicker({this.initialFromDate, this.initialToDate});

  @override
  State<_CustomRangePicker> createState() => _CustomRangePickerState();
}

class _CustomRangePickerState extends State<_CustomRangePicker> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _fromDate = widget.initialFromDate;
    _toDate = widget.initialToDate;
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final now = DateUtils.dateOnly(DateTime.now());
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom 
          ? (_fromDate != null && _fromDate!.isBefore(now) ? now : (_fromDate ?? now)) 
          : (_toDate != null && _toDate!.isBefore(now) ? now : (_toDate ?? _fromDate ?? now)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppTheme.primaryColor,
            onPrimary: Colors.white,
            onSurface: AppTheme.textColor,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
          if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
            _toDate = null;
          }
        } else {
          _toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.date_range_rounded, color: AppTheme.primaryColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Set Date Range',
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18, color: AppTheme.textColor)),
                        Text('Select start and end dates',
                            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textSecondaryColor)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: AppTheme.textSecondaryColor,
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildPickerField(
                          context: context,
                          label: 'From Date',
                          icon: Icons.flight_takeoff_rounded,
                          date: _fromDate,
                          isFrom: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(children: [
                          const SizedBox(height: 22),
                          Container(
                            width: 32, height: 2,
                            color: AppTheme.borderColor,
                          ),
                        ]),
                      ),
                      Expanded(
                        child: _buildPickerField(
                          context: context,
                          label: 'To Date',
                          icon: Icons.flight_land_rounded,
                          date: _toDate,
                          isFrom: false,
                        ),
                      ),
                    ],
                  ),
                  if (_fromDate != null && _toDate != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.15)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded, size: 16, color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            '${_toDate!.difference(_fromDate!).inDays + 1} day range selected',
                            style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Footer actions
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textSecondaryColor,
                        side: BorderSide(color: AppTheme.borderColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (_fromDate != null && _toDate != null)
                          ? () => Navigator.pop(context, [_fromDate!, _toDate!])
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppTheme.borderColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text('Confirm', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerField({
    required BuildContext context,
    required String label,
    required IconData icon,
    required DateTime? date,
    required bool isFrom,
  }) {
    final enabled = isFrom || _fromDate != null;
    return GestureDetector(
      onTap: enabled ? () => _selectDate(context, isFrom) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textSecondaryColor, letterSpacing: 0.3)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: date != null ? AppTheme.primaryColor.withOpacity(0.04) : AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: date != null ? AppTheme.primaryColor.withOpacity(0.3) : AppTheme.borderColor,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 15, color: date != null ? AppTheme.primaryColor : AppTheme.textSecondaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    date != null ? DateFormat('MMM d, yyyy').format(date) : 'Not set',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: date != null ? FontWeight.w700 : FontWeight.w500,
                      color: date != null ? AppTheme.textColor : AppTheme.textSecondaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class _DateTextField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final bool enabled;

  const _DateTextField({
    required this.label,
    required this.date,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: enabled ? Colors.white : AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: enabled ? AppTheme.borderColor : AppTheme.borderColor.withOpacity(0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: enabled ? AppTheme.primaryColor : AppTheme.textSecondaryColor.withOpacity(0.5),
                ),
                const SizedBox(width: 12),
                Text(
                  date != null
                      ? DateFormat('EEE, MMM d, yyyy').format(date!)
                      : 'Select date',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: date != null
                        ? AppTheme.textColor
                        : AppTheme.textSecondaryColor.withOpacity(0.5),
                    fontWeight: date != null ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
