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
    @Default([]) List<String> firstOnCallDoctorIds,
    @Default([]) List<String> secondOnCallDoctorIds,
    @Default(false) bool isApplying,
  }) = _BulkAssignmentState;
}

@riverpod
class BulkAssignmentController extends _$BulkAssignmentController {
  @override
  BulkAssignmentState build() => const BulkAssignmentState();

  void updateDepartments(List<String> ids) => state = state.copyWith(selectedDepartmentIds: ids);
  void updateDates(List<DateTime> dates) => state = state.copyWith(selectedDates: dates);
  void updateFirstOnCall(List<String> ids) => state = state.copyWith(firstOnCallDoctorIds: ids);
  void updateSecondOnCall(List<String> ids) => state = state.copyWith(secondOnCallDoctorIds: ids);

  Future<void> apply() async {
    state = state.copyWith(isApplying: true);
    try {
      final request = BulkAssignmentRequest(
        departmentIds: state.selectedDepartmentIds,
        dates: state.selectedDates,
        firstOnCallDoctorIds: state.firstOnCallDoctorIds,
        secondOnCallDoctorIds: state.secondOnCallDoctorIds,
        overrideExisting: true,
      );
      await ref.read(scheduleRepositoryProvider).applyBulkAssignment(request);
      state = const BulkAssignmentState();
    } finally {
      state = state.copyWith(isApplying: false);
    }
  }
}
