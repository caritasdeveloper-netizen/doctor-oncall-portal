// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_assignment_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BulkAssignmentState {

 String? get selectedDepartmentId; List<DateTime> get selectedDates; List<String> get dayFirstOnCallDoctorIds; List<String> get daySecondOnCallDoctorIds; List<String> get nightFirstOnCallDoctorIds; List<String> get nightSecondOnCallDoctorIds; bool get isApplying;
/// Create a copy of BulkAssignmentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkAssignmentStateCopyWith<BulkAssignmentState> get copyWith => _$BulkAssignmentStateCopyWithImpl<BulkAssignmentState>(this as BulkAssignmentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkAssignmentState&&(identical(other.selectedDepartmentId, selectedDepartmentId) || other.selectedDepartmentId == selectedDepartmentId)&&const DeepCollectionEquality().equals(other.selectedDates, selectedDates)&&const DeepCollectionEquality().equals(other.dayFirstOnCallDoctorIds, dayFirstOnCallDoctorIds)&&const DeepCollectionEquality().equals(other.daySecondOnCallDoctorIds, daySecondOnCallDoctorIds)&&const DeepCollectionEquality().equals(other.nightFirstOnCallDoctorIds, nightFirstOnCallDoctorIds)&&const DeepCollectionEquality().equals(other.nightSecondOnCallDoctorIds, nightSecondOnCallDoctorIds)&&(identical(other.isApplying, isApplying) || other.isApplying == isApplying));
}


@override
int get hashCode => Object.hash(runtimeType,selectedDepartmentId,const DeepCollectionEquality().hash(selectedDates),const DeepCollectionEquality().hash(dayFirstOnCallDoctorIds),const DeepCollectionEquality().hash(daySecondOnCallDoctorIds),const DeepCollectionEquality().hash(nightFirstOnCallDoctorIds),const DeepCollectionEquality().hash(nightSecondOnCallDoctorIds),isApplying);

@override
String toString() {
  return 'BulkAssignmentState(selectedDepartmentId: $selectedDepartmentId, selectedDates: $selectedDates, dayFirstOnCallDoctorIds: $dayFirstOnCallDoctorIds, daySecondOnCallDoctorIds: $daySecondOnCallDoctorIds, nightFirstOnCallDoctorIds: $nightFirstOnCallDoctorIds, nightSecondOnCallDoctorIds: $nightSecondOnCallDoctorIds, isApplying: $isApplying)';
}


}

/// @nodoc
abstract mixin class $BulkAssignmentStateCopyWith<$Res>  {
  factory $BulkAssignmentStateCopyWith(BulkAssignmentState value, $Res Function(BulkAssignmentState) _then) = _$BulkAssignmentStateCopyWithImpl;
@useResult
$Res call({
 String? selectedDepartmentId, List<DateTime> selectedDates, List<String> dayFirstOnCallDoctorIds, List<String> daySecondOnCallDoctorIds, List<String> nightFirstOnCallDoctorIds, List<String> nightSecondOnCallDoctorIds, bool isApplying
});




}
/// @nodoc
class _$BulkAssignmentStateCopyWithImpl<$Res>
    implements $BulkAssignmentStateCopyWith<$Res> {
  _$BulkAssignmentStateCopyWithImpl(this._self, this._then);

  final BulkAssignmentState _self;
  final $Res Function(BulkAssignmentState) _then;

/// Create a copy of BulkAssignmentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedDepartmentId = freezed,Object? selectedDates = null,Object? dayFirstOnCallDoctorIds = null,Object? daySecondOnCallDoctorIds = null,Object? nightFirstOnCallDoctorIds = null,Object? nightSecondOnCallDoctorIds = null,Object? isApplying = null,}) {
  return _then(_self.copyWith(
selectedDepartmentId: freezed == selectedDepartmentId ? _self.selectedDepartmentId : selectedDepartmentId // ignore: cast_nullable_to_non_nullable
as String?,selectedDates: null == selectedDates ? _self.selectedDates : selectedDates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,dayFirstOnCallDoctorIds: null == dayFirstOnCallDoctorIds ? _self.dayFirstOnCallDoctorIds : dayFirstOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,daySecondOnCallDoctorIds: null == daySecondOnCallDoctorIds ? _self.daySecondOnCallDoctorIds : daySecondOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,nightFirstOnCallDoctorIds: null == nightFirstOnCallDoctorIds ? _self.nightFirstOnCallDoctorIds : nightFirstOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,nightSecondOnCallDoctorIds: null == nightSecondOnCallDoctorIds ? _self.nightSecondOnCallDoctorIds : nightSecondOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,isApplying: null == isApplying ? _self.isApplying : isApplying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkAssignmentState].
extension BulkAssignmentStatePatterns on BulkAssignmentState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkAssignmentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkAssignmentState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkAssignmentState value)  $default,){
final _that = this;
switch (_that) {
case _BulkAssignmentState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkAssignmentState value)?  $default,){
final _that = this;
switch (_that) {
case _BulkAssignmentState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? selectedDepartmentId,  List<DateTime> selectedDates,  List<String> dayFirstOnCallDoctorIds,  List<String> daySecondOnCallDoctorIds,  List<String> nightFirstOnCallDoctorIds,  List<String> nightSecondOnCallDoctorIds,  bool isApplying)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkAssignmentState() when $default != null:
return $default(_that.selectedDepartmentId,_that.selectedDates,_that.dayFirstOnCallDoctorIds,_that.daySecondOnCallDoctorIds,_that.nightFirstOnCallDoctorIds,_that.nightSecondOnCallDoctorIds,_that.isApplying);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? selectedDepartmentId,  List<DateTime> selectedDates,  List<String> dayFirstOnCallDoctorIds,  List<String> daySecondOnCallDoctorIds,  List<String> nightFirstOnCallDoctorIds,  List<String> nightSecondOnCallDoctorIds,  bool isApplying)  $default,) {final _that = this;
switch (_that) {
case _BulkAssignmentState():
return $default(_that.selectedDepartmentId,_that.selectedDates,_that.dayFirstOnCallDoctorIds,_that.daySecondOnCallDoctorIds,_that.nightFirstOnCallDoctorIds,_that.nightSecondOnCallDoctorIds,_that.isApplying);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? selectedDepartmentId,  List<DateTime> selectedDates,  List<String> dayFirstOnCallDoctorIds,  List<String> daySecondOnCallDoctorIds,  List<String> nightFirstOnCallDoctorIds,  List<String> nightSecondOnCallDoctorIds,  bool isApplying)?  $default,) {final _that = this;
switch (_that) {
case _BulkAssignmentState() when $default != null:
return $default(_that.selectedDepartmentId,_that.selectedDates,_that.dayFirstOnCallDoctorIds,_that.daySecondOnCallDoctorIds,_that.nightFirstOnCallDoctorIds,_that.nightSecondOnCallDoctorIds,_that.isApplying);case _:
  return null;

}
}

}

/// @nodoc


class _BulkAssignmentState implements BulkAssignmentState {
  const _BulkAssignmentState({this.selectedDepartmentId, final  List<DateTime> selectedDates = const [], final  List<String> dayFirstOnCallDoctorIds = const [], final  List<String> daySecondOnCallDoctorIds = const [], final  List<String> nightFirstOnCallDoctorIds = const [], final  List<String> nightSecondOnCallDoctorIds = const [], this.isApplying = false}): _selectedDates = selectedDates,_dayFirstOnCallDoctorIds = dayFirstOnCallDoctorIds,_daySecondOnCallDoctorIds = daySecondOnCallDoctorIds,_nightFirstOnCallDoctorIds = nightFirstOnCallDoctorIds,_nightSecondOnCallDoctorIds = nightSecondOnCallDoctorIds;
  

@override final  String? selectedDepartmentId;
 final  List<DateTime> _selectedDates;
@override@JsonKey() List<DateTime> get selectedDates {
  if (_selectedDates is EqualUnmodifiableListView) return _selectedDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedDates);
}

 final  List<String> _dayFirstOnCallDoctorIds;
@override@JsonKey() List<String> get dayFirstOnCallDoctorIds {
  if (_dayFirstOnCallDoctorIds is EqualUnmodifiableListView) return _dayFirstOnCallDoctorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dayFirstOnCallDoctorIds);
}

 final  List<String> _daySecondOnCallDoctorIds;
@override@JsonKey() List<String> get daySecondOnCallDoctorIds {
  if (_daySecondOnCallDoctorIds is EqualUnmodifiableListView) return _daySecondOnCallDoctorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daySecondOnCallDoctorIds);
}

 final  List<String> _nightFirstOnCallDoctorIds;
@override@JsonKey() List<String> get nightFirstOnCallDoctorIds {
  if (_nightFirstOnCallDoctorIds is EqualUnmodifiableListView) return _nightFirstOnCallDoctorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nightFirstOnCallDoctorIds);
}

 final  List<String> _nightSecondOnCallDoctorIds;
@override@JsonKey() List<String> get nightSecondOnCallDoctorIds {
  if (_nightSecondOnCallDoctorIds is EqualUnmodifiableListView) return _nightSecondOnCallDoctorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nightSecondOnCallDoctorIds);
}

@override@JsonKey() final  bool isApplying;

/// Create a copy of BulkAssignmentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkAssignmentStateCopyWith<_BulkAssignmentState> get copyWith => __$BulkAssignmentStateCopyWithImpl<_BulkAssignmentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkAssignmentState&&(identical(other.selectedDepartmentId, selectedDepartmentId) || other.selectedDepartmentId == selectedDepartmentId)&&const DeepCollectionEquality().equals(other._selectedDates, _selectedDates)&&const DeepCollectionEquality().equals(other._dayFirstOnCallDoctorIds, _dayFirstOnCallDoctorIds)&&const DeepCollectionEquality().equals(other._daySecondOnCallDoctorIds, _daySecondOnCallDoctorIds)&&const DeepCollectionEquality().equals(other._nightFirstOnCallDoctorIds, _nightFirstOnCallDoctorIds)&&const DeepCollectionEquality().equals(other._nightSecondOnCallDoctorIds, _nightSecondOnCallDoctorIds)&&(identical(other.isApplying, isApplying) || other.isApplying == isApplying));
}


@override
int get hashCode => Object.hash(runtimeType,selectedDepartmentId,const DeepCollectionEquality().hash(_selectedDates),const DeepCollectionEquality().hash(_dayFirstOnCallDoctorIds),const DeepCollectionEquality().hash(_daySecondOnCallDoctorIds),const DeepCollectionEquality().hash(_nightFirstOnCallDoctorIds),const DeepCollectionEquality().hash(_nightSecondOnCallDoctorIds),isApplying);

@override
String toString() {
  return 'BulkAssignmentState(selectedDepartmentId: $selectedDepartmentId, selectedDates: $selectedDates, dayFirstOnCallDoctorIds: $dayFirstOnCallDoctorIds, daySecondOnCallDoctorIds: $daySecondOnCallDoctorIds, nightFirstOnCallDoctorIds: $nightFirstOnCallDoctorIds, nightSecondOnCallDoctorIds: $nightSecondOnCallDoctorIds, isApplying: $isApplying)';
}


}

/// @nodoc
abstract mixin class _$BulkAssignmentStateCopyWith<$Res> implements $BulkAssignmentStateCopyWith<$Res> {
  factory _$BulkAssignmentStateCopyWith(_BulkAssignmentState value, $Res Function(_BulkAssignmentState) _then) = __$BulkAssignmentStateCopyWithImpl;
@override @useResult
$Res call({
 String? selectedDepartmentId, List<DateTime> selectedDates, List<String> dayFirstOnCallDoctorIds, List<String> daySecondOnCallDoctorIds, List<String> nightFirstOnCallDoctorIds, List<String> nightSecondOnCallDoctorIds, bool isApplying
});




}
/// @nodoc
class __$BulkAssignmentStateCopyWithImpl<$Res>
    implements _$BulkAssignmentStateCopyWith<$Res> {
  __$BulkAssignmentStateCopyWithImpl(this._self, this._then);

  final _BulkAssignmentState _self;
  final $Res Function(_BulkAssignmentState) _then;

/// Create a copy of BulkAssignmentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedDepartmentId = freezed,Object? selectedDates = null,Object? dayFirstOnCallDoctorIds = null,Object? daySecondOnCallDoctorIds = null,Object? nightFirstOnCallDoctorIds = null,Object? nightSecondOnCallDoctorIds = null,Object? isApplying = null,}) {
  return _then(_BulkAssignmentState(
selectedDepartmentId: freezed == selectedDepartmentId ? _self.selectedDepartmentId : selectedDepartmentId // ignore: cast_nullable_to_non_nullable
as String?,selectedDates: null == selectedDates ? _self._selectedDates : selectedDates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,dayFirstOnCallDoctorIds: null == dayFirstOnCallDoctorIds ? _self._dayFirstOnCallDoctorIds : dayFirstOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,daySecondOnCallDoctorIds: null == daySecondOnCallDoctorIds ? _self._daySecondOnCallDoctorIds : daySecondOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,nightFirstOnCallDoctorIds: null == nightFirstOnCallDoctorIds ? _self._nightFirstOnCallDoctorIds : nightFirstOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,nightSecondOnCallDoctorIds: null == nightSecondOnCallDoctorIds ? _self._nightSecondOnCallDoctorIds : nightSecondOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,isApplying: null == isApplying ? _self.isApplying : isApplying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
