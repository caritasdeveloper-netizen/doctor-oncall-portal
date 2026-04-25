// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doctor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Doctor {

 String get id; String get employeeId; String get name; String get phoneNumber; List<String> get departmentIds;
/// Create a copy of Doctor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoctorCopyWith<Doctor> get copyWith => _$DoctorCopyWithImpl<Doctor>(this as Doctor, _$identity);

  /// Serializes this Doctor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Doctor&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&const DeepCollectionEquality().equals(other.departmentIds, departmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,name,phoneNumber,const DeepCollectionEquality().hash(departmentIds));

@override
String toString() {
  return 'Doctor(id: $id, employeeId: $employeeId, name: $name, phoneNumber: $phoneNumber, departmentIds: $departmentIds)';
}


}

/// @nodoc
abstract mixin class $DoctorCopyWith<$Res>  {
  factory $DoctorCopyWith(Doctor value, $Res Function(Doctor) _then) = _$DoctorCopyWithImpl;
@useResult
$Res call({
 String id, String employeeId, String name, String phoneNumber, List<String> departmentIds
});




}
/// @nodoc
class _$DoctorCopyWithImpl<$Res>
    implements $DoctorCopyWith<$Res> {
  _$DoctorCopyWithImpl(this._self, this._then);

  final Doctor _self;
  final $Res Function(Doctor) _then;

/// Create a copy of Doctor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeId = null,Object? name = null,Object? phoneNumber = null,Object? departmentIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,departmentIds: null == departmentIds ? _self.departmentIds : departmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Doctor].
extension DoctorPatterns on Doctor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Doctor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Doctor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Doctor value)  $default,){
final _that = this;
switch (_that) {
case _Doctor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Doctor value)?  $default,){
final _that = this;
switch (_that) {
case _Doctor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String employeeId,  String name,  String phoneNumber,  List<String> departmentIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Doctor() when $default != null:
return $default(_that.id,_that.employeeId,_that.name,_that.phoneNumber,_that.departmentIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String employeeId,  String name,  String phoneNumber,  List<String> departmentIds)  $default,) {final _that = this;
switch (_that) {
case _Doctor():
return $default(_that.id,_that.employeeId,_that.name,_that.phoneNumber,_that.departmentIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String employeeId,  String name,  String phoneNumber,  List<String> departmentIds)?  $default,) {final _that = this;
switch (_that) {
case _Doctor() when $default != null:
return $default(_that.id,_that.employeeId,_that.name,_that.phoneNumber,_that.departmentIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Doctor implements Doctor {
  const _Doctor({required this.id, required this.employeeId, required this.name, required this.phoneNumber, required final  List<String> departmentIds}): _departmentIds = departmentIds;
  factory _Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

@override final  String id;
@override final  String employeeId;
@override final  String name;
@override final  String phoneNumber;
 final  List<String> _departmentIds;
@override List<String> get departmentIds {
  if (_departmentIds is EqualUnmodifiableListView) return _departmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_departmentIds);
}


/// Create a copy of Doctor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoctorCopyWith<_Doctor> get copyWith => __$DoctorCopyWithImpl<_Doctor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoctorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Doctor&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&const DeepCollectionEquality().equals(other._departmentIds, _departmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,name,phoneNumber,const DeepCollectionEquality().hash(_departmentIds));

@override
String toString() {
  return 'Doctor(id: $id, employeeId: $employeeId, name: $name, phoneNumber: $phoneNumber, departmentIds: $departmentIds)';
}


}

/// @nodoc
abstract mixin class _$DoctorCopyWith<$Res> implements $DoctorCopyWith<$Res> {
  factory _$DoctorCopyWith(_Doctor value, $Res Function(_Doctor) _then) = __$DoctorCopyWithImpl;
@override @useResult
$Res call({
 String id, String employeeId, String name, String phoneNumber, List<String> departmentIds
});




}
/// @nodoc
class __$DoctorCopyWithImpl<$Res>
    implements _$DoctorCopyWith<$Res> {
  __$DoctorCopyWithImpl(this._self, this._then);

  final _Doctor _self;
  final $Res Function(_Doctor) _then;

/// Create a copy of Doctor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeId = null,Object? name = null,Object? phoneNumber = null,Object? departmentIds = null,}) {
  return _then(_Doctor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,departmentIds: null == departmentIds ? _self._departmentIds : departmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
