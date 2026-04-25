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

 List<String> get selectedDepartmentIds; List<DateTime> get selectedDates; List<String> get firstOnCallDoctorIds; List<String> get secondOnCallDoctorIds; bool get isApplying;
/// Create a copy of BulkAssignmentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkAssignmentStateCopyWith<BulkAssignmentState> get copyWith => _$BulkAssignmentStateCopyWithImpl<BulkAssignmentState>(this as BulkAssignmentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkAssignmentState&&const DeepCollectionEquality().equals(other.selectedDepartmentIds, selectedDepartmentIds)&&const DeepCollectionEquality().equals(other.selectedDates, selectedDates)&&const DeepCollectionEquality().equals(other.firstOnCallDoctorIds, firstOnCallDoctorIds)&&const DeepCollectionEquality().equals(other.secondOnCallDoctorIds, secondOnCallDoctorIds)&&(identical(other.isApplying, isApplying) || other.isApplying == isApplying));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(selectedDepartmentIds),const DeepCollectionEquality().hash(selectedDates),const DeepCollectionEquality().hash(firstOnCallDoctorIds),const DeepCollectionEquality().hash(secondOnCallDoctorIds),isApplying);

@override
String toString() {
  return 'BulkAssignmentState(selectedDepartmentIds: $selectedDepartmentIds, selectedDates: $selectedDates, firstOnCallDoctorIds: $firstOnCallDoctorIds, secondOnCallDoctorIds: $secondOnCallDoctorIds, isApplying: $isApplying)';
}


}

/// @nodoc
abstract mixin class $BulkAssignmentStateCopyWith<$Res>  {
  factory $BulkAssignmentStateCopyWith(BulkAssignmentState value, $Res Function(BulkAssignmentState) _then) = _$BulkAssignmentStateCopyWithImpl;
@useResult
$Res call({
 List<String> selectedDepartmentIds, List<DateTime> selectedDates, List<String> firstOnCallDoctorIds, List<String> secondOnCallDoctorIds, bool isApplying
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
@pragma('vm:prefer-inline') @override $Res call({Object? selectedDepartmentIds = null,Object? selectedDates = null,Object? firstOnCallDoctorIds = null,Object? secondOnCallDoctorIds = null,Object? isApplying = null,}) {
  return _then(_self.copyWith(
selectedDepartmentIds: null == selectedDepartmentIds ? _self.selectedDepartmentIds : selectedDepartmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,selectedDates: null == selectedDates ? _self.selectedDates : selectedDates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,firstOnCallDoctorIds: null == firstOnCallDoctorIds ? _self.firstOnCallDoctorIds : firstOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,secondOnCallDoctorIds: null == secondOnCallDoctorIds ? _self.secondOnCallDoctorIds : secondOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> selectedDepartmentIds,  List<DateTime> selectedDates,  List<String> firstOnCallDoctorIds,  List<String> secondOnCallDoctorIds,  bool isApplying)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkAssignmentState() when $default != null:
return $default(_that.selectedDepartmentIds,_that.selectedDates,_that.firstOnCallDoctorIds,_that.secondOnCallDoctorIds,_that.isApplying);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> selectedDepartmentIds,  List<DateTime> selectedDates,  List<String> firstOnCallDoctorIds,  List<String> secondOnCallDoctorIds,  bool isApplying)  $default,) {final _that = this;
switch (_that) {
case _BulkAssignmentState():
return $default(_that.selectedDepartmentIds,_that.selectedDates,_that.firstOnCallDoctorIds,_that.secondOnCallDoctorIds,_that.isApplying);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> selectedDepartmentIds,  List<DateTime> selectedDates,  List<String> firstOnCallDoctorIds,  List<String> secondOnCallDoctorIds,  bool isApplying)?  $default,) {final _that = this;
switch (_that) {
case _BulkAssignmentState() when $default != null:
return $default(_that.selectedDepartmentIds,_that.selectedDates,_that.firstOnCallDoctorIds,_that.secondOnCallDoctorIds,_that.isApplying);case _:
  return null;

}
}

}

/// @nodoc


class _BulkAssignmentState implements BulkAssignmentState {
  const _BulkAssignmentState({final  List<String> selectedDepartmentIds = const [], final  List<DateTime> selectedDates = const [], final  List<String> firstOnCallDoctorIds = const [], final  List<String> secondOnCallDoctorIds = const [], this.isApplying = false}): _selectedDepartmentIds = selectedDepartmentIds,_selectedDates = selectedDates,_firstOnCallDoctorIds = firstOnCallDoctorIds,_secondOnCallDoctorIds = secondOnCallDoctorIds;
  

 final  List<String> _selectedDepartmentIds;
@override@JsonKey() List<String> get selectedDepartmentIds {
  if (_selectedDepartmentIds is EqualUnmodifiableListView) return _selectedDepartmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedDepartmentIds);
}

 final  List<DateTime> _selectedDates;
@override@JsonKey() List<DateTime> get selectedDates {
  if (_selectedDates is EqualUnmodifiableListView) return _selectedDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedDates);
}

 final  List<String> _firstOnCallDoctorIds;
@override@JsonKey() List<String> get firstOnCallDoctorIds {
  if (_firstOnCallDoctorIds is EqualUnmodifiableListView) return _firstOnCallDoctorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_firstOnCallDoctorIds);
}

 final  List<String> _secondOnCallDoctorIds;
@override@JsonKey() List<String> get secondOnCallDoctorIds {
  if (_secondOnCallDoctorIds is EqualUnmodifiableListView) return _secondOnCallDoctorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_secondOnCallDoctorIds);
}

@override@JsonKey() final  bool isApplying;

/// Create a copy of BulkAssignmentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkAssignmentStateCopyWith<_BulkAssignmentState> get copyWith => __$BulkAssignmentStateCopyWithImpl<_BulkAssignmentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkAssignmentState&&const DeepCollectionEquality().equals(other._selectedDepartmentIds, _selectedDepartmentIds)&&const DeepCollectionEquality().equals(other._selectedDates, _selectedDates)&&const DeepCollectionEquality().equals(other._firstOnCallDoctorIds, _firstOnCallDoctorIds)&&const DeepCollectionEquality().equals(other._secondOnCallDoctorIds, _secondOnCallDoctorIds)&&(identical(other.isApplying, isApplying) || other.isApplying == isApplying));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_selectedDepartmentIds),const DeepCollectionEquality().hash(_selectedDates),const DeepCollectionEquality().hash(_firstOnCallDoctorIds),const DeepCollectionEquality().hash(_secondOnCallDoctorIds),isApplying);

@override
String toString() {
  return 'BulkAssignmentState(selectedDepartmentIds: $selectedDepartmentIds, selectedDates: $selectedDates, firstOnCallDoctorIds: $firstOnCallDoctorIds, secondOnCallDoctorIds: $secondOnCallDoctorIds, isApplying: $isApplying)';
}


}

/// @nodoc
abstract mixin class _$BulkAssignmentStateCopyWith<$Res> implements $BulkAssignmentStateCopyWith<$Res> {
  factory _$BulkAssignmentStateCopyWith(_BulkAssignmentState value, $Res Function(_BulkAssignmentState) _then) = __$BulkAssignmentStateCopyWithImpl;
@override @useResult
$Res call({
 List<String> selectedDepartmentIds, List<DateTime> selectedDates, List<String> firstOnCallDoctorIds, List<String> secondOnCallDoctorIds, bool isApplying
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
@override @pragma('vm:prefer-inline') $Res call({Object? selectedDepartmentIds = null,Object? selectedDates = null,Object? firstOnCallDoctorIds = null,Object? secondOnCallDoctorIds = null,Object? isApplying = null,}) {
  return _then(_BulkAssignmentState(
selectedDepartmentIds: null == selectedDepartmentIds ? _self._selectedDepartmentIds : selectedDepartmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,selectedDates: null == selectedDates ? _self._selectedDates : selectedDates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,firstOnCallDoctorIds: null == firstOnCallDoctorIds ? _self._firstOnCallDoctorIds : firstOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,secondOnCallDoctorIds: null == secondOnCallDoctorIds ? _self._secondOnCallDoctorIds : secondOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,isApplying: null == isApplying ? _self.isApplying : isApplying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
