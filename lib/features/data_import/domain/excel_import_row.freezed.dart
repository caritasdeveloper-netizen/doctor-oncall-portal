// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'excel_import_row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExcelImportRow {

 String get doctorName; String get employeeId; String get phoneNumber; String get department; List<String> get errors; bool get isDuplicate; bool get existsInSystem;
/// Create a copy of ExcelImportRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExcelImportRowCopyWith<ExcelImportRow> get copyWith => _$ExcelImportRowCopyWithImpl<ExcelImportRow>(this as ExcelImportRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExcelImportRow&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.department, department) || other.department == department)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.isDuplicate, isDuplicate) || other.isDuplicate == isDuplicate)&&(identical(other.existsInSystem, existsInSystem) || other.existsInSystem == existsInSystem));
}


@override
int get hashCode => Object.hash(runtimeType,doctorName,employeeId,phoneNumber,department,const DeepCollectionEquality().hash(errors),isDuplicate,existsInSystem);

@override
String toString() {
  return 'ExcelImportRow(doctorName: $doctorName, employeeId: $employeeId, phoneNumber: $phoneNumber, department: $department, errors: $errors, isDuplicate: $isDuplicate, existsInSystem: $existsInSystem)';
}


}

/// @nodoc
abstract mixin class $ExcelImportRowCopyWith<$Res>  {
  factory $ExcelImportRowCopyWith(ExcelImportRow value, $Res Function(ExcelImportRow) _then) = _$ExcelImportRowCopyWithImpl;
@useResult
$Res call({
 String doctorName, String employeeId, String phoneNumber, String department, List<String> errors, bool isDuplicate, bool existsInSystem
});




}
/// @nodoc
class _$ExcelImportRowCopyWithImpl<$Res>
    implements $ExcelImportRowCopyWith<$Res> {
  _$ExcelImportRowCopyWithImpl(this._self, this._then);

  final ExcelImportRow _self;
  final $Res Function(ExcelImportRow) _then;

/// Create a copy of ExcelImportRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? doctorName = null,Object? employeeId = null,Object? phoneNumber = null,Object? department = null,Object? errors = null,Object? isDuplicate = null,Object? existsInSystem = null,}) {
  return _then(_self.copyWith(
doctorName: null == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>,isDuplicate: null == isDuplicate ? _self.isDuplicate : isDuplicate // ignore: cast_nullable_to_non_nullable
as bool,existsInSystem: null == existsInSystem ? _self.existsInSystem : existsInSystem // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExcelImportRow].
extension ExcelImportRowPatterns on ExcelImportRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExcelImportRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExcelImportRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExcelImportRow value)  $default,){
final _that = this;
switch (_that) {
case _ExcelImportRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExcelImportRow value)?  $default,){
final _that = this;
switch (_that) {
case _ExcelImportRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String doctorName,  String employeeId,  String phoneNumber,  String department,  List<String> errors,  bool isDuplicate,  bool existsInSystem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExcelImportRow() when $default != null:
return $default(_that.doctorName,_that.employeeId,_that.phoneNumber,_that.department,_that.errors,_that.isDuplicate,_that.existsInSystem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String doctorName,  String employeeId,  String phoneNumber,  String department,  List<String> errors,  bool isDuplicate,  bool existsInSystem)  $default,) {final _that = this;
switch (_that) {
case _ExcelImportRow():
return $default(_that.doctorName,_that.employeeId,_that.phoneNumber,_that.department,_that.errors,_that.isDuplicate,_that.existsInSystem);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String doctorName,  String employeeId,  String phoneNumber,  String department,  List<String> errors,  bool isDuplicate,  bool existsInSystem)?  $default,) {final _that = this;
switch (_that) {
case _ExcelImportRow() when $default != null:
return $default(_that.doctorName,_that.employeeId,_that.phoneNumber,_that.department,_that.errors,_that.isDuplicate,_that.existsInSystem);case _:
  return null;

}
}

}

/// @nodoc


class _ExcelImportRow extends ExcelImportRow {
  const _ExcelImportRow({required this.doctorName, required this.employeeId, required this.phoneNumber, required this.department, final  List<String> errors = const [], this.isDuplicate = false, this.existsInSystem = false}): _errors = errors,super._();
  

@override final  String doctorName;
@override final  String employeeId;
@override final  String phoneNumber;
@override final  String department;
 final  List<String> _errors;
@override@JsonKey() List<String> get errors {
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_errors);
}

@override@JsonKey() final  bool isDuplicate;
@override@JsonKey() final  bool existsInSystem;

/// Create a copy of ExcelImportRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExcelImportRowCopyWith<_ExcelImportRow> get copyWith => __$ExcelImportRowCopyWithImpl<_ExcelImportRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExcelImportRow&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.department, department) || other.department == department)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.isDuplicate, isDuplicate) || other.isDuplicate == isDuplicate)&&(identical(other.existsInSystem, existsInSystem) || other.existsInSystem == existsInSystem));
}


@override
int get hashCode => Object.hash(runtimeType,doctorName,employeeId,phoneNumber,department,const DeepCollectionEquality().hash(_errors),isDuplicate,existsInSystem);

@override
String toString() {
  return 'ExcelImportRow(doctorName: $doctorName, employeeId: $employeeId, phoneNumber: $phoneNumber, department: $department, errors: $errors, isDuplicate: $isDuplicate, existsInSystem: $existsInSystem)';
}


}

/// @nodoc
abstract mixin class _$ExcelImportRowCopyWith<$Res> implements $ExcelImportRowCopyWith<$Res> {
  factory _$ExcelImportRowCopyWith(_ExcelImportRow value, $Res Function(_ExcelImportRow) _then) = __$ExcelImportRowCopyWithImpl;
@override @useResult
$Res call({
 String doctorName, String employeeId, String phoneNumber, String department, List<String> errors, bool isDuplicate, bool existsInSystem
});




}
/// @nodoc
class __$ExcelImportRowCopyWithImpl<$Res>
    implements _$ExcelImportRowCopyWith<$Res> {
  __$ExcelImportRowCopyWithImpl(this._self, this._then);

  final _ExcelImportRow _self;
  final $Res Function(_ExcelImportRow) _then;

/// Create a copy of ExcelImportRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? doctorName = null,Object? employeeId = null,Object? phoneNumber = null,Object? department = null,Object? errors = null,Object? isDuplicate = null,Object? existsInSystem = null,}) {
  return _then(_ExcelImportRow(
doctorName: null == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>,isDuplicate: null == isDuplicate ? _self.isDuplicate : isDuplicate // ignore: cast_nullable_to_non_nullable
as bool,existsInSystem: null == existsInSystem ? _self.existsInSystem : existsInSystem // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
