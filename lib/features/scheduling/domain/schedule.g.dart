// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailySchedule _$DailyScheduleFromJson(Map<String, dynamic> json) =>
    _DailySchedule(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      departmentId: json['departmentId'] as String,
      dayFirstOnCallDoctorIds:
          (json['dayFirstOnCallDoctorIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      daySecondOnCallDoctorIds:
          (json['daySecondOnCallDoctorIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nightFirstOnCallDoctorIds:
          (json['nightFirstOnCallDoctorIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nightSecondOnCallDoctorIds:
          (json['nightSecondOnCallDoctorIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      firstOnCallDoctorIds:
          (json['firstOnCallDoctorIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      secondOnCallDoctorIds:
          (json['secondOnCallDoctorIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DailyScheduleToJson(_DailySchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'departmentId': instance.departmentId,
      'dayFirstOnCallDoctorIds': instance.dayFirstOnCallDoctorIds,
      'daySecondOnCallDoctorIds': instance.daySecondOnCallDoctorIds,
      'nightFirstOnCallDoctorIds': instance.nightFirstOnCallDoctorIds,
      'nightSecondOnCallDoctorIds': instance.nightSecondOnCallDoctorIds,
      'firstOnCallDoctorIds': instance.firstOnCallDoctorIds,
      'secondOnCallDoctorIds': instance.secondOnCallDoctorIds,
    };
