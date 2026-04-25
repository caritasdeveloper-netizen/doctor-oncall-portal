// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailySchedule {

 String get id; DateTime get date; String get departmentId; List<String> get firstOnCallDoctorIds; List<String> get secondOnCallDoctorIds;
/// Create a copy of DailySchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyScheduleCopyWith<DailySchedule> get copyWith => _$DailyScheduleCopyWithImpl<DailySchedule>(this as DailySchedule, _$identity);

  /// Serializes this DailySchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailySchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&const DeepCollectionEquality().equals(other.firstOnCallDoctorIds, firstOnCallDoctorIds)&&const DeepCollectionEquality().equals(other.secondOnCallDoctorIds, secondOnCallDoctorIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,departmentId,const DeepCollectionEquality().hash(firstOnCallDoctorIds),const DeepCollectionEquality().hash(secondOnCallDoctorIds));

@override
String toString() {
  return 'DailySchedule(id: $id, date: $date, departmentId: $departmentId, firstOnCallDoctorIds: $firstOnCallDoctorIds, secondOnCallDoctorIds: $secondOnCallDoctorIds)';
}


}

/// @nodoc
abstract mixin class $DailyScheduleCopyWith<$Res>  {
  factory $DailyScheduleCopyWith(DailySchedule value, $Res Function(DailySchedule) _then) = _$DailyScheduleCopyWithImpl;
@useResult
$Res call({
 String id, DateTime date, String departmentId, List<String> firstOnCallDoctorIds, List<String> secondOnCallDoctorIds
});




}
/// @nodoc
class _$DailyScheduleCopyWithImpl<$Res>
    implements $DailyScheduleCopyWith<$Res> {
  _$DailyScheduleCopyWithImpl(this._self, this._then);

  final DailySchedule _self;
  final $Res Function(DailySchedule) _then;

/// Create a copy of DailySchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? departmentId = null,Object? firstOnCallDoctorIds = null,Object? secondOnCallDoctorIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,firstOnCallDoctorIds: null == firstOnCallDoctorIds ? _self.firstOnCallDoctorIds : firstOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,secondOnCallDoctorIds: null == secondOnCallDoctorIds ? _self.secondOnCallDoctorIds : secondOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DailySchedule].
extension DailySchedulePatterns on DailySchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailySchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailySchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailySchedule value)  $default,){
final _that = this;
switch (_that) {
case _DailySchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailySchedule value)?  $default,){
final _that = this;
switch (_that) {
case _DailySchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime date,  String departmentId,  List<String> firstOnCallDoctorIds,  List<String> secondOnCallDoctorIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailySchedule() when $default != null:
return $default(_that.id,_that.date,_that.departmentId,_that.firstOnCallDoctorIds,_that.secondOnCallDoctorIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime date,  String departmentId,  List<String> firstOnCallDoctorIds,  List<String> secondOnCallDoctorIds)  $default,) {final _that = this;
switch (_that) {
case _DailySchedule():
return $default(_that.id,_that.date,_that.departmentId,_that.firstOnCallDoctorIds,_that.secondOnCallDoctorIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime date,  String departmentId,  List<String> firstOnCallDoctorIds,  List<String> secondOnCallDoctorIds)?  $default,) {final _that = this;
switch (_that) {
case _DailySchedule() when $default != null:
return $default(_that.id,_that.date,_that.departmentId,_that.firstOnCallDoctorIds,_that.secondOnCallDoctorIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailySchedule implements DailySchedule {
  const _DailySchedule({required this.id, required this.date, required this.departmentId, final  List<String> firstOnCallDoctorIds = const [], final  List<String> secondOnCallDoctorIds = const []}): _firstOnCallDoctorIds = firstOnCallDoctorIds,_secondOnCallDoctorIds = secondOnCallDoctorIds;
  factory _DailySchedule.fromJson(Map<String, dynamic> json) => _$DailyScheduleFromJson(json);

@override final  String id;
@override final  DateTime date;
@override final  String departmentId;
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


/// Create a copy of DailySchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyScheduleCopyWith<_DailySchedule> get copyWith => __$DailyScheduleCopyWithImpl<_DailySchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailySchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&const DeepCollectionEquality().equals(other._firstOnCallDoctorIds, _firstOnCallDoctorIds)&&const DeepCollectionEquality().equals(other._secondOnCallDoctorIds, _secondOnCallDoctorIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,departmentId,const DeepCollectionEquality().hash(_firstOnCallDoctorIds),const DeepCollectionEquality().hash(_secondOnCallDoctorIds));

@override
String toString() {
  return 'DailySchedule(id: $id, date: $date, departmentId: $departmentId, firstOnCallDoctorIds: $firstOnCallDoctorIds, secondOnCallDoctorIds: $secondOnCallDoctorIds)';
}


}

/// @nodoc
abstract mixin class _$DailyScheduleCopyWith<$Res> implements $DailyScheduleCopyWith<$Res> {
  factory _$DailyScheduleCopyWith(_DailySchedule value, $Res Function(_DailySchedule) _then) = __$DailyScheduleCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime date, String departmentId, List<String> firstOnCallDoctorIds, List<String> secondOnCallDoctorIds
});




}
/// @nodoc
class __$DailyScheduleCopyWithImpl<$Res>
    implements _$DailyScheduleCopyWith<$Res> {
  __$DailyScheduleCopyWithImpl(this._self, this._then);

  final _DailySchedule _self;
  final $Res Function(_DailySchedule) _then;

/// Create a copy of DailySchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? departmentId = null,Object? firstOnCallDoctorIds = null,Object? secondOnCallDoctorIds = null,}) {
  return _then(_DailySchedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,firstOnCallDoctorIds: null == firstOnCallDoctorIds ? _self._firstOnCallDoctorIds : firstOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,secondOnCallDoctorIds: null == secondOnCallDoctorIds ? _self._secondOnCallDoctorIds : secondOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$BulkAssignmentRequest {

 List<String> get departmentIds; List<DateTime> get dates; List<String> get firstOnCallDoctorIds; List<String> get secondOnCallDoctorIds; bool get overrideExisting;
/// Create a copy of BulkAssignmentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkAssignmentRequestCopyWith<BulkAssignmentRequest> get copyWith => _$BulkAssignmentRequestCopyWithImpl<BulkAssignmentRequest>(this as BulkAssignmentRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkAssignmentRequest&&const DeepCollectionEquality().equals(other.departmentIds, departmentIds)&&const DeepCollectionEquality().equals(other.dates, dates)&&const DeepCollectionEquality().equals(other.firstOnCallDoctorIds, firstOnCallDoctorIds)&&const DeepCollectionEquality().equals(other.secondOnCallDoctorIds, secondOnCallDoctorIds)&&(identical(other.overrideExisting, overrideExisting) || other.overrideExisting == overrideExisting));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(departmentIds),const DeepCollectionEquality().hash(dates),const DeepCollectionEquality().hash(firstOnCallDoctorIds),const DeepCollectionEquality().hash(secondOnCallDoctorIds),overrideExisting);

@override
String toString() {
  return 'BulkAssignmentRequest(departmentIds: $departmentIds, dates: $dates, firstOnCallDoctorIds: $firstOnCallDoctorIds, secondOnCallDoctorIds: $secondOnCallDoctorIds, overrideExisting: $overrideExisting)';
}


}

/// @nodoc
abstract mixin class $BulkAssignmentRequestCopyWith<$Res>  {
  factory $BulkAssignmentRequestCopyWith(BulkAssignmentRequest value, $Res Function(BulkAssignmentRequest) _then) = _$BulkAssignmentRequestCopyWithImpl;
@useResult
$Res call({
 List<String> departmentIds, List<DateTime> dates, List<String> firstOnCallDoctorIds, List<String> secondOnCallDoctorIds, bool overrideExisting
});




}
/// @nodoc
class _$BulkAssignmentRequestCopyWithImpl<$Res>
    implements $BulkAssignmentRequestCopyWith<$Res> {
  _$BulkAssignmentRequestCopyWithImpl(this._self, this._then);

  final BulkAssignmentRequest _self;
  final $Res Function(BulkAssignmentRequest) _then;

/// Create a copy of BulkAssignmentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentIds = null,Object? dates = null,Object? firstOnCallDoctorIds = null,Object? secondOnCallDoctorIds = null,Object? overrideExisting = null,}) {
  return _then(_self.copyWith(
departmentIds: null == departmentIds ? _self.departmentIds : departmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,dates: null == dates ? _self.dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,firstOnCallDoctorIds: null == firstOnCallDoctorIds ? _self.firstOnCallDoctorIds : firstOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,secondOnCallDoctorIds: null == secondOnCallDoctorIds ? _self.secondOnCallDoctorIds : secondOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,overrideExisting: null == overrideExisting ? _self.overrideExisting : overrideExisting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkAssignmentRequest].
extension BulkAssignmentRequestPatterns on BulkAssignmentRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkAssignmentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkAssignmentRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkAssignmentRequest value)  $default,){
final _that = this;
switch (_that) {
case _BulkAssignmentRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkAssignmentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _BulkAssignmentRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> departmentIds,  List<DateTime> dates,  List<String> firstOnCallDoctorIds,  List<String> secondOnCallDoctorIds,  bool overrideExisting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkAssignmentRequest() when $default != null:
return $default(_that.departmentIds,_that.dates,_that.firstOnCallDoctorIds,_that.secondOnCallDoctorIds,_that.overrideExisting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> departmentIds,  List<DateTime> dates,  List<String> firstOnCallDoctorIds,  List<String> secondOnCallDoctorIds,  bool overrideExisting)  $default,) {final _that = this;
switch (_that) {
case _BulkAssignmentRequest():
return $default(_that.departmentIds,_that.dates,_that.firstOnCallDoctorIds,_that.secondOnCallDoctorIds,_that.overrideExisting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> departmentIds,  List<DateTime> dates,  List<String> firstOnCallDoctorIds,  List<String> secondOnCallDoctorIds,  bool overrideExisting)?  $default,) {final _that = this;
switch (_that) {
case _BulkAssignmentRequest() when $default != null:
return $default(_that.departmentIds,_that.dates,_that.firstOnCallDoctorIds,_that.secondOnCallDoctorIds,_that.overrideExisting);case _:
  return null;

}
}

}

/// @nodoc


class _BulkAssignmentRequest implements BulkAssignmentRequest {
  const _BulkAssignmentRequest({required final  List<String> departmentIds, required final  List<DateTime> dates, required final  List<String> firstOnCallDoctorIds, required final  List<String> secondOnCallDoctorIds, required this.overrideExisting}): _departmentIds = departmentIds,_dates = dates,_firstOnCallDoctorIds = firstOnCallDoctorIds,_secondOnCallDoctorIds = secondOnCallDoctorIds;
  

 final  List<String> _departmentIds;
@override List<String> get departmentIds {
  if (_departmentIds is EqualUnmodifiableListView) return _departmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_departmentIds);
}

 final  List<DateTime> _dates;
@override List<DateTime> get dates {
  if (_dates is EqualUnmodifiableListView) return _dates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dates);
}

 final  List<String> _firstOnCallDoctorIds;
@override List<String> get firstOnCallDoctorIds {
  if (_firstOnCallDoctorIds is EqualUnmodifiableListView) return _firstOnCallDoctorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_firstOnCallDoctorIds);
}

 final  List<String> _secondOnCallDoctorIds;
@override List<String> get secondOnCallDoctorIds {
  if (_secondOnCallDoctorIds is EqualUnmodifiableListView) return _secondOnCallDoctorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_secondOnCallDoctorIds);
}

@override final  bool overrideExisting;

/// Create a copy of BulkAssignmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkAssignmentRequestCopyWith<_BulkAssignmentRequest> get copyWith => __$BulkAssignmentRequestCopyWithImpl<_BulkAssignmentRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkAssignmentRequest&&const DeepCollectionEquality().equals(other._departmentIds, _departmentIds)&&const DeepCollectionEquality().equals(other._dates, _dates)&&const DeepCollectionEquality().equals(other._firstOnCallDoctorIds, _firstOnCallDoctorIds)&&const DeepCollectionEquality().equals(other._secondOnCallDoctorIds, _secondOnCallDoctorIds)&&(identical(other.overrideExisting, overrideExisting) || other.overrideExisting == overrideExisting));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_departmentIds),const DeepCollectionEquality().hash(_dates),const DeepCollectionEquality().hash(_firstOnCallDoctorIds),const DeepCollectionEquality().hash(_secondOnCallDoctorIds),overrideExisting);

@override
String toString() {
  return 'BulkAssignmentRequest(departmentIds: $departmentIds, dates: $dates, firstOnCallDoctorIds: $firstOnCallDoctorIds, secondOnCallDoctorIds: $secondOnCallDoctorIds, overrideExisting: $overrideExisting)';
}


}

/// @nodoc
abstract mixin class _$BulkAssignmentRequestCopyWith<$Res> implements $BulkAssignmentRequestCopyWith<$Res> {
  factory _$BulkAssignmentRequestCopyWith(_BulkAssignmentRequest value, $Res Function(_BulkAssignmentRequest) _then) = __$BulkAssignmentRequestCopyWithImpl;
@override @useResult
$Res call({
 List<String> departmentIds, List<DateTime> dates, List<String> firstOnCallDoctorIds, List<String> secondOnCallDoctorIds, bool overrideExisting
});




}
/// @nodoc
class __$BulkAssignmentRequestCopyWithImpl<$Res>
    implements _$BulkAssignmentRequestCopyWith<$Res> {
  __$BulkAssignmentRequestCopyWithImpl(this._self, this._then);

  final _BulkAssignmentRequest _self;
  final $Res Function(_BulkAssignmentRequest) _then;

/// Create a copy of BulkAssignmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentIds = null,Object? dates = null,Object? firstOnCallDoctorIds = null,Object? secondOnCallDoctorIds = null,Object? overrideExisting = null,}) {
  return _then(_BulkAssignmentRequest(
departmentIds: null == departmentIds ? _self._departmentIds : departmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,dates: null == dates ? _self._dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,firstOnCallDoctorIds: null == firstOnCallDoctorIds ? _self._firstOnCallDoctorIds : firstOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,secondOnCallDoctorIds: null == secondOnCallDoctorIds ? _self._secondOnCallDoctorIds : secondOnCallDoctorIds // ignore: cast_nullable_to_non_nullable
as List<String>,overrideExisting: null == overrideExisting ? _self.overrideExisting : overrideExisting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
