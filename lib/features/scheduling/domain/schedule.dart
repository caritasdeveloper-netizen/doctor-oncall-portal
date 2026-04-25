import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';

@freezed
abstract class DailySchedule with _$DailySchedule {
  const factory DailySchedule({
    required String id,
    required DateTime date,
    required String departmentId,
    @Default([]) List<String> dayFirstOnCallDoctorIds,
    @Default([]) List<String> daySecondOnCallDoctorIds,
    @Default([]) List<String> nightFirstOnCallDoctorIds,
    @Default([]) List<String> nightSecondOnCallDoctorIds,
    
    // For backward compatibility during migration
    @Default([]) List<String> firstOnCallDoctorIds,
    @Default([]) List<String> secondOnCallDoctorIds,
  }) = _DailySchedule;

  factory DailySchedule.fromJson(Map<String, dynamic> json) => _$DailyScheduleFromJson(json);
}

@freezed
abstract class BulkAssignmentRequest with _$BulkAssignmentRequest {
  const factory BulkAssignmentRequest({
    required List<String> departmentIds,
    required List<DateTime> dates,
    @Default([]) List<String> dayFirstOnCallDoctorIds,
    @Default([]) List<String> daySecondOnCallDoctorIds,
    @Default([]) List<String> nightFirstOnCallDoctorIds,
    @Default([]) List<String> nightSecondOnCallDoctorIds,
    required bool overrideExisting,
  }) = _BulkAssignmentRequest;
}
