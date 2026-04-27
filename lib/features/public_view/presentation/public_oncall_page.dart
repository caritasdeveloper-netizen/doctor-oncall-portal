import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/departments/application/department_provider.dart';
import 'package:oncall_doctor/features/doctors/application/doctor_provider.dart';
import 'package:oncall_doctor/features/scheduling/application/scheduling_controller.dart';
import 'package:oncall_doctor/features/scheduling/domain/schedule.dart';
import 'package:oncall_doctor/features/doctors/domain/doctor.dart';
import 'package:oncall_doctor/features/departments/domain/department.dart';

class PublicOnCallPage extends ConsumerStatefulWidget {
  const PublicOnCallPage({super.key});

  @override
  ConsumerState<PublicOnCallPage> createState() => _PublicOnCallPageState();
}

class _PublicOnCallPageState extends ConsumerState<PublicOnCallPage> {
  DateTime _selectedDate = DateTime.now();
  String _searchQuery = '';

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $phoneNumber')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final departmentsAsync = ref.watch(departmentsProvider);
    final doctorsAsync = ref.watch(doctorsProvider);
    final schedulesAsync = ref.watch(dailySchedulesProvider(_selectedDate));

    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFF),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilters(departmentsAsync),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          schedulesAsync.when(
            data: (schedules) => doctorsAsync.when(
              data: (doctors) => departmentsAsync.when(
                data: (departments) => _buildScheduleList(schedules, doctors, departments),
                loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
                error: (e, s) => SliverFillRemaining(child: Center(child: Text('Error: $e'))),
              ),
              loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
              error: (e, s) => SliverFillRemaining(child: Center(child: Text('Error: $e'))),
            ),
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            error: (e, s) => SliverFillRemaining(child: Center(child: Text('Error: $e'))),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 60)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFFFBFDFF).withOpacity(0.95),
      surfaceTintColor: Colors.transparent,
      expandedHeight: 80,
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.medical_services_rounded, color: AppTheme.primaryColor, size: 28),
          ),
          const SizedBox(width: 16),
          Text(
            'CARITAS',
            style: GoogleFonts.plusJakartaSans(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              fontSize: 22,
            ),
          ),
          Text(
            'CONNECT',
            style: GoogleFonts.plusJakartaSans(
              color: AppTheme.textColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              fontSize: 22,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: FilledButton.icon(
            onPressed: () => context.goNamed('login'),
            icon: const Icon(Icons.lock_outline_rounded, size: 18),
            label: const Text('Admin Portal'),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.textColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildFilters(AsyncValue<List<Department>> departmentsAsync) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Search Department',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textColor,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type ward or specialty...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: AppTheme.textSecondaryColor.withOpacity(0.7),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textSecondaryColor, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            flex: 3,
            child: _buildDateSelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            DateFormat('MMMM yyyy').format(_selectedDate),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1C1E),
              letterSpacing: -0.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildDateNavButton(Icons.chevron_left_rounded, () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 7));
              });
            }),
            const SizedBox(width: 8),
            SizedBox(
              height: 75,
              width: 480, // Fixed width for 7 compact cards
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(), // Since it's fixed 7 days
                itemCount: 7,
                itemBuilder: (context, index) {
                  final firstDayOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday % 7));
                  final date = firstDayOfWeek.add(Duration(days: index));
                  final isSelected = date.day == _selectedDate.day && 
                                   date.month == _selectedDate.month && 
                                   date.year == _selectedDate.year;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                    child: InkWell(
                      onTap: () => setState(() => _selectedDate = date),
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 62,
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF0056D2) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF0056D2) : const Color(0xFFECEFF3),
                            width: 1,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: const Color(0xFF0056D2).withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ] : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('E').format(date).toUpperCase(),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white.withOpacity(0.9) : const Color(0xFF8E9199),
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              date.day.toString(),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? Colors.white : const Color(0xFF1A1C1E),
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            _buildDateNavButton(Icons.chevron_right_rounded, () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 7));
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildDateNavButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFECEFF3)),
        ),
        child: Icon(icon, color: const Color(0xFF1A1C1E), size: 20),
      ),
    );
  }

  Widget _buildScheduleList(List<DailySchedule> schedules, List<Doctor> doctors, List<Department> departments) {
    final sortedDepartments = List<Department>.from(departments)
      ..sort((a, b) => a.name.compareTo(b.name));

    final deptsToShow = _searchQuery.isEmpty 
      ? sortedDepartments
      : sortedDepartments.where((d) => d.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    if (deptsToShow.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text('No departments found.')),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final dept = deptsToShow[index];
            final schedule = schedules.firstWhere(
              (s) => s.departmentId == dept.id,
              orElse: () => DailySchedule(id: '', date: _selectedDate, departmentId: dept.id),
            );

            return _buildDepartmentSection(dept, schedule, doctors);
          },
          childCount: deptsToShow.length,
        ),
      ),
    );
  }

  Widget _buildDepartmentSection(Department dept, DailySchedule schedule, List<Doctor> doctors) {
    final allOnCallIds = {
      ...schedule.dayFirstOnCallDoctorIds,
      ...schedule.daySecondOnCallDoctorIds,
      ...schedule.nightFirstOnCallDoctorIds,
      ...schedule.nightSecondOnCallDoctorIds,
    };

    final onCallDoctors = doctors.where((d) => allOnCallIds.contains(d.id)).toList();
    
    final displayDoctors = onCallDoctors;

    if (_searchQuery.isNotEmpty && displayDoctors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 4),
          child: Row(
            children: [
              Text(
                dept.name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${displayDoctors.length} On-Call',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (displayDoctors.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.borderColor.withOpacity(0.3), width: 1),
            ),
            child: Column(
              children: [
                Icon(Icons.event_busy_rounded, size: 48, color: AppTheme.textSecondaryColor.withOpacity(0.5)),
                const SizedBox(height: 16),
                Text(
                  'No doctors assigned for this shift',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 420,
              mainAxisExtent: 130,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: displayDoctors.length,
            itemBuilder: (context, index) {
              final doctor = displayDoctors[index];
              return _buildDoctorCard(doctor, schedule);
            },
          ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDoctorCard(Doctor doctor, DailySchedule schedule) {
    bool isDay = schedule.dayFirstOnCallDoctorIds.contains(doctor.id) || schedule.daySecondOnCallDoctorIds.contains(doctor.id);
    bool isNight = schedule.nightFirstOnCallDoctorIds.contains(doctor.id) || schedule.nightSecondOnCallDoctorIds.contains(doctor.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _makePhoneCall(doctor.phoneNumber),
          borderRadius: BorderRadius.circular(20),
          hoverColor: AppTheme.primaryColor.withOpacity(0.02),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      doctor.name[0].toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        doctor.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: AppTheme.textColor,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        doctor.phoneNumber,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          if (isDay) _buildShiftPill(true),
                          if (isDay && isNight) const SizedBox(width: 8),
                          if (isNight) _buildShiftPill(false),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Icon(Icons.call_rounded, color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShiftPill(bool isDay) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDay ? Colors.amber.shade50 : Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDay ? Colors.amber.shade200 : Colors.indigo.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            size: 12,
            color: isDay ? Colors.orange.shade700 : Colors.indigo.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            isDay ? 'Day' : 'Night',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: isDay ? Colors.orange.shade700 : Colors.indigo.shade700,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
