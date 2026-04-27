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
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
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
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: _buildFiltersCard(departmentsAsync),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
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

          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.08),
      centerTitle: false,
      toolbarHeight: 64,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFE8ECF0)),
      ),
      title: Row(
        children: [
          Image.asset(
            'assets/logo.webp',
            height: 32,
            fit: BoxFit.fitHeight,
            errorBuilder: (context, error, stackTrace) => Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0056D2), Color(0xFF0084FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Text('CARITAS', style: GoogleFonts.plusJakartaSans(color: AppTheme.primaryColor, fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 18)),
          Text('Doctor OnCall', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF1A1C1E), fontWeight: FontWeight.w600, letterSpacing: 1.5, fontSize: 18)),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: FilledButton.icon(
            onPressed: () => context.goNamed('login'),
            icon: const Icon(Icons.lock_outline_rounded, size: 16),
            label: const Text('Admin Portal'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1A1C1E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 0.3),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildFiltersCard(AsyncValue<List<Department>> departmentsAsync) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8ECF0)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8)),
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
                  Text('Search Department', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF8E9199), letterSpacing: 0.8)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8ECF0)),
                    ),
                    child: TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1A1C1E)),
                      decoration: InputDecoration(
                        hintText: 'Type ward or specialty...',
                        hintStyle: GoogleFonts.plusJakartaSans(color: const Color(0xFFBBC1CC), fontSize: 14, fontWeight: FontWeight.w500),
                        prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF8E9199), size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(width: 1, height: 72, margin: const EdgeInsets.symmetric(horizontal: 24), color: const Color(0xFFE8ECF0)),
            Expanded(flex: 3, child: _buildDateSelector()),
          ],
        ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          DateFormat('MMMM yyyy').format(_selectedDate),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF8E9199),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildDateNavButton(Icons.chevron_left_rounded, () => setState(() => _selectedDate = _selectedDate.subtract(const Duration(days: 1)))),
            const SizedBox(width: 8),
            SizedBox(
              height: 80,
              width: 450,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: 7,
                itemBuilder: (context, index) {
                  final firstDayOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday % 7));
                  final date = firstDayOfWeek.add(Duration(days: index));
                  final isSelected = DateUtils.isSameDay(date, _selectedDate);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () => setState(() => _selectedDate = date),
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 60,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF0056D2) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF0056D2) : const Color(0xFFE8ECF0),
                            width: 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF0056D2).withOpacity(0.25),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  )
                                ]
                              : [],
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
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              date.day.toString(),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? Colors.white : const Color(0xFF1A1C1E),
                                height: 1,
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
            _buildDateNavButton(Icons.chevron_right_rounded, () => setState(() => _selectedDate = _selectedDate.add(const Duration(days: 1)))),
          ],
        ),
      ],
    );
  }

  Widget _buildDateNavButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE8ECF0)), color: const Color(0xFFF5F7FA)),
        child: Icon(icon, color: const Color(0xFF1A1C1E), size: 18),
      ),
    );
  }

  Widget _buildScheduleList(List<DailySchedule> schedules, List<Doctor> doctors, List<Department> departments) {
    final sorted = List<Department>.from(departments)..sort((a, b) => a.name.compareTo(b.name));
    final visible = _searchQuery.isEmpty ? sorted : sorted.where((d) => d.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    if (visible.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.withOpacity(0.35)),
              const SizedBox(height: 12),
              Text('No departments found', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF8E9199))),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final dept = visible[index];
            final schedule = schedules.firstWhere((s) => s.departmentId == dept.id, orElse: () => DailySchedule(id: '', date: _selectedDate, departmentId: dept.id));
            return _buildDepartmentSection(dept, schedule, doctors);
          },
          childCount: visible.length,
        ),
      ),
    );
  }

  Widget _buildDepartmentSection(Department dept, DailySchedule schedule, List<Doctor> doctors) {
    final dayDoctorIds = {...schedule.dayFirstOnCallDoctorIds, ...schedule.daySecondOnCallDoctorIds};
    final nightDoctorIds = {...schedule.nightFirstOnCallDoctorIds, ...schedule.nightSecondOnCallDoctorIds};
    final dayDoctors = doctors.where((d) => dayDoctorIds.contains(d.id)).toList();
    final nightDoctors = doctors.where((d) => nightDoctorIds.contains(d.id)).toList();
    final total = dayDoctors.length + nightDoctors.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8ECF0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          iconColor: const Color(0xFF0056D2),
          collapsedIconColor: const Color(0xFF8E9199),
          title: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFFF3E8), Color(0xFFFFE8CC)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFD199).withOpacity(0.5)),
                ),
                child: const Icon(Icons.business_rounded, color: Color(0xFFFF6B00), size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(dept.name, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF1A1C1E))),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: total > 0 ? const Color(0xFFE7F3FF) : const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$total on call',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: total > 0 ? const Color(0xFF0056D2) : const Color(0xFF8E9199)),
                ),
              ),
            ],
          ),
          childrenPadding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          children: [
            Container(height: 1, color: const Color(0xFFF0F4F8), margin: const EdgeInsets.only(bottom: 16)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildShiftColumn('Day Shift', Icons.wb_sunny_rounded, const Color(0xFFFF8C00), dayDoctors)),
                const SizedBox(width: 16),
                Expanded(child: _buildShiftColumn('Night Shift', Icons.nightlight_round, const Color(0xFF5C6BC0), nightDoctors)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftColumn(String title, IconData icon, Color color, List<Doctor> doctors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.15)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 6),
              Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w800, color: color, letterSpacing: 0.3)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (doctors.isEmpty)
          _buildEmptyShift()
        else
          ...doctors.map((doc) => _buildDoctorCard(doc, color)),
      ],
    );
  }

  Widget _buildEmptyShift() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF0), style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(Icons.event_busy_rounded, size: 28, color: const Color(0xFFBBC1CC)),
          const SizedBox(height: 8),
          Text('No assignments', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFFBBC1CC), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor, Color accentColor) {
    final initials = doctor.name.trim().split(' ').take(2).map((w) => w.isNotEmpty ? w[0] : '').join().toUpperCase();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [accentColor.withOpacity(0.15), accentColor.withOpacity(0.25)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              shape: BoxShape.circle,
              border: Border.all(color: accentColor.withOpacity(0.25)),
            ),
            child: Center(child: Text(initials, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: accentColor))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor.name, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF1A1C1E), letterSpacing: -0.2), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 12, color: Color(0xFF8E9199)),
                    const SizedBox(width: 4),
                    Text(doctor.phoneNumber, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF8E9199))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text('On-Call', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF22C55E))),
                ],
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () => _makePhoneCall(doctor.phoneNumber),
                icon: const Icon(Icons.call_rounded, size: 14),
                label: const Text('Call'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0056D2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                  textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


}
