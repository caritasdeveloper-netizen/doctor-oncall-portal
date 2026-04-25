import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oncall_doctor/features/scheduling/domain/schedule.dart';
import 'package:oncall_doctor/features/scheduling/infrastructure/firebase_schedule_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bulk_assignment_controller.freezed.dart';
part 'bulk_assignment_controller.g.dart';

@freezed
abstract class BulkAssignmentState with _$BulkAssignmentState {
  const factory BulkAssignmentState({
    @Default([]) List<String> selectedDepartmentIds,
    @Default([]) List<DateTime> selectedDates,
    @Default([]) List<String> dayFirstOnCallDoctorIds,
    @Default([]) List<String> daySecondOnCallDoctorIds,
    @Default([]) List<String> nightFirstOnCallDoctorIds,
    @Default([]) List<String> nightSecondOnCallDoctorIds,
    @Default(false) bool isApplying,
  }) = _BulkAssignmentState;
}

@riverpod
class BulkAssignmentController extends _$BulkAssignmentController {
  @override
  BulkAssignmentState build() => const BulkAssignmentState();

  void updateDepartments(List<String> ids) => state = state.copyWith(selectedDepartmentIds: ids);
  void updateDates(List<DateTime> dates) => state = state.copyWith(selectedDates: dates);
  
  void updateDayFirstOnCall(List<String> ids) => state = state.copyWith(dayFirstOnCallDoctorIds: ids);
  void updateDaySecondOnCall(List<String> ids) => state = state.copyWith(daySecondOnCallDoctorIds: ids);
  void updateNightFirstOnCall(List<String> ids) => state = state.copyWith(nightFirstOnCallDoctorIds: ids);
  void updateNightSecondOnCall(List<String> ids) => state = state.copyWith(nightSecondOnCallDoctorIds: ids);

  Future<void> apply() async {
    state = state.copyWith(isApplying: true);
    try {
      final request = BulkAssignmentRequest(
        departmentIds: state.selectedDepartmentIds,
        dates: state.selectedDates,
        dayFirstOnCallDoctorIds: state.dayFirstOnCallDoctorIds,
        daySecondOnCallDoctorIds: state.daySecondOnCallDoctorIds,
        nightFirstOnCallDoctorIds: state.nightFirstOnCallDoctorIds,
        nightSecondOnCallDoctorIds: state.nightSecondOnCallDoctorIds,
        overrideExisting: true,
      );
      await ref.read(scheduleRepositoryProvider).applyBulkAssignment(request);
      state = const BulkAssignmentState();
    } finally {
      state = state.copyWith(isApplying: false);
    }
  }
}
