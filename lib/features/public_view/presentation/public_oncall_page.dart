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
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1C1E),
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
                        fontSize: 18,
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
    final dayDoctorIds = {
      ...schedule.dayFirstOnCallDoctorIds,
      ...schedule.daySecondOnCallDoctorIds,
    };
    final nightDoctorIds = {
      ...schedule.nightFirstOnCallDoctorIds,
      ...schedule.nightSecondOnCallDoctorIds,
    };

    final dayDoctors = doctors.where((d) => dayDoctorIds.contains(d.id)).toList();
    final nightDoctors = doctors.where((d) => nightDoctorIds.contains(d.id)).toList();
    
    final totalOnCall = dayDoctors.length + nightDoctors.length;

    if (_searchQuery.isNotEmpty && totalOnCall == 0 && !dept.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFECEFF3)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          iconColor: const Color(0xFF0056D2),
          collapsedIconColor: const Color(0xFF8E9199),
          title: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B00),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                dept.name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$totalOnCall',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8E9199),
                ),
              ),
            ],
          ),
          childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day Shift Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShiftHeader('Day Shift', Icons.wb_sunny_rounded, Colors.orange),
                      const SizedBox(height: 16),
                      if (dayDoctors.isEmpty)
                        _buildEmptyShift()
                      else
                        ...dayDoctors.map((doc) => _buildDoctorCard(doc, dept.name)),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Night Shift Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShiftHeader('Night Shift', Icons.nightlight_round, Colors.indigo),
                      const SizedBox(height: 16),
                      if (nightDoctors.isEmpty)
                        _buildEmptyShift()
                      else
                        ...nightDoctors.map((doc) => _buildDoctorCard(doc, dept.name)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftHeader(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyShift() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFECEFF3), width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.event_busy_rounded, size: 32, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 12),
          Text(
            'No assignments',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: const Color(0xFF8E9199),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor, String deptName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFECEFF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Icon at the left side
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFECEFF3)),
            ),
            child: const Icon(Icons.person_rounded, color: Color(0xFF0056D2), size: 24),
          ),
          const SizedBox(width: 16),
          // Left Side: Name and Phone Number
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1C1E),
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.phoneNumber,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8E9199),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Right Side: On-Call Status and Call Now Button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F3FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'On-Call Now',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0056D2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => _makePhoneCall(doctor.phoneNumber),
                icon: const Icon(Icons.call_rounded, size: 16),
                label: const Text('Call Now'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0056D2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                  textStyle: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

