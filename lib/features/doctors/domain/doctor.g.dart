// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Doctor _$DoctorFromJson(Map<String, dynamic> json) => _Doctor(
  id: json['id'] as String,
  employeeId: json['employeeId'] as String,
  name: json['name'] as String,
  phoneNumber: json['phoneNumber'] as String,
  departmentIds: (json['departmentIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$DoctorToJson(_Doctor instance) => <String, dynamic>{
  'id': instance.id,
  'employeeId': instance.employeeId,
  'name': instance.name,
  'phoneNumber': instance.phoneNumber,
  'departmentIds': instance.departmentIds,
};
