import 'package:oncall_doctor/features/scheduling/domain/schedule.dart';

abstract class ScheduleRepository {
  Stream<List<DailySchedule>> watchSchedules(DateTime date);
  Future<void> saveSchedules(List<DailySchedule> schedules);
  Future<void> applyBulkAssignment(BulkAssignmentRequest request);
}
