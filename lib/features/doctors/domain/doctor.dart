import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor.freezed.dart';
part 'doctor.g.dart';

@freezed
abstract class Doctor with _$Doctor {
  const factory Doctor({
    required String id,
    required String employeeId,
    required String name,
    required String phoneNumber,
    required List<String> departmentIds,
  }) = _Doctor;

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);
}
