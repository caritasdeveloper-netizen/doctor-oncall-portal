// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduling_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SchedulingState {

 DateTime get selectedDate; String get searchQuery; Map<String, DailySchedule> get draftSchedules; Map<String, DailySchedule> get originalSchedules; bool get isSaving;
/// Create a copy of SchedulingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchedulingStateCopyWith<SchedulingState> get copyWith => _$SchedulingStateCopyWithImpl<SchedulingState>(this as SchedulingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchedulingState&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other.draftSchedules, draftSchedules)&&const DeepCollectionEquality().equals(other.originalSchedules, originalSchedules)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving));
}


@override
int get hashCode => Object.hash(runtimeType,selectedDate,searchQuery,const DeepCollectionEquality().hash(draftSchedules),const DeepCollectionEquality().hash(originalSchedules),isSaving);

@override
String toString() {
  return 'SchedulingState(selectedDate: $selectedDate, searchQuery: $searchQuery, draftSchedules: $draftSchedules, originalSchedules: $originalSchedules, isSaving: $isSaving)';
}


}

/// @nodoc
abstract mixin class $SchedulingStateCopyWith<$Res>  {
  factory $SchedulingStateCopyWith(SchedulingState value, $Res Function(SchedulingState) _then) = _$SchedulingStateCopyWithImpl;
@useResult
$Res call({
 DateTime selectedDate, String searchQuery, Map<String, DailySchedule> draftSchedules, Map<String, DailySchedule> originalSchedules, bool isSaving
});




}
/// @nodoc
class _$SchedulingStateCopyWithImpl<$Res>
    implements $SchedulingStateCopyWith<$Res> {
  _$SchedulingStateCopyWithImpl(this._self, this._then);

  final SchedulingState _self;
  final $Res Function(SchedulingState) _then;

/// Create a copy of SchedulingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedDate = null,Object? searchQuery = null,Object? draftSchedules = null,Object? originalSchedules = null,Object? isSaving = null,}) {
  return _then(_self.copyWith(
selectedDate: null == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,draftSchedules: null == draftSchedules ? _self.draftSchedules : draftSchedules // ignore: cast_nullable_to_non_nullable
as Map<String, DailySchedule>,originalSchedules: null == originalSchedules ? _self.originalSchedules : originalSchedules // ignore: cast_nullable_to_non_nullable
as Map<String, DailySchedule>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SchedulingState].
extension SchedulingStatePatterns on SchedulingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchedulingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchedulingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchedulingState value)  $default,){
final _that = this;
switch (_that) {
case _SchedulingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchedulingState value)?  $default,){
final _that = this;
switch (_that) {
case _SchedulingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime selectedDate,  String searchQuery,  Map<String, DailySchedule> draftSchedules,  Map<String, DailySchedule> originalSchedules,  bool isSaving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchedulingState() when $default != null:
return $default(_that.selectedDate,_that.searchQuery,_that.draftSchedules,_that.originalSchedules,_that.isSaving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime selectedDate,  String searchQuery,  Map<String, DailySchedule> draftSchedules,  Map<String, DailySchedule> originalSchedules,  bool isSaving)  $default,) {final _that = this;
switch (_that) {
case _SchedulingState():
return $default(_that.selectedDate,_that.searchQuery,_that.draftSchedules,_that.originalSchedules,_that.isSaving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime selectedDate,  String searchQuery,  Map<String, DailySchedule> draftSchedules,  Map<String, DailySchedule> originalSchedules,  bool isSaving)?  $default,) {final _that = this;
switch (_that) {
case _SchedulingState() when $default != null:
return $default(_that.selectedDate,_that.searchQuery,_that.draftSchedules,_that.originalSchedules,_that.isSaving);case _:
  return null;

}
}

}

/// @nodoc


class _SchedulingState extends SchedulingState {
  const _SchedulingState({required this.selectedDate, this.searchQuery = '', final  Map<String, DailySchedule> draftSchedules = const {}, final  Map<String, DailySchedule> originalSchedules = const {}, this.isSaving = false}): _draftSchedules = draftSchedules,_originalSchedules = originalSchedules,super._();
  

@override final  DateTime selectedDate;
@override@JsonKey() final  String searchQuery;
 final  Map<String, DailySchedule> _draftSchedules;
@override@JsonKey() Map<String, DailySchedule> get draftSchedules {
  if (_draftSchedules is EqualUnmodifiableMapView) return _draftSchedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_draftSchedules);
}

 final  Map<String, DailySchedule> _originalSchedules;
@override@JsonKey() Map<String, DailySchedule> get originalSchedules {
  if (_originalSchedules is EqualUnmodifiableMapView) return _originalSchedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_originalSchedules);
}

@override@JsonKey() final  bool isSaving;

/// Create a copy of SchedulingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchedulingStateCopyWith<_SchedulingState> get copyWith => __$SchedulingStateCopyWithImpl<_SchedulingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchedulingState&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other._draftSchedules, _draftSchedules)&&const DeepCollectionEquality().equals(other._originalSchedules, _originalSchedules)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving));
}


@override
int get hashCode => Object.hash(runtimeType,selectedDate,searchQuery,const DeepCollectionEquality().hash(_draftSchedules),const DeepCollectionEquality().hash(_originalSchedules),isSaving);

@override
String toString() {
  return 'SchedulingState(selectedDate: $selectedDate, searchQuery: $searchQuery, draftSchedules: $draftSchedules, originalSchedules: $originalSchedules, isSaving: $isSaving)';
}


}

/// @nodoc
abstract mixin class _$SchedulingStateCopyWith<$Res> implements $SchedulingStateCopyWith<$Res> {
  factory _$SchedulingStateCopyWith(_SchedulingState value, $Res Function(_SchedulingState) _then) = __$SchedulingStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime selectedDate, String searchQuery, Map<String, DailySchedule> draftSchedules, Map<String, DailySchedule> originalSchedules, bool isSaving
});




}
/// @nodoc
class __$SchedulingStateCopyWithImpl<$Res>
    implements _$SchedulingStateCopyWith<$Res> {
  __$SchedulingStateCopyWithImpl(this._self, this._then);

  final _SchedulingState _self;
  final $Res Function(_SchedulingState) _then;

/// Create a copy of SchedulingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedDate = null,Object? searchQuery = null,Object? draftSchedules = null,Object? originalSchedules = null,Object? isSaving = null,}) {
  return _then(_SchedulingState(
selectedDate: null == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,draftSchedules: null == draftSchedules ? _self._draftSchedules : draftSchedules // ignore: cast_nullable_to_non_nullable
as Map<String, DailySchedule>,originalSchedules: null == originalSchedules ? _self._originalSchedules : originalSchedules // ignore: cast_nullable_to_non_nullable
as Map<String, DailySchedule>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
